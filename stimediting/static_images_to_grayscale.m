% this matlab script converts the static images to gray scale if they are not already in grayscale 

% Specify the folder containing your images
folderPath = 'your/folder/here';

% List all image files in the folder
fileList = dir(fullfile(folderPath, '*.jpg')); % Update the file extension as needed

% Loop through each image file
for i = 1:numel(fileList)
    % Read the image
    imagePath = fullfile(folderPath, fileList(i).name);
    rgbImage = imread(imagePath);
    
    % Convert to grayscale
    grayImage = rgb2gray(rgbImage);
    
    % Save the grayscale image back to the folder with the same name
    [~, fileName, fileExt] = fileparts(fileList(i).name);
    outputFileName = fullfile(folderPath, [fileName '_gray' fileExt]);
    imwrite(grayImage, outputFileName);
    
    % Delete the old image
    delete(imagePath);
end

% Display a message when done
disp('Conversion to grayscale completed.');
