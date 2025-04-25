clc;
clear;
close all;

% 1. Read the input image
input_image_path = 'car2_result1.PNG';  % You can change this path to any image you like
plate_img = imread(input_image_path);
gray_plate = rgb2gray(plate_img);

% 2. Adaptive Thresholding
T = adaptthresh(gray_plate, 0.79);
binary_plate = imbinarize(gray_plate, T);
binary_plate = ~binary_plate;

% 3. Remove small noise
binary_plate = bwareaopen(binary_plate, 50);

% 4. Extract object properties
props = regionprops(binary_plate, 'BoundingBox', 'Centroid', 'Area');

% 5. Filter by size: exclude very small or very large objects
areas = [props.Area];
min_area = 80;
max_area = 2000; % To exclude large frames, e.g., the plate frame
valid_idx = find(areas >= min_area & areas <= max_area);
filtered_props = props(valid_idx);

% 6. Extract Y-centroid to find the baseline
centroids = cat(1, filtered_props.Centroid);
mean_y = mean(centroids(:,2));
tolerance = 25; % Allowable deviation for characters in the same line

% 7. Filter characters in the same line
line_idx = abs(centroids(:,2) - mean_y) < tolerance;
filtered_props = filtered_props(line_idx);
centroids = centroids(line_idx,:);

% 8. Sort from left to right
[~, sort_idx] = sort(centroids(:,1));
filtered_props = filtered_props(sort_idx);

% 9. Display bounding boxes with numbering
figure, imshow(plate_img);
title('Final Filtered Bounding Boxes');
hold on;
for i = 1:length(filtered_props)
    bbox = filtered_props(i).BoundingBox;
    rectangle('Position', bbox, 'EdgeColor', 'b', 'LineWidth', 2);
    text(bbox(1), bbox(2)-10, sprintf('#%d', i), 'Color', 'yellow', 'FontSize', 10);
end
hold off;

% 10. Save characters into a folder
output_folder = 'final_segmented_characters';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Get the base name of the input image
[~, image_name, ~] = fileparts(input_image_path); % Extract image name without extension

% 11. Crop and save each character with expanded bounding box
for i = 1:length(filtered_props)
    bbox = filtered_props(i).BoundingBox;
    expand = 5;
    x1 = max(bbox(1) - expand, 1);
    y1 = max(bbox(2) - expand, 1);
    x2 = min(bbox(1) + bbox(3) + expand, size(binary_plate,2));
    y2 = min(bbox(2) + bbox(4) + expand, size(binary_plate,1));
    width = x2 - x1;
    height = y2 - y1;

    char_img = imcrop(binary_plate, [x1, y1, width, height]);
    char_img = imresize(char_img, [50 30]);

    % Create filename based on the input image name
    filename = fullfile(output_folder, sprintf('%s_char_%d.png', image_name, i));
    imwrite(char_img, filename);

    % Confirmation display
    figure, imshow(char_img);
    title(['Character #' num2str(i)]);
end

disp('Characters have been segmented and saved with the image name prefix ✅');
