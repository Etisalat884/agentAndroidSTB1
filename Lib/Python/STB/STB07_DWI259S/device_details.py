# import cv2
# import os
# import time
# import re
# from datetime import datetime
# import easyocr
# import subprocess
# from Signal.Etisalat import etisalat_tv_cmds



# def press(button, count=1, delay=1):
#     for _ in range(count):
#         etisalat_tv_cmds(button)
#         time.sleep(delay)

# # -----------------------------------
# # Navigate STB device details
# # -----------------------------------
# def navigate_to_diag():
#     print("Navigating STB menu...")

#     press("UP", 1)
#     press("RIGHT", 9)
#     press("OK", 1)
#     press("RIGHT", 2)
#     press("DOWN", 1)
#     press("OK", 1)

#     print("Navigation Completed Successfully ✅")


# # -----------------------------------
# # Screenshot capture function
# # -----------------------------------
# def capture_screenshot(output_file):
#     cmd = [
#         "ffmpeg",
#         "-f", "v4l2",
#         "-input_format", "yuyv422",
#         "-video_size", "1280x720",
#         "-i", "/dev/video0",
#         "-frames:v", "1",
#         "-y",
#         output_file
#     ]

#     try:
#         subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
#         print("Screenshot captured:", output_file)
#     except subprocess.CalledProcessError as e:
#         print("Screenshot capture failed:", e)



# # -----------------------------------
# # Crop Firmware Region
# # -----------------------------------
# def crop_firmware_region(image_path):

#     img = cv2.imread(image_path)
#     if img is None:
#         raise ValueError(f"Image not loaded: {image_path}")

#     h, w = img.shape[:2]

#     # Adjust these if needed
#     y_start = int(h * 0.36)
#     y_end   = int(h * 0.41)

#     x_start = int(w * 0.47)
#     x_end   = int(w * 0.75)

#     cropped = img[y_start:y_end, x_start:x_end]

#     base, ext = os.path.splitext(image_path)
#     cropped_path = f"{base}_firmware_crop{ext}"

#     cv2.imwrite(cropped_path, cropped)

#     print(f"Image shape: {img.shape}")
#     print(f"Cropping from y={y_start} to y={y_end}, x={x_start} to x={x_end}")
#     print("Cropped image saved at:", cropped_path)

#     return cropped_path


# # -----------------------------------
# # Initialize OCR (load once)
# # -----------------------------------
# print("Initializing OCR...")
# reader = easyocr.Reader(['en'])


# # -----------------------------------
# # Extract Text using OCR
# # -----------------------------------
# def extract_text(image_path):

#     print("Running OCR...")
#     results = reader.readtext(image_path)

#     extracted_text = " ".join([text for _, text, _ in results])
#     print("Raw OCR Text:", extracted_text)

#     return extracted_text




# # -----------------------------------
# # MAIN EXECUTION FLOW
# # -----------------------------------
# def get_device_firmware_version():

#     # Step 1: Navigate
#     navigate_to_diag()

#     print("Waiting 5 seconds...")
#     time.sleep(5)

#     # ✅ Your required save path
#     base_dir = "/home/ltts/Documents/evqual_automation/agentKaonLinuxSTB1/workspace/Lib/Python/STB/STB03_KSTB6078"

#     os.makedirs(base_dir, exist_ok=True)

#     timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
#     screenshot_path = os.path.join(base_dir, f"device_info_{timestamp}.png")

#     # Step 2: Capture Screenshot
#     capture_screenshot(screenshot_path)

#     # Step 3: Crop Firmware Area
#     cropped_path = crop_firmware_region(screenshot_path)

#     # Step 4: OCR
#     raw_text = extract_text(cropped_path)


#     return raw_text


# # -----------------------------------
# # Run Script
# # -----------------------------------
# if __name__ == "__main__":

#     firmware = get_device_firmware_version()

#     print("\n==============================")
#     print("FINAL Firmware Version:", firmware)
#     print("==============================")


import cv2
import os
import time
import re
from datetime import datetime
import easyocr
import subprocess
from Signal.Etisalat import etisalat_tv_cmds
import json


# -----------------------------------
# Remote Button Press
# -----------------------------------
def press(button, count=1, delay=1):
    for _ in range(count):
        etisalat_tv_cmds(button)
        time.sleep(delay)


