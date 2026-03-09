function generate_gray_images()
    % Directory to save the images
    output_dir = fullfile(pwd, 'gray_images');  % You can change this to any desired directory
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);  % Create directory if it doesn't exist
    end

    % Image size
    img_size = [1080, 1920];  % 1080x1080 pixels
    num_images = 512;  % Total number of images to generate

    % Loop to create and save images
    for i = 1:num_images
        % Generate a random brightness level between 100 and 200
        brightness_level = randi([100, 200]);
        
        % Create an image with the specified gray level (all pixels have the same value)
        gray_image = uint8(brightness_level * ones(img_size));  % Create a gray image with uniform brightness
        
        % Save the image with a unique filename
        filename = fullfile(output_dir, sprintf('gray_image_%03d.png', i));
        imwrite(gray_image, filename);

        % Display progress
        if mod(i, 10) == 0  % Display progress after every 10 images
            fprintf('Generated image %d of %d\n', i, num_images);
        end
    end
    
    % Display completion message
    fprintf('All %d images have been generated and saved to %s.\n', num_images, output_dir);
end
