pkg load image

originalImageName = 'LP2.jpg';
filteredImageName = 'LP2_filtered.jpg';


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

% Gaussian filter
filteredImage = imgaussfilt(enhancedImage, 1);  % sigma = 1


filteredBaseFolder = fullfile(scriptFolder, 'LP_Samples', 'filteredImages');
filteredImagePath = fullfile(filteredBaseFolder, filteredImageName);
imwrite(filteredImage, filteredImagePath);


