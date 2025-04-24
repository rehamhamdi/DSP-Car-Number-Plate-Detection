close all;

% Read the image
im = imread('car1.jpg');

% Convert image to grayscale
imgray = rgb2gray(im);

% Detect edges using Prewitt operator
edges = edge(imgray, 'prewitt');

% Find regions (connected components) and their bounding boxes
regions = regionprops(edges, 'BoundingBox', 'Area');

% Initialize variables to store the best matching region
maxTextLength = 0;
selectedBox = [];

% Loop through all detected regions
for i = 1:numel(regions)
    bbox = regions(i).BoundingBox;  % Get bounding box
    croppedRegion = imcrop(imgray, bbox);  % Crop region from grayscale image
    ocrResult = ocr(croppedRegion);  % Apply OCR on the cropped region
    detectedText = strtrim(ocrResult.Text);  % Clean OCR result (remove spaces)

    % Keep the region with the longest detected text
    if ~isempty(detectedText) && length(detectedText) > maxTextLength
        maxTextLength = length(detectedText);
        selectedBox = bbox;
    end
end

% If a plate was detected
if ~isempty(selectedBox)
    % Show original image and draw green rectangle around detected plate
    figure, imshow(im);
    hold on;
    rectangle('Position', selectedBox, 'EdgeColor', 'g', 'LineWidth', 2);
    title('Detected Car Plate');

    % Crop the plate from grayscale image and show it in a new figure
    plateRegion = imcrop(imgray, selectedBox);
    figure, imshow(plateRegion);
    title('Cropped Plate Region');
else
    % If no plate detected, display a message
    disp('Can not Find any car plate');
end
