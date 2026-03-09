% Set paths for background and overlay images
background_path = '/Users/ctyagi/Desktop/bbfloc_4.0/stimuli/background_resized.jpg';  % Path to background image
overlay_folder = '/Users/ctyagi/Desktop/bbfloc_4.0/psychopy/countdown_imgs';  % Folder where overlay images are stored
output_folder = '/Users/ctyagi/Desktop/bbfloc_4.0/psychopy/countdown_imgs_resize/';  % Folder to save output images

% Check if the background image exists
if ~exist(background_path, 'file')
    error('Background image not found at the specified path: %s', background_path);
end

% Read the background image
background = imread(background_path);

% Ensure background is in RGB format (convert grayscale to RGB if needed)
if size(background, 3) == 1  % If background is grayscale
    background = repmat(background, [1, 1, 3]);  % Convert to RGB
end

% Get the dimensions of the background image
[background_height, background_width, ~] = size(background);

% Check if the output directory exists, if not, create it
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Get a list of all the image files in the overlay folder (e.g., .jpg, .png)
overlay_files = dir(fullfile(overlay_folder, '*.jpg'));  % Modify the extension as needed

% Loop through each overlay image in the folder
for i = 1:length(overlay_files)
    % Construct full path to the overlay image
    overlay_path = fullfile(overlay_folder, overlay_files(i).name);

    % Read the overlay image
    overlay = imread(overlay_path);

    % Ensure overlay is in RGB format (convert grayscale to RGB if needed)
    if size(overlay, 3) == 1  % If overlay is grayscale
        overlay = repmat(overlay, [1, 1, 3]);  % Convert to RGB
    end

    % Get the dimensions of the overlay image
    [overlay_height, overlay_width, ~] = size(overlay);

    % Calculate the offsets to center the overlay on the background
    x_offset = floor((background_width - overlay_width) / 2);
    y_offset = floor((background_height - overlay_height) / 2);

    % Check if the overlay fits within the background dimensions
    if y_offset + overlay_height - 1 > size(background, 1) || ...
       x_offset + overlay_width - 1 > size(background, 2)
        warning('Overlay does not fit within the background image dimensions for file: %s', overlay_files(i).name);
        continue;  % Skip this overlay image if it does not fit
    end

    % Overlay the image on the background (assign the RGB channels)
    background_with_overlay = background;  % Make a copy to keep the original background intact
    background_with_overlay(y_offset + (1:overlay_height), x_offset + (1:overlay_width), :) = overlay;

    % Ensure the background is in the correct type (uint8)
    if ~isa(background_with_overlay, 'uint8')
        background_with_overlay = uint8(background_with_overlay);  % Convert to uint8 if needed
    end

    % Construct the output file path
    output_filename = fullfile(output_folder, ['output_' overlay_files(i).name]);
    
    % Try to save the image
    try
        imwrite(background_with_overlay, output_filename);
        disp(['Image saved successfully: ', output_filename]);
    catch ME
        disp('Error occurred while saving the image:');
        disp(ME.message);
    end
end
