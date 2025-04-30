% Read the image
im = imread('car5.jpg');

% Convert image to grayscale
imgray = rgb2gray(im);

% Detect edges using Prewitt operator 
edges = edge(imgray , 'prewitt');

% Find regions (connected components) and their bounding boxes
regions = regionprops(edges, 'BoundingBox', 'Area');

% Initialize detected plate text to empty string
detectedPlateText = '';

% Initialize maxTextLength to zero
maxTextLength = 0;

for i = 1:numel(regions)
    bbox = regions(i).BoundingBox;
    
    % --- New Filtering Step ---
    width = bbox(3);
    height = bbox(4);
    aspect_ratio = width / height;
    
    % Keep regions with reasonable size and shape
    if width > 80 && height > 20 && aspect_ratio > 2 && aspect_ratio < 6
        croppedRegion = imcrop(imgray , bbox);
        ocrResult = ocr(croppedRegion);
       
        detectedText = strtrim(ocrResult.Text);
        detectedText = regexprep(detectedText, '[^A-Za-z0-9 ]', '');

        if ~isempty(detectedText) && length(detectedText) > maxTextLength
            maxTextLength = length(detectedText);
            detectedPlateText = detectedText;
        end
    end
end

% Print the detected plate text
if ~isempty(detectedPlateText)
    disp(['Detected Plate Text: ', detectedPlateText]);
else
    disp('No valid plate text detected.');
end
