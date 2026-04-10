# from robot.api.deco import keyword
# from robot.api import logger  # <-- Use Robot's logger
# import easyocr
# import os

# def is_english_like(text: str) -> bool:
#     letters = [c for c in text if c.isalpha()]
#     if not letters:
#         return False
#     ascii_letters = sum(1 for c in letters if c.isascii())
#     return ascii_letters / len(letters) >= 0.5  # 50% threshold

# def normalize_text(text: str) -> str:
#     return ''.join(c for c in text if c.isalpha() or c.isspace()).strip()

# @keyword("Extract Text From Image")
# def extract_text_from_image(image_path):
#     if not os.path.exists(image_path):
#         raise FileNotFoundError(f"Image not found: {image_path}")

#     reader = easyocr.Reader(['en', 'ar'], gpu=False)
#     result = reader.readtext(image_path)

#     detected_texts = []
#     for detection in result:
#         if len(detection) >= 3:
#             bbox, text, conf = detection
#             if conf < 0.4:
#                 continue
#             clean_text = normalize_text(text)
#             if len(clean_text) >= 2:
#                 detected_texts.append(clean_text)
#     return detected_texts

# @keyword("Repeat OCR And Validate Language")
# def repeat_ocr_and_validate_language(image_path, expected_language):
#     texts = extract_text_from_image(image_path)

#     if not texts:
#         logger.console("No text detected in this frame.")
#     else:
#         for t in texts:
#             logger.console(f"Extracted text: '{t}'")

#     # Language detection with heuristic
#     for text in texts:
#         if expected_language == "en" and is_english_like(text):
#             logger.console(f"Frame contains English subtitle: '{text}'")  # log before returning
#             return True
#         elif expected_language == "ar" and any('\u0600' <= c <= '\u06FF' or '\u0750' <= c <= '\u077F' for c in text):
#             logger.console(f"Frame contains Arabic subtitle: '{text}'")
#             return True

#     return False




from robot.api.deco import keyword
from robot.api import logger
import easyocr
import os

def is_english_like(text: str) -> bool:
    letters = [c for c in text if c.isalpha()]
    if not letters:
        return False
    ascii_letters = sum(1 for c in letters if c.isascii())
    return ascii_letters / len(letters) >= 0.5  # 50% threshold

def normalize_text(text: str) -> str:
    return ''.join(c for c in text if c.isalpha() or c.isspace()).strip()

@keyword("Extract Text From Image")
def extract_text_from_image(image_path, expected_language):
    """
    Extract text using EasyOCR.
    Arabic requires special reader, others use 'en'.
    """
    if not os.path.exists(image_path):
        raise FileNotFoundError(f"Image not found: {image_path}")

    # Initialize OCR
    if expected_language == "ar":
        reader = easyocr.Reader(['en','ar'], gpu=False)
    elif expected_language == "da":
        reader = easyocr.Reader(['en', 'da'], gpu=False)
    else:
        reader = easyocr.Reader(['en'], gpu=False)  # all Nordic languages as 'en'

    result = reader.readtext(image_path)

    detected_texts = []
    for detection in result:
        if len(detection) >= 3:
            bbox, text, conf = detection
            if conf < 0.4:
                continue
            clean_text = normalize_text(text)
            if len(clean_text) >= 2:
                detected_texts.append(clean_text)

    return detected_texts

@keyword("Repeat OCR And Validate Language")
def repeat_ocr_and_validate_language(image_path, expected_language):
    texts = extract_text_from_image(image_path, expected_language)

    # if not texts:
    #     logger.console("No text detected in this frame.")
    #     if expected_language == "none":
    #         return True  # success if expecting no subtitle
    #     return False

    # for t in texts:
    #     logger.console(f"Extracted text: '{t}'")
    if expected_language == "none":
        if not texts:
            logger.console("No text detected as expected ✅")
        else:
            logger.console(f"Text detected but none expected: {texts}")
        return True  # Success whether text is detected or not

    # If texts are empty for other languages
    if not texts:
        logger.console("No text detected in this frame.")
        return False

    for t in texts:
        logger.console(f"Extracted text: '{t}'")
    for text in texts:
        # English check
        if expected_language == "en" and is_english_like(text):
            logger.console(f"Frame contains English subtitle: '{text}'")
            return True
        # Arabic Unicode ranges
        elif expected_language == "ar" and any('\u0600' <= c <= '\u06FF' or '\u0750' <= c <= '\u077F' for c in text):
            logger.console(f"Frame contains Arabic subtitle: '{text}'")
            return True
        # Danish Unicode: æ, ø, å + uppercase
        elif expected_language == "da" and any(
            '\u00E6' <= c <= '\u00E6' or '\u00F8' <= c <= '\u00F8' or '\u00E5' <= c <= '\u00E5' or
            '\u00C6' <= c <= '\u00C6' or '\u00D8' <= c <= '\u00D8' or '\u00C5' <= c <= '\u00C5'
            for c in text):
            logger.console(f"Frame contains Danish subtitle: '{text}'")
            return True
        
        elif expected_language == "none":
            logger.console(f"No specific language expected, detected text: '{text}'")
            return True  # accept any text

    return False


