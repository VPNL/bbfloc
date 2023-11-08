%% THIS SCRIPT TAKES STATIC IMAGES WITH NO FIXATION AND OVERLAYS A RANDOM FIXATION POINT ONTO THE IMAGES

% If you get an error running this code; open the image in preview and see if it’s in grayscale 
    %% If not in grayscale, convert to gray scale with the 2gray Matlab script

% Load the individual images
imageFolderPath = 'your/folder/path';  % Replace with the folder path containing your images
imageFiles = dir(fullfile(imageFolderPath, '*.jpg'));  % Assumes JPEG images

% load randomized fixation point images in PNG format
% Replace 'fixation_points_folder_path' with the folder path containing your fixation point images in PNG format
fixationPointFolder = 'your/folder/path';
fixationPointFiles = dir(fullfile(fixationPointFolder, '*.png'));  % Assumes PNG fixation point images

% Resize the fixation point images to 64x64 pixels
fixationPointImageColorResized = imresize(fixationPointImageColor, [64, 64]);

% Calculate the position to insert the resized fixation point in the center
[fixationHeight, fixationWidth, ~] = size(fixationPointImageColorResized);
xPosition = (grayscaleWidth - fixationWidth) / 2;
yPosition = (grayscaleHeight - fixationHeight) / 2;

% Overlay the resized colorized fixation point onto the RGB individual image
yEnd = yPosition + fixationHeight - 1;
xEnd = xPosition + fixationWidth - 1;

% Extract the alpha channel from the resized fixation point image
alphaChannel = fixationPointImageColorResized(:, :, 4);

% Create a mask to determine where to blend
mask = alphaChannel > 0;

% Cast the mask to the same data type as the image
mask = uint8(mask);

% Blend the images using the mask
for channel = 1:3
    individualImageRGB(yPosition:yEnd, xPosition:xEnd, channel) = ...
        individualImageRGB(yPosition:yEnd, xPosition:xEnd, channel) .* (1 - mask) + ...
        fixationPointImageColorResized(:, :, channel) .* mask;
end


% Calculate the center position for the fixation point
centerX = 32;  % Half of 64
centerY = 32;  % Half of 64

% Loop through each individual image
for i = 1:numel(imageFiles)
    % Load the grayscale individual image
    individualImageGray = imread(fullfile(imageFolderPath, imageFiles(i).name));
    
    % Randomly select a colorized fixation point image
    randomFixationIdx = randi(numel(fixationPointFiles));
    fixationPointImageColor = imread(fullfile(fixationPointFolder, fixationPointFiles(randomFixationIdx).name));
    
    % Calculate the position to insert the fixation point in the center
    [fixationHeight, fixationWidth, ~] = size(fixationPointImageColor);
    [grayscaleHeight, grayscaleWidth] = size(individualImageGray);
    
    xPosition = (grayscaleWidth - fixationWidth) / 2;
    yPosition = (grayscaleHeight - fixationHeight) / 2;
    
    % Convert the grayscale individual image to an RGB format
    individualImageRGB = cat(3, individualImageGray, individualImageGray, individualImageGray);

    % Overlay the colorized fixation point onto the RGB individual image
    yEnd = yPosition + fixationHeight - 1;
    xEnd = xPosition + fixationWidth - 1;
    
    % Extract the alpha channel from the fixation point image
    alphaChannel = fixationPointImageColor(:, :, 3);
    
    % Create a mask to determine where to blend
    mask = alphaChannel > 0;
    
    % Cast the mask to the same data type as the image
    mask = uint8(mask);
    
    % Blend the images using the mask
    for channel = 1:3
        individualImageRGB(yPosition:yEnd, xPosition:xEnd, channel) = ...
            individualImageRGB(yPosition:yEnd, xPosition:xEnd, channel) .* (1 - mask) + ...
            fixationPointImageColor(:, :, channel) .* mask;
    end
    
    % Save the modified RGB image with the colorized fixation point as a new image
    outputFolderPath = 'your/folder/path';  % Replace with the folder path to save the modified images
    outputFileName = fullfile(outputFolderPath, ['modified_image_', num2str(i), '.jpg']);
    imwrite(individualImageRGB, outputFileName, 'jpg'); 
end
