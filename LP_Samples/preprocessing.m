
% Read the original image
originalImageName = 'LP1.jpg';
adjustedImageName = 'LP1_adjusted.jpg';

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
adjustedImage = imadjust(enhancedImage);

% Store THe Adjusted Images
adjustedBaseFolder = fullfile(scriptFolder, 'adjustedImages');
adjustedImagePath = fullfile(adjustedBaseFolder, adjustedImageName);
imwrite(adjustedImage, adjustedImagePath);


% figure(1);
% imshow(originalImage); title('Original');
% figure(2);
% imshow(enhancedImage); title('Histogram Equalized');
% figure(3);
% imshow(adjustedImage); title('Contrast Adjusted');