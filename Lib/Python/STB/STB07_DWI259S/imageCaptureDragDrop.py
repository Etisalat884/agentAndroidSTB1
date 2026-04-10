import cv2
import numpy as np
from datetime import datetime
import subprocess
import logging
import os

logging.basicConfig(level=logging.INFO)

def get_current_datetime():
    return datetime.now().strftime("%Y%m%d%H_%M_%S")

def captureImage(port, imgname):
    command = [
        "ffmpeg", "-y", "-f", "v4l2", "-input_format", "yuyv422",
        "-video_size", "1280x720",
        "-i", f"/dev/video{port}", "-vframes", "1", imgname
    ]
    subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def preprocess_for_match(image, prefix, debug_folder):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    cv2.imwrite(os.path.join(debug_folder, f"{prefix}_gray.png"), gray)

    # Optional light blur
    blurred = cv2.GaussianBlur(gray, (3, 3), 0)
    cv2.imwrite(os.path.join(debug_folder, f"{prefix}_blurred.png"), blurred)

    return blurred





def verifyimage(port, small_image_name):
    capture_image_path = '/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Images/Reference/Capture.png'
    small_image_path = f'/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Images/{small_image_name}.png'

    # Debug folder setup
    debug_folder = '/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/Etisalat_Android_STB1/debug'
    os.makedirs(debug_folder, exist_ok=True)
    timestamp = get_current_datetime()

    # Capture new image
    captureImage(port, capture_image_path)

    # Load both images
    capture_image = cv2.imread(capture_image_path)
    small_image = cv2.imread(small_image_path)

    if capture_image is None or small_image is None:
        raise ValueError("Failed to load one or both images.")

    # Save raw inputs for debugging
    cv2.imwrite(os.path.join(debug_folder, f"{timestamp}_capture.png"), capture_image)
    cv2.imwrite(os.path.join(debug_folder, f"{timestamp}_reference.png"), small_image)

    # Preprocess both
    capture_gray = preprocess_for_match(capture_image,"capture" ,debug_folder)
    small_gray = preprocess_for_match(small_image,"reference" ,debug_folder)

    # Match template
    result = cv2.matchTemplate(capture_gray, small_gray, cv2.TM_CCOEFF_NORMED)
    _, max_val, _, max_loc = cv2.minMaxLoc(result)

    threshold = 0.75
    logging.info(f"Match confidence: {max_val:.4f}")

    if max_val >= threshold:
        h, w = small_gray.shape
        top_left = max_loc
        bottom_right = (top_left[0] + w, top_left[1] + h)
        cv2.rectangle(capture_image, top_left, bottom_right, (0, 255, 0), 2)
        # cv2.imshow('Result', capture_image)
        
        # cv2.waitKey(0)
        # cv2.destroyAllWindows()
        cv2.imwrite(os.path.join(debug_folder, f"{timestamp}_matched_result.png"), capture_image)
        return True
    else:
        return False

# def precheck_image(port, TC_403_Record_Completed, threshold=0.90):
#     """
#     Checks if the reference image matches the current live screen before running the test.
#     Returns True if match passes, False otherwise.
#     """
#     result = verifyimage(port, TC_403_Record_Completed)
#     if result:
#         print(f"[PASS] Reference '{TC_403_Record_Completed}' matches live feed.")
#     else:
#         print(f"[FAIL] Reference '{TC_403_Record_Completed}' does NOT match live feed.")
#     return result


# if not precheck_image(0, "TC_403_Record_Completed"):
#     print("Reference mismatch. Please re-capture before running test.")
#     exit()
# else:
#     print("Pre-check passed, safe to run test.")

# def verifyimage(port, small_image_name):
#     capture_image_path = '/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Images/Reference/Capture.png'
#     small_image_path = f'/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Images/{small_image_name}.png'

#     debug_folder = '/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/Etisalat_Android_STB1/debug'
#     os.makedirs(debug_folder, exist_ok=True)
#     timestamp = get_current_datetime()

#     # Capture live frame
#     captureImage(port, capture_image_path)

#     # Load both images
#     capture_image = cv2.imread(capture_image_path)
#     small_image = cv2.imread(small_image_path)

#     if capture_image is None or small_image is None:
#         raise ValueError("Failed to load one or both images.")

#     # Save originals for debugging
#     cv2.imwrite(os.path.join(debug_folder, f"{timestamp}_capture.png"), capture_image)
#     cv2.imwrite(os.path.join(debug_folder, f"{timestamp}_reference.png"), small_image)

