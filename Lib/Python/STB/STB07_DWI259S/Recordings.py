import os
import glob
import xml.etree.ElementTree as ET
from datetime import datetime, timedelta
import subprocess
import platform


class VideoLogOverlay:
    def __init__(self, font_path=None):
        # Use Arial on Windows, DejaVu on *nix
        if font_path:
            self.font_path = font_path
        else:
            self.font_path = (
                r"C:\Windows\Fonts\arial.ttf"
                if platform.system() == 'Windows'
                else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
            )

        self.recording_start = None
        self.recording_stop = None
        self.logs = []
        self.testcases = []
        self.latest_xml = None
        self.input_video = None
        self.output_video = None
        self.xml_dir = None
        self.video_dir = None
        self.output_dir = None

    @staticmethod
    def parse_time(ts_str, fmt=None):
        """Parse ISO or Robot's YYYYMMDD style timestamp."""
        if not ts_str:
            return None
        if fmt:
            return datetime.strptime(ts_str, fmt)
        try:
            return datetime.strptime(ts_str, "%Y-%m-%dT%H:%M:%S.%f")
        except ValueError:
            return datetime.strptime(ts_str, "%Y%m%d %H:%M:%S.%f")

    def get_latest_xml(self):
        xmls = glob.glob(os.path.join(self.xml_dir, "*.xml"))
        if not xmls:
            raise FileNotFoundError(f"No XML files in {self.xml_dir}")
        self.latest_xml = max(xmls, key=os.path.getmtime)
        return self.latest_xml

    def parse_xml(self):
        tree = ET.parse(self.latest_xml)
        root = tree.getroot()
        for kw in root.iter('kw'):
            nm = kw.attrib.get('name', '')
            if nm == 'Start Process':
                self.recording_start = self.parse_time(
                    kw.find('status').attrib.get('start')
                )
            elif nm == 'Terminate Process':
                self.recording_stop = self.parse_time(
                    kw.find('status').attrib.get('start')
                )
            if self.recording_start and self.recording_stop:
                break
        if not (self.recording_start and self.recording_stop):
            raise ValueError("Could not find recording start/stop in XML.")

    def parse_testcases(self):
        """
        Extract each <test>…<status start=… elapsed=…> and compute both start & end.
        """
        tree = ET.parse(self.latest_xml)
        root = tree.getroot()

        # strip namespace if present
        ns = ''
        if root.tag.startswith('{'):
            ns = root.tag.split('}')[0] + '}'

        for test in root.findall(f'.//{ns}test'):
            name = test.attrib.get('name')
            status = test.find(f'{ns}status')
            if not (name and status is not None):
                continue

            start_s = status.attrib.get('start')
            elapsed = status.attrib.get('elapsed')
            end_s = status.attrib.get('endtime') or status.attrib.get('end')

            # parse start
            fmt = "%Y%m%d %H:%M:%S.%f" if ' ' in start_s else "%Y-%m-%dT%H:%M:%S.%f"
            dt_start = self.parse_time(start_s, fmt)

            # parse or compute end
            if end_s:
                dt_end = self.parse_time(end_s, fmt)
            elif elapsed:
                dt_end = dt_start + timedelta(seconds=float(elapsed))
            else:
                print(f"[WARN] no end or elapsed for '{name}', skipping")
                continue

            off_start = (dt_start - self.recording_start).total_seconds()
            off_end = (dt_end - self.recording_start).total_seconds()
            self.testcases.append((off_start, off_end, name))

        if not self.testcases:
            raise ValueError("No valid <test> entries found in XML.")

    def collect_logs(self):
        tree = ET.parse(self.latest_xml)
        root = tree.getroot()
        for kw in root.iter('kw'):
            if kw.attrib.get('name') == 'Log To Console':
                arg = kw.find('arg')
                status = kw.find('status')
                if arg is not None and status is not None and arg.text is not None:
                    ts = status.attrib.get('start')
                    dt = self.parse_time(ts)
                    if self.recording_start <= dt <= self.recording_stop:
                        off = (dt - self.recording_start).total_seconds()
                        self.logs.append((off, arg.text.strip()))

    def collected_logs(self):
        tree = ET.parse(self.latest_xml)
        root = tree.getroot()
        log_lines = []
        for kw in root.iter('kw'):
            if kw.attrib.get('name') == 'Log To Console':
                arg = kw.find('arg')
                status = kw.find('status')
                if arg is not None and status is not None and arg.text is not None:
                    ts = status.attrib.get('start')
                    dt = self.parse_time(ts)
                    if self.recording_start <= dt <= self.recording_stop:
                        off = (dt - self.recording_start).total_seconds()
                        msg = arg.text.strip()
                        self.logs.append((off, msg))
                        log_lines.append(f"[{off:.2f} s] {msg}")

        # Write all logs to a text file
        log_file = os.path.join(self.output_dir, "console_logs.txt")
        with open(log_file, "w", encoding="utf-8") as f:
            for line in log_lines:
                f.write(line + "\n")

        print(f"Collected {len(self.logs)} console messages. Written to {log_file}")

    def get_latest_video(self):
        mp4s = glob.glob(os.path.join(self.video_dir, "*.mp4"))
        if not mp4s:
            raise FileNotFoundError(f"No .mp4 files in {self.video_dir}")
        self.input_video = max(mp4s, key=os.path.getmtime)
        return self.input_video

    def generate_output_path(self):
        base, ext = os.path.splitext(os.path.basename(self.input_video))
        self.output_video = os.path.join(self.output_dir, f"{base}{ext}")
        return self.output_video

    def create_drawtext_filters(self):
        filters = []

        # Sanitize the font path for FFmpeg's filter syntax
        font_path_ffmpeg = self.font_path.replace('\\', '/')
        font_path_ffmpeg = font_path_ffmpeg.replace(':', '\\:')

        # A) console messages
        for t, msg in self.logs:
            # More robustly escape single quotes for FFmpeg
            safe = msg.replace("'", "'\\''")
            filters.append(
                f"drawtext=fontfile='{font_path_ffmpeg}':text='{safe}':"
                f"enable='between(t,{t:.2f},{t + 2:.2f})':"
                "x=(w-text_w)/2:y=h-th-40:fontsize=35:fontcolor=white:"
                "box=1:boxcolor=black@0.5"
            )

        # B) test-case names
        for i, (start, end, nm) in enumerate(self.testcases, start=1):
            # Also apply the same escaping here for safety
            # safe = nm.replace("'", "'\\''")
            new_text = f"Test Case {i} : {nm}"
            safe = new_text.replace("'", "\\").replace(":", "\\:")
            filters.append(
                f"drawtext=fontfile='{font_path_ffmpeg}':text='{safe}':"
                f"enable='between(t,{start:.2f},{end:.2f})':"
                "x=(w-text_w)/2:y=10:fontsize=30:fontcolor=white:"
                "box=1:boxcolor=black@0.7"
            )

        # C) running clock - Escape curly braces for f-string
        filters.append(
            f"drawtext=fontfile='{font_path_ffmpeg}':"
            "text='%{{pts\\:hms}}':x=10:y=10:fontsize=20:fontcolor=white:"
            "box=1:boxcolor=black@0.5"
        )

        return ",".join(filters)

    def run_ffmpeg(self):
        self.generate_output_path()
        fg = self.create_drawtext_filters()
        cmd = [
            "ffmpeg", "-y", "-i", self.input_video,
            "-vf", fg, "-c:a", "copy", self.output_video
        ]
        print("Running FFmpeg:", " ".join(cmd))
        subprocess.run(cmd, check=True)
        print("Overlay complete:", self.output_video)

    def run(self):
        self.xml_dir = "/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/STB07_DWI259S/Report"
        self.video_dir = "/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Record/STB07_DWI259S"
        # Set the new output directory
        self.output_dir = "/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Record/STB07_DWI259S/OutputRecordings"
        os.makedirs(self.output_dir, exist_ok=True)

        print("XML →", self.get_latest_xml())
        self.parse_xml()
        print("Recording from", self.recording_start, "to", self.recording_stop)

        print("Parsing test cases…")
        self.parse_testcases()
        print(f"Found {len(self.testcases)} test cases")

        print("Collecting console logs…")
        self.collect_logs()
        print(f"Collected {len(self.logs)} console messages")
        self.collected_logs()
        print("Video →", self.get_latest_video())
        self.run_ffmpeg()


if __name__ == "__main__":
    

    # XML_DIR = r"/home/User"
    # OUT_VID_DIR = r"/home/User/Record"

    overlay = VideoLogOverlay()
    overlay.run()
 