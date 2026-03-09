function video_gen_v5(participant, run)
% compiles all the stimuli in the participant's csv for the run and writes the stimuli
% to a video object - saves video object in participant's data folder
    % Participant folder and file paths
    participant_folder = fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'psychopy', 'data', participant);

    % Specify the path to your CSV file
    csvFile = fullfile(participant_folder, strcat('run', num2str(run), '.csv'));

    % Read the CSV file into a table
    data = readtable(csvFile);

    % Set up the video writer (adjust the frame rate as needed)
    videoFile = fullfile(participant_folder, strcat('run', num2str(run), '.mp4'));
    frameRate = 30; % Set a constant frame rate for the output video (adjust as needed)
    videoWriter = VideoWriter(videoFile, 'MPEG-4');
    videoWriter.FrameRate = frameRate;
    open(videoWriter);

    %Load countdown-images 
    countdown_path = fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'psychopy', 'countdown_imgs_resize');
    countdown_images = dir(fullfile(countdown_path, '*.jpg')); % Get all PNG images in the folder

    % Loop through countdown images and append them to the video
    for i = 1:length(countdown_images)
        imgPath = fullfile(countdown_path, countdown_images(i).name); % Get the image file path
        img = imread(imgPath);  % Read the image

        % Write the image to the video (add each image for 1 frame duration)
        numFrames = round(1 * frameRate);  % Display each countdown image for 1 second
        for j = 1:numFrames
            writeVideo(videoWriter, img);  % Write the current image to the video
        end
    end

    % Loop through each row of the stimuli
    for i = 1:height(data)
        % Get the current stimulus details
        stimName = data.StimName{i};
        stimPath = data.StimPath{i};
        stimDur = data.StimDur(i);
        stimType = data.StimType{i};

        % Check if the stimulus is an image or a video
        if strcmp(stimType, 'image') % If it's an image
            % Load the image
            if exist(stimPath, 'file') == 2  % Check if the image file exists
                img = imread(stimPath);  % Read the image
            else
                warning('Image not found: %s', stimPath);
                continue;
            end
            
            % Resize the image to match the video frame size (e.g., 1920x1080)
            % Resize to a fixed output size (adjust as necessary)
            %img = imresize(img, [1080, 1920]);  % Resize image to fit the 1920x1080 resolution

            % Write the image to the video (add each image multiple times if it needs to last for more than 1 frame)
            numFrames = round(stimDur * frameRate);  % Number of frames for this stimulus duration
            for j = 1:numFrames
                writeVideo(videoWriter, img);  % Write the current image to the video
            end

        elseif strcmp(stimType, 'video') % If it's a video
            % Load the video file
            if exist(stimPath, 'file') == 2  % Check if the video file exists
                videoReader = VideoReader(stimPath);  % Create a video reader object
                videoFrameRate = videoReader.FrameRate;  % Frame rate of the video
                videoDuration = videoReader.Duration;  % Duration of the video

                % Resize video frames to fit the output resolution (1920x1080)
                numFrames = round(stimDur * frameRate);  % Number of frames to write from the video
                framesToRead = min(round(stimDur * videoFrameRate), videoReader.NumberOfFrames);  % Ensure it doesn't exceed the video length

                for j = 1:framesToRead
                    if hasFrame(videoReader)
                        frame = readFrame(videoReader);  % Read the next frame from the video
                        % Resize the frame to the output resolution (1920x1080)
                        frame = imresize(frame, [1080, 1920]);  % Resize to 1920x1080

                        % Write the resized frame to the video
                        writeVideo(videoWriter, frame);  
                    else
                        break;  % Stop if we run out of frames in the video
                    end
                end
            else
                warning('Video not found: %s', stimPath);
                continue;
            end
        else
            warning('Unknown stimulus type: %s', stimType);
        end
    end

    % Close the video writer
    close(videoWriter);


    disp('Video creation complete!');

    videoObj = VideoReader(videoFile);

    % Get the duration of the video (in seconds)
    duration = videoObj.Duration;
    
    % Get the frame rate (frames per second)
    frameRate = videoObj.FrameRate;
    
    % Calculate the total number of frames
    totalFrames = round(duration * frameRate);
    
    % Display the results
    fprintf('Total number of frames: %d\n', totalFrames);
    fprintf('Total runtime: %.2f seconds\n', duration);
end