#     # Convert to grayscale
#     capture_gray = cv2.cvtColor(capture_image, cv2.COLOR_BGR2GRAY)
#     small_gray = cv2.cvtColor(small_image, cv2.COLOR_BGR2GRAY)

#     # Create mask to ignore background (white pixels become background)
#     _, mask = cv2.threshold(small_gray, 250, 255, cv2.THRESH_BINARY_INV)

#     best_val = 0
#     best_loc = None
#     best_scale = 1.0

#     # Try multiple scales of the reference image
#     for scale in [0.9, 0.95, 1.0, 1.05, 1.1]:
#         resized = cv2.resize(small_gray, None, fx=scale, fy=scale, interpolation=cv2.INTER_LINEAR)
#         resized_mask = cv2.resize(mask, (resized.shape[1], resized.shape[0]), interpolation=cv2.INTER_NEAREST)

#         # Skip if reference is bigger than capture
#         if resized.shape[0] > capture_gray.shape[0] or resized.shape[1] > capture_gray.shape[1]:
#             continue

#         # Template matching with mask
#         result = cv2.matchTemplate(capture_gray, resized, cv2.TM_CCOEFF_NORMED, mask=resized_mask)
#         _, max_val, _, max_loc = cv2.minMaxLoc(result)

#         logging.info(f"Scale {scale}: match {max_val:.4f}")

#         if max_val > best_val:
#             best_val = max_val
#             best_loc = max_loc
#             best_scale = scale

#     # Final best match log
#     logging.info(f"[Ignore BG + Scale] Best match: {best_val:.4f} at scale {best_scale}")

#     threshold = 0.90  # safer threshold to avoid false positives

#     if best_val >= threshold:
#         h = int(small_gray.shape[0] * best_scale)
#         w = int(small_gray.shape[1] * best_scale)
#         top_left = best_loc
#         bottom_right = (top_left[0] + w, top_left[1] + h)
#         cv2.rectangle(capture_image, top_left, bottom_right, (0, 255, 0), 2)
#         cv2.imwrite(os.path.join(debug_folder, f"{timestamp}_matched_result_ignore_bg_scale.png"), capture_image)
#         return True
#     else:
#         return False


def displayimage(port, imgname):
    path = imgname
    captureImage(port, path)
    return path




# verifyimage(0, 'TC501_ADV2')





























# import cv2
# from datetime import datetime
# import subprocess

# def get_current_datetime():
#     res = datetime.now()
#     formatted_datetime = res.strftime("%Y%m%d%H_%M_%S")
#     return formatted_datetime

# def verifyimage(port, small_image_path):
#     # Read the captured image and the small image
#     capture_image_path = '/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Images/Reference/Capture.png'
#     small_image_path = '/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Images/' + small_image_path + '.png'
#     captureImage(port, capture_image_path)
#     capture_image = cv2.imread(capture_image_path)
#     small_image = cv2.imread(small_image_path)

#     # small_image = cv2.resize(small_image, (capture_image.shape[1], capture_image.shape[0]))
#     # Convert both images to grayscale
#     capture_gray = cv2.cvtColor(capture_image, cv2.COLOR_BGR2GRAY)
#     small_gray = cv2.cvtColor(small_image, cv2.COLOR_BGR2GRAY)

#     # Perform template matching
#     result = cv2.matchTemplate(capture_gray, small_gray, cv2.TM_CCOEFF_NORMED)
#     min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)

#     # Define a threshold to consider it a match
#     threshold = 0.85
#     print(max_val)

#     if max_val > threshold:
#         # Draw a rectangle around the matched region
#         h, w = small_gray.shape
#         top_left = max_loc
#         bottom_right = (top_left[0] + w, top_left[1] + h)
#         cv2.rectangle(capture_image, top_left, bottom_right, (0, 255, 0), 2)
#         # cv2.imshow('Result', capture_image)
#         cv2.waitKey(0)
#         cv2.destroyAllWindows()
#         return True
#     else:
#         return False

# def displayimage(port, imgname):
#     path = imgname
#     captureImage(port, path)
#     return path



# def captureImage(port, imgname):
#     command = [
#         "ffmpeg", "-y", "-f", "v4l2", "-input_format", "yuyv422",
#         "-video_size", "1280x720",  # Set resolution to 720p
#         "-i", f"/dev/video{port}", "-vframes", "1", imgname
#     ]
#     subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


# # print(verifyimage(0,"ref_test"))






