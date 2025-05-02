% Noise Reduction & Filtering in MATLAB

% Loop through images in reconstructed_output folder
inputFolder = 'reconstructed_output';
gaussianOutputFolder = 'gaussian_output';
medianOutputFolder = 'median_output';

if ~exist(gaussianOutputFolder, 'dir')
    mkdir(gaussianOutputFolder);
end

if ~exist(medianOutputFolder, 'dir')
    mkdir(medianOutputFolder);
end

% Get all PNG or JPG images in input folder
imageFiles = [dir(fullfile(inputFolder, '*.jpg')); dir(fullfile(inputFolder, '*.png'))];

if isempty(imageFiles)
    imageFiles = dir(fullfile(inputFolder, '*.jpg'));
end

% Loop through all images
for k = 1:length(imageFiles)
    imgPath = fullfile(inputFolder, imageFiles(k).name);
    img = imread(imgPath);
    
    % If RGB, convert to grayscale
    if size(img, 3) == 3
        gray_img = rgb2gray(img);
    else
        gray_img = img;
    end

    % Method 1: Apply Gaussian Filter
    gaussian_filter = fspecial('gaussian', [5 5], 1);
    filtered_gaussian = imfilter(gray_img, gaussian_filter, 'replicate');
    
    % Method 2: Apply Median Filter
    filtered_median = medfilt2(gray_img, [3 3]);

    % Show figures
    figure('Name', ['Filtering Result: ', imageFiles(k).name], 'NumberTitle', 'off');
    subplot(1, 3, 1), imshow(gray_img), title('Original Grayscale');
    subplot(1, 3, 2), imshow(filtered_gaussian), title('Gaussian Filter');
    subplot(1, 3, 3), imshow(filtered_median), title('Median Filter');

    % Save filtered images
    [~, baseName, ext] = fileparts(imageFiles(k).name);
    imwrite(filtered_gaussian, fullfile(gaussianOutputFolder, [baseName '_gaussian' ext]));
    imwrite(filtered_median, fullfile(medianOutputFolder, [baseName '_median' ext]));
end

fprintf('Images saved in respective folders.\n');
