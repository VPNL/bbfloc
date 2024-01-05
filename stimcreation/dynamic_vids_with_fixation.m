%% TO AFFIX emoji fixations ONTO VIDEOS 
%% input: path to dynamic video folder, path to emoji folder
%% output: randomly generated emoji overlays onto videos, which are saved as new versions in an output folder

% Replace these paths with your dynamic video stimuli folder and fixation points folder paths
videoFolder = '/path/to/your/video';
fixationPointFolder = '/path/to/your/fixation_points_folder';

% Create a new folder to save modified videos
outputVideoFolder = '/path/to/save/modified_videos';
if ~exist(outputVideoFolder, 'dir')
    mkdir(outputVideoFolder);
end

% Load video files from the video folder
videoFiles = dir(fullfile(videoFolder, '*.mp4'));

% Load fixation point images and resize them to 128x128
fixationPointFiles = dir(fullfile(fixationPointFolder, '*.png'));
fixationPointImages = cell(numel(fixationPointFiles), 1);
for i = 1:numel(fixationPointFiles)
    fixationPointImage = imread(fullfile(fixationPointFolder, fixationPointFiles(i).name));
    fixationPointImages{i} = imresize(fixationPointImage, [128, 128]);
end

% Loop through each video file
for videoIdx = 1:numel(videoFiles)
    videoFilePath = fullfile(videoFolder, videoFiles(videoIdx).name);
    videoReader = VideoReader(videoFilePath);
    
    % Randomly select a fixation point image for this video
    randomFixationIdx = randi(numel(fixationPointImages));
    fixationPointImageColor = fixationPointImages{randomFixationIdx};

    % Check if the fixation point image has an alpha channel
    hasAlphaChannel = size(fixationPointImageColor, 3) == 4;

    % Create an output VideoWriter object for each input video
    outputVideoFileName = fullfile(outputVideoFolder, ['modified_', videoFiles(videoIdx).name]);
    outputVideo = VideoWriter(outputVideoFileName, 'MPEG-4');
    outputVideo.FrameRate = videoReader.FrameRate;
    open(outputVideo);

    % Loop through each video frame
    while hasFrame(videoReader)
        frame = readFrame(videoReader);
        
        % Calculate the position to insert the fixation point in the center
        [frameHeight, frameWidth, ~] = size(frame);
        [fixationHeight, fixationWidth, ~] = size(fixationPointImageColor);
        
        xPosition = round((frameWidth - fixationWidth) / 2);
        yPosition = round((frameHeight - fixationHeight) / 2);

        % Extract the alpha channel from the fixation point image
        alphaChannel = fixationPointImageColor(:, :, 3);
        
        % Create a mask to determine where to blend
        mask = alphaChannel > 0;
        
        % Cast the mask to the same data type as the image
        mask = uint8(mask);

        % Overlay the fixation point onto the frame considering transparency
        for channel = 1:3
            framePart = frame(yPosition:yPosition+fixationHeight-1, xPosition:xPosition+fixationWidth-1, channel);
            fixationPart = fixationPointImageColor(:,:,channel);

            % Apply the mask for transparency
            framePart = framePart .* (1 - mask) + fixationPart .* mask;

            % Assign the modified part back to the frame
            frame(yPosition:yPosition+fixationHeight-1, xPosition:xPosition+fixationWidth-1, channel) = framePart;
        end
        
        % Write the modified frame to the output video
        writeVideo(outputVideo, frame);
    end
    
    % Close the VideoWriter
    close(outputVideo);
end
