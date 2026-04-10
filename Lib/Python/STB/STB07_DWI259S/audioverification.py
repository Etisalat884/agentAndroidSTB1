import soundfile as sf
import numpy as np
import subprocess
import time

def record_audio(device="hw:1,0", duration=5, filename="/tmp/audio_test.wav"):
    cmd = [
        "pasuspender", "--",
        "arecord", "-D", device, "-d", str(duration),
        "-f", "S16_LE", "-c", "2", "-r", "48000", filename
    ]
    subprocess.run(cmd, check=True)

def analyze_rms(filename="/tmp/audio_test.wav"):
    data, _ = sf.read(filename)
    mono = np.mean(data, axis=1)
    rms = np.sqrt(np.mean(mono ** 2))
    return rms

def get_average_rms(device="hw:1,0", checks=5, duration=5, wait=2):
    rms_values = []
    for i in range(checks):
        print(f"Recording {i+1}/{checks}...")
        record_audio(device=device, duration=duration)
        rms = analyze_rms()
        print(f"RMS {i+1}: {rms:.5f}")
        rms_values.append(rms)
        time.sleep(wait)

    avg_rms = sum(rms_values) / len(rms_values)
    print(f"\n📊 Average RMS: {avg_rms:.5f}")
    return round(avg_rms, 5)

if __name__ == "__main__":
    avg = get_average_rms()
    print(avg)  # Robot Framework will capture this final line