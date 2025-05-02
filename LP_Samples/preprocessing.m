
% Read the original image
originalImageName = 'LP1.jpeg';
adjustedImageName = 'LP1_adjusted.jpeg';

scriptFolder = fileparts(mfilename('fullpath'));
originalBaseFolder = fullfile(scriptFolder, 'originalImages');
originalImagePath = fullfile(originalBaseFolder, originalImageName);

originalImage = imread(originalImagePath);

% Convert to grayscale
if size(originalImage, 3) == 3
    grayImage = rgb2gray(originalImage);
else
    grayImage = originalImage;  % already grayscale
end

% Histogram equalization
enhancedImage = histeq(grayImage);

% Contrast stretching
adjustedImage = imadjust(grayImage);

% Store THe Adjusted Images
adjustedBaseFolder = fullfile(scriptFolder, 'adjustedImages');
adjustedImagePath = fullfile(adjustedBaseFolder, adjustedImageName);
imwrite(adjustedImage, adjustedImagePath);

