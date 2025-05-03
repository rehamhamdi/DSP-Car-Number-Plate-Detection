clc;
clear;
close all;

% 1. Read the input image
input_image_path = 'car15.jpg';  % Change path if needed
plate_img = imread(input_image_path);
gray_plate = rgb2gray(plate_img);

% 2. Adaptive Thresholding with dynamic sensitivity based on image brightness and contrast

% Calculate mean and standard deviation of the grayscale image
gray_mean = mean(gray_plate(:));
gray_std = std(double(gray_plate(:)));

% Normalize mean and std to [0,1] range
norm_mean = gray_mean / 255;
norm_std = gray_std / 128;  % typical max std for 8-bit images

% Compute adaptive sensitivity based on both mean brightness and contrast
adaptive_sensitivity = 0.65 + (0.25 * (1 - norm_mean)) + (0.1 * (1 - norm_std));

% Clamp sensitivity to a safe range [0.6, 0.9]
adaptive_sensitivity = max(0.6, min(0.9, adaptive_sensitivity));

% Display the calculated values for debugging
fprintf('Gray mean: %.2f | Std: %.2f | Adaptive sensitivity: %.2f\n', gray_mean, gray_std, adaptive_sensitivity);

% Apply adaptive thresholding using the computed sensitivity
T = adaptthresh(gray_plate, adaptive_sensitivity);
binary_plate = imbinarize(gray_plate, T);

% Invert binary image: make characters white on black
binary_plate = ~binary_plate;

% 3. Noise removal
binary_plate = bwareaopen(binary_plate, 50);

% 4. Get all connected component properties
props = regionprops(binary_plate, 'BoundingBox', 'Centroid', 'Area');

% 5. Manual smart filtering using width, height, and aspect ratio
filtered_props = struct('BoundingBox', {}, 'Centroid', {}, 'Area', {});
for i = 1:length(props)
    bbox = props(i).BoundingBox;
    width = bbox(3);
    height = bbox(4);
    area = props(i).Area;
    aspect_ratio = width / height;

    % Smart filtering
    if area > 50 && ...
       width > 5 && width < 100 && ...
       height > 10 && height < 120 && ...
       aspect_ratio > 0.169 && aspect_ratio < 1.5

        filtered_props(end+1) = props(i); %#ok<SAGROW>
    end
end

% 6. Filter characters in the same horizontal line
if ~isempty(filtered_props)
    centroids = cat(1, filtered_props.Centroid);
    mean_y = mean(centroids(:,2));
    tolerance = 25;
    line_idx = abs(centroids(:,2) - mean_y) < tolerance;
    filtered_props = filtered_props(line_idx);
    centroids = centroids(line_idx,:);

    % 7. Sort left to right
    [~, sort_idx] = sort(centroids(:,1));
    filtered_props = filtered_props(sort_idx);
end

% 8. Show final bounding boxes
figure, imshow(plate_img);
title('Final Filtered Bounding Boxes');
hold on;
for i = 1:length(filtered_props)
    bbox = filtered_props(i).BoundingBox;
    rectangle('Position', bbox, 'EdgeColor', 'b', 'LineWidth', 2);
    text(bbox(1), bbox(2)-10, sprintf('#%d', i), 'Color', 'yellow', 'FontSize', 10);
end
hold off;

% 9. Save characters to folder
output_folder = 'final_segmented_characters';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end
[~, image_name, ~] = fileparts(input_image_path);

for i = 1:length(filtered_props)
    bbox = filtered_props(i).BoundingBox;
    expand = 2;
    x1 = max(bbox(1) - expand, 1);
    y1 = max(bbox(2) - expand, 1);
    x2 = min(bbox(1) + bbox(3) + expand, size(binary_plate,2));
    y2 = min(bbox(2) + bbox(4) + expand, size(binary_plate,1));
    width = x2 - x1;
    height = y2 - y1;

    char_img = imcrop(binary_plate, [x1, y1, width, height]);
    char_img = imresize(char_img, [50 30]);

    filename = fullfile(output_folder, sprintf('%s_char_%d.png', image_name, i));
    imwrite(char_img, filename);

    figure, imshow(char_img);
    title(['Character #' num2str(i)]);
end

disp('✅ Characters have been segmented and saved successfully.');
