% Apply Median Filtering on Gaussian Filtered Images

% Input is the output of Gaussian filtering
inputFolder = 'gaussian_output'; 
outputFolder = 'gaussian_then_median_output';

if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Get all PNG or JPG images from the Gaussian folder
imageFiles = [dir(fullfile(inputFolder, '*.jpg')); dir(fullfile(inputFolder, '*.png'))];

if isempty(imageFiles)
    imageFiles = dir(fullfile(inputFolder, '*.jpg'));
end

for k = 1:length(imageFiles)
    imgPath = fullfile(inputFolder, imageFiles(k).name);
    img = imread(imgPath);
    
    % Ensure grayscale
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    % Apply Median filter to the Gaussian-filtered image
    filtered_median = medfilt2(img, [3 3]);

    % Save result
    [~, baseName, ext] = fileparts(imageFiles(k).name);
    imwrite(filtered_median, fullfile(outputFolder, [baseName '_median' ext]));

    % Display the result 
    figure('Name', ['Gaussian -> Median: ', imageFiles(k).name], 'NumberTitle', 'off');
    subplot(1, 2, 1), imshow(img), title('Gaussian Filtered Image');
    subplot(1, 2, 2), imshow(filtered_median), title('After Median Filter');
end

fprintf('Images processed and saved in "%s".\n', outputFolder);
