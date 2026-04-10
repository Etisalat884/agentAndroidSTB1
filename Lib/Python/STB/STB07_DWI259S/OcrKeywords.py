from robot.api.deco import keyword
import easyocr
import os

class OcrKeywords:
    def __init__(self):
        # Initialize EasyOCR once for faster performance
        self.reader = easyocr.Reader(['en'], gpu=False)

    @keyword("Extract Text From Image")
    def extract_text_from_image(self, image_path):
        """
        Extracts text from an image using EasyOCR and returns it as a list of lowercase strings.
        """
        if not os.path.exists(image_path):
            raise FileNotFoundError(f"Image not found: {image_path}")
        
        print(f"Image found: {image_path}")

        # Read text from image
        result = self.reader.readtext(image_path)

        # Extract and convert all detected text to lowercase
        detected_texts = [d[1].lower() for d in result if len(d) >= 2]
        return detected_texts
