#To test manually
# Mute return 0
# Low return 1 [Volume progress should more the 50%]
# High return 2

import soundfile as sf
import numpy as np
import subprocess
import time

class AudioQuality:
    def __init__(self):
        pass

    def record_audio(self, device="hw:1,0", duration=5, filename="/tmp/audio_test.wav"):
        """
        Records audio using arecord via pasuspender (suspends pulseaudio temporarily).
        """
        cmd = [
            "pasuspender", "--",
            "arecord", "-D", device, "-d", str(duration),
            "-f", "S16_LE", "-c", "2", "-r", "48000", filename
        ]
        subprocess.run(cmd, check=True)

    def analyze_audio(self, filename="/tmp/audio_test.wav"):
        """
        Analyzes audio file and returns RMS value, or None if no audio detected.
        """
        data, _ = sf.read(filename)
        mono = np.mean(data, axis=1)

        rms = np.sqrt(np.mean(mono ** 2))
        if rms < 0.001:  # threshold for silence
            return None

        return rms

    def classify_audio(self, rms_avg):
        """
        Classifies audio based on average RMS.
        0 = No audio, 1 = Low, 2 = High
        """
        if rms_avg is None:
            return 0
        elif rms_avg < 0.01:
            return 0  # effectively muted
        elif rms_avg < 0.05:
            return 1  # low audio
        else:
            return 2  # high audio

    def check_audio_quality(self, device="hw:1,0", checks=3, duration=5, wait=5):
        """
        Records multiple times, calculates average RMS, and returns:
        0 = No audio
        1 = Low
        2 = High
        """
        rms_values = []
        for i in range(checks):
            print(f"Recording {i+1}/{checks}...")
            # use the record_audio() method with pasuspender
            self.record_audio(device=device, duration=duration, filename="/tmp/audio_test.wav")

            data, _ = sf.read("/tmp/audio_test.wav")
            mono = np.mean(data, axis=1)
            rms = np.sqrt(np.mean(mono ** 2))
            if rms > 0.001:  # valid audio
                rms_values.append(rms)

            time.sleep(wait)

        if not rms_values:
            return 0
        avg_rms = sum(rms_values) / len(rms_values)
        if avg_rms < 0.01:
            return 0
        elif avg_rms < 0.05:
            return 1
        else:
            return 2


if __name__ == "__main__":
    aq = AudioQuality()
    result = aq.check_audio_quality(device="hw:1,0", checks=3, duration=5, wait=5)
    print(f"\nFinal Audio Quality Result: {result}")
    if result == 0:
        print("Audio is muted / no audio")
    elif result == 1:
        print("Audio is low")
    elif result == 2:
        print("Audio is high")
