clc; close all; clear;
% Step 1: Read input image
inputImage = imread('car3.jpg');

% Step 2: Convert to grayscale
grayImage = rgb2gray(inputImage);

% Step 3: Enhance contrast and reduce noise
enhancedImage = imadjust(grayImage);
filteredImage = medfilt2(enhancedImage);
sharpenedImage = imsharpen(filteredImage);

% Step 4: Adaptive binarization
binaryImage = imbinarize(sharpenedImage, 'adaptive', ...
    'ForegroundPolarity', 'dark', 'Sensitivity', 0.5);

% Step 5: Invert text color
binaryImage = imcomplement(binaryImage);

% Step 6: Remove small objects
cleanedImage = bwareaopen(binaryImage, 60);

% Step 7: Resize image (enlarge)
resizedImage = imresize(cleanedImage, 3);
resizedImage = uint8(resizedImage) * 255;  % Convert logical to uint8 image

% Step 8: Save processed image
imwrite(resizedImage, 'temp_plate.png');

% Step 9: Run external Tesseract (EDIT the path below if needed)
tesseractPath = '"C:\Program Files\Tesseract-OCR\tesseract.exe"';
[status, result] = system([tesseractPath ' temp_plate.png stdout -l eng --oem 1 --psm 7']);

% Step 10: Clean result
recognizedText = strtrim(result);

% Step 11: Display results
figure;
imshow(inputImage);
title(['Detected Plate Text: ', recognizedText], 'FontSize', 14, 'Color', 'blue');

disp('--- Recognized Number Plate Text (Tesseract) ---');
disp(recognizedText);
disp('--- OCR via External Tesseract Completed ---');
