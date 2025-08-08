# 🚗 DSP Car Number Plate Detection

## 📌 Overview
**DSP Car Number Plate Detection** is a **MATLAB-based** project for detecting and recognizing car license plates from images.  
It applies **Digital Signal Processing (DSP)** techniques for image preprocessing, feature extraction, and Optical Character Recognition (OCR) to accurately identify license plate numbers.

---

## 🎯 Objectives
- Detect the license plate area from a vehicle image.
- Preprocess the image to improve accuracy (noise removal, filtering, contrast adjustment).
- Segment characters from the plate.
- Recognize the characters using OCR methods.

---

## 🛠 Features
- **Noise Reduction** – Removes unwanted noise from images for cleaner edges.
- **Edge Detection** – Locates plate boundaries using DSP filters.
- **Plate Extraction** – Crops the plate region from the input image.
- **Character Segmentation** – Isolates each letter/number.
- **OCR Recognition** – Identifies characters and reconstructs the plate number.
- **Sample Dataset** – Includes test images (`LP_Samples`) for validation.

---

## ⚙️ Workflow
1. **Load Input Image** – A vehicle image is provided as input.
2. **Preprocessing** – Convert to grayscale, enhance contrast, remove noise.
3. **Edge Detection** – Apply Sobel or Canny filter to detect plate region.
4. **Plate Localization** – Identify rectangular plate region via morphological operations.
5. **Segmentation** – Split plate into individual characters.
6. **OCR** – Compare characters against stored templates.
7. **Output** – Display detected plate number and processed images.

---
