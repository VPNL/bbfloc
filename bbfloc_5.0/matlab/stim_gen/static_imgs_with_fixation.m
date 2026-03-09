%OVERLAYS RANDOM FIXATION POINT ONTO EACH IMAGE IN THE STIMULUS FOLDER
% Assumes fixation point images are 64x64 pix, if this isnt the case then you should resisze the fixation point images before running
% Also assumes that stimuli images are in grayscale, if they're not, convert them to grayscale using the static_imgs_to_grayscale script

% Load the stimulus images
imageFolderPath = fullfile(pwd, 'gray_images');  % Replace with the folder path containing your static stimulus images
imageFiles = dir(fullfile(imageFolderPath, '*.png'));  % Assumes JPEG images

% load randomized fixation point images (64x64 pixels) in PNG format
% Replace 'fixation_points_folder_path' with the folder path containing your fixation point images in PNG format
fixationPointFolder = fullfile('/Users/ctyagi/Desktop/bbfloc_2.0/stimuli/emoji');
fixationPointFiles = dir(fullfile(fixationPointFolder, '*.png'));  % Assumes PNG fixation point images

% Calculate the center position for the fixation point
centerX = 960;  % Half of 64
centerY = 540;  % Half of 64

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
    outputFolderPath = fullfile(pwd, 'gray_images_w_fixation');  % Replace with the folder path to save the modified images
    mkdir(fullfile(pwd,'gray_images_w_fixation'));
    outputFileName = fullfile(outputFolderPath, ['blank-', num2str(i), '.png']);
    imwrite(individualImageRGB, outputFileName, 'png');  % Save as PNG to preserve transparency
end
