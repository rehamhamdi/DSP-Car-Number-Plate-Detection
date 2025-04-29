clear all; close all; clc

% Input image folder
folderPath = 'original';

% Output folders
reconstructedFolder = 'reconstructed_output';
logFolder = 'log_output';

% Create output folders if they don't exist
if ~exist(reconstructedFolder, 'dir')
    mkdir(reconstructedFolder);
end

if ~exist(logFolder, 'dir')
    mkdir(logFolder);
end

% Get the list of all PNG images in the folder
imageFiles = dir(fullfile(folderPath, '*.jpg'));
figureNum = 1;

for k = 1:length(imageFiles)
    % Read full file name
    fileName = fullfile(folderPath, imageFiles(k).name);
    % Read the image
    imdata = imread(fileName);
    % Convert to grayscale if RGB
    if size(imdata, 3) == 3
        imdata = rgb2gray(imdata);
    end
    
    disp(['Processing: ', imageFiles(k).name]);
    
    % Show original and gray
    %figure(figureNum); imshow(imdata); title(['Original - ', imageFiles(k).name]);
    figureNum = figureNum + 1;
    
    %figure(figureNum); imshow(imdata); title(['Gray - ', imageFiles(k).name]);
    figureNum = figureNum + 1;
    
    % Fourier Transform
    F = fft2(imdata);
    S = abs(F);
    %figure(figureNum); imshow(S, []); title(['Fourier Transform - ', imageFiles(k).name]);
    figureNum = figureNum + 1;
    
    % Centered FFT
    Fsh = fftshift(F);
    %figure(figureNum); imshow(abs(Fsh), []); title(['Centered FFT - ', imageFiles(k).name]);
    figureNum = figureNum + 1;
    
    % Log Transform
    S2 = log(1 + abs(Fsh));
    %figure(figureNum); imshow(S2, []); title(['Log Transform - ', imageFiles(k).name]);
    figureNum = figureNum + 1;
    
    % Save log transformed image
    % Normalize and convert to uint8
    S2_norm = uint8(255 * mat2gray(S2));
    logFileName = fullfile(logFolder, ['log_' imageFiles(k).name]);
    imwrite(S2_norm, logFileName);
    
    % Reconstruct the image
    F = ifftshift(Fsh);
    f = ifft2(F);
    %figure(figureNum); imshow(f, []); title(['Reconstructed - ', imageFiles(k).name]);
    figureNum = figureNum + 1;
    
    % Save reconstructed image
    reconstructedImage = uint8(real(f));
    outputFileName = fullfile(reconstructedFolder, ['reconstructed_' imageFiles(k).name]);
    imwrite(reconstructedImage, outputFileName);
    
    pause(1);
end
