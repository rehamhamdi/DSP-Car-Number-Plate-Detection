close all;

% URL to download the license plate detector XML file
url = 'https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_russian_plate_number.xml';
filename = 'licensePlate.xml';

% Check if the XML file already exists
if ~isfile(filename)
    disp('Downloading license plate detector...');
    % Download the XML file if not found
    websave(filename, url);
    disp('Download complete!');
else
    disp('License plate detector already exists.');
end

% Load the image
im = imread('car2.jpg'); % Make sure the image file exists

% Load the license plate detector using the XML file
plateDetector = vision.CascadeObjectDetector('licensePlate.xml');

% Detect license plates in the image
bboxes = step(plateDetector, im);

% Check if any plate is detected
if ~isempty(bboxes)
    % Show the original image with detected plates
    figure, imshow(im);
    hold on;
    for i = 1:size(bboxes, 1)
        % Draw a green rectangle around each detected plate
        rectangle('Position', bboxes(i,:), 'EdgeColor', 'g', 'LineWidth', 2);
    end
    title('Detected License Plate');
    
    % Crop the first detected license plate from the image
    bbox = bboxes(1,:); % Get the first detected bounding box
    
    % Calculate the new bounding box by reducing 5% from each side
    x = bbox(1);
    y = bbox(2);
    w = bbox(3);
    h = bbox(4);
    
    % Reduce 5% from each side
    x = x + 0.05 * w; % Shift left by 5% of width
    y = y + 0.05 * h; % Shift up by 5% of height
    w = w - 0.1 * w;  % Reduce the width by 10% (5% from each side)
    h = h - 0.1 * h;  % Reduce the height by 10% (5% from each side)
    
    % Crop the image using the new bounding box
    plateImage = imcrop(im, [x, y, w, h]);
    
    % Show the cropped license plate in a new figure
    figure, imshow(plateImage);
    title('Cropped and Resized License Plate');
else
    % If no plates are detected, display a message
    disp('No plate detected.');
end