# -----------------------------------
# Navigate STB device details
# -----------------------------------
def navigate_to_diag():
    # print("Navigating STB menu...")

    press("UP", 1)
    press("RIGHT", 9)
    press("OK", 1)
    press("RIGHT", 2)
    press("DOWN", 1)
    press("OK", 1)

    # print("Navigation Completed Successfully ✅")


# -----------------------------------
# Screenshot capture function
# -----------------------------------
def capture_screenshot(output_file):
    cmd = [
        "ffmpeg",
        "-f", "v4l2",
        "-input_format", "yuyv422",
        "-video_size", "1280x720",
        "-i", "/dev/video0",
        "-frames:v", "1",
        "-y",
        output_file
    ]

    try:
        subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print("Screenshot captured:", output_file)
    except subprocess.CalledProcessError as e:
        print("Screenshot capture failed:", e)


# -----------------------------------
# Generic Crop Function
# -----------------------------------
def crop_region(image_path, y1_ratio, y2_ratio, x1_ratio=0.49, x2_ratio=0.75, tag="crop"):

    img = cv2.imread(image_path)
    if img is None:
        raise ValueError(f"Image not loaded: {image_path}")

    h, w = img.shape[:2]

    y_start = int(h * y1_ratio)
    y_end   = int(h * y2_ratio)

    x_start = int(w * x1_ratio)
    x_end   = int(w * x2_ratio)

    cropped = img[y_start:y_end, x_start:x_end]

    base, ext = os.path.splitext(image_path)
    cropped_path = f"{base}_{tag}{ext}"

    cv2.imwrite(cropped_path, cropped)

    #print(f"{tag} Cropping: y={y_start}-{y_end}, x={x_start}-{x_end}")
    #print(f"{tag} saved at:", cropped_path)

    return cropped_path


# -----------------------------------
# Initialize OCR (Load Once)
# -----------------------------------
# print("Initializing OCR...")
reader = easyocr.Reader(['en'], verbose=False)


# -----------------------------------
# OCR Function
# -----------------------------------
def extract_text(image_path):
    results = reader.readtext(image_path)
    extracted_text = " ".join([text for _, text, _ in results])
    return extracted_text.strip()


# -----------------------------------
# MAIN EXECUTION FLOW
# -----------------------------------
def get_device_information():

    # Step 1: Navigate
    navigate_to_diag()

    # print("Waiting 5 seconds...")
    time.sleep(5)

    # Save Path
    base_dir = "/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/STB07_DWI259S"
    os.makedirs(base_dir, exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    screenshot_path = os.path.join(base_dir, f"device_info_{timestamp}.png")

    # Step 2: Capture Screenshot
    capture_screenshot(screenshot_path)

    # -----------------------------------
    # Crop All Required Fields
    # -----------------------------------

    model_img = crop_region(screenshot_path, 0.60, 0.64, tag="model")
    serial_img   = crop_region(screenshot_path, 0.32, 0.37, tag="serial")
    apkVersion_img    = crop_region(screenshot_path, 0.65, 0.70, tag="apk")
    # sap_img      = crop_region(screenshot_path, 0.32, 0.37, tag="sap")
    app_ver      = crop_region(screenshot_path, 0.21, 0.27, tag="app")

    # -----------------------------------
    # OCR Extraction
    # -----------------------------------

    model_text = extract_text(model_img)
    serial_text   = extract_text(serial_img)
    apkVersion_text    = extract_text(apkVersion_img)
    # sap_text      = extract_text(sap_img)
    app_text      = extract_text(app_ver)

    # # Optional Cleaning
    # model_clean = re.sub(r'[^0-9.]', '', model_text)
    # serial_clean   = re.sub(r'[^0-9A-Za-z]', '', serial_text)
    # apkVersion_clean    = apkVersion_text.strip()
    # # sap_clean      = sap_text.strip()

    # -----------------------------------
    # Print All Details
    # -----------------------------------

    # print("\n==============================")
    # print("📦 DEVICE INFORMATION")
    # print("==============================")
    # print("Firmware Version :", firmware_clean)
    # print("Serial Number    :", serial_clean)
    # print("STB Model        :", model_clean)
    # print("SAP Version      :", sap_clean)
    # print("==============================\n")
    press("OK", 1)
    press("HOME",1)
    return {
        "STB Model": model_text,
        "Serial Number": serial_text,
        "APK Version": apkVersion_text,
        # "SAP Version": sap_clean,
        "Application Version": app_text
    }


if __name__ == "__main__":
    device_info = get_device_information()

    # VERY IMPORTANT: Print ONLY JSON
    # print(json.dumps(device_info))