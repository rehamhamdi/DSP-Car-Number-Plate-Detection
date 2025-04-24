pkg load image

originalImageName = 'LP2.jpg';
adjustedImageName = 'LP2_adjusted.jpg';


scriptFolder = fileparts(mfilename('fullpath'));
originalBaseFolder = fullfile(scriptFolder, 'LP_Samples', 'originalImages');
originalImagePath = fullfile(originalBaseFolder, originalImageName);

originalImage = imread(originalImagePath);

if size(originalImage, 3) == 3
    grayImage = rgb2gray(originalImage);
else
    grayImage = originalImage;  % already grayscale
end

% Histogram equalization
enhancedImage = histeq(grayImage);

% OR, use contrast stretching
adjustedImage = imadjust(grayImage);


adjustedBaseFolder = fullfile(scriptFolder, 'LP_Samples', 'filteredImages');
adjustedImagePath = fullfile(adjustedBaseFolder, adjustedImageName);
imwrite(adjustedImage, adjustedImagePath);


