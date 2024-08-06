%% TO AFFIX emoji fixations ONTO BLANK VIDEOS 
%% input: path to dynamic video folder, path to emoji folder
%% output: randomly generated emoji overlays onto videos, which are saved as new versions in an output folder

% Replace these paths with your dynamic video stimuli folder and fixation points folder paths
videoFolder = '/Users/vpnl/Desktop/bbfloc/stimuli/dynamic_stimuli';
fixationPointFolder = '/Users/vpnl/Desktop/bbfloc/stimuli/emoji';

% Create a new folder to save modified videos
outputVideoFolder = '/Users/vpnl/Desktop/bbfloc/stimuli/blank_wfixation';
if ~exist(outputVideoFolder, 'dir')
    mkdir(outputVideoFolder);
end

% Load video files from the video folder
videoFiles = dir(fullfile(videoFolder, 'blank.mp4'));

% Load fixation point images and resize them to 128x128
fixationPointFiles = dir(fullfile(fixationPointFolder, '*.png'));
fixationPointImages = cell(numel(fixationPointFiles), 1);
for i = 1:numel(fixationPointFiles)
    fixationPointImage = imread(fullfile(fixationPointFolder, fixationPointFiles(i).name));
    fixationPointImages{i} = imresize(fixationPointImage, [128, 128]);
end


% Define the fixation display interval in frames
fixationDisplayInterval = 15;

% Loop through each video file
for copyIdx = 1:48
    shuffledFixationPointImages = fixationPointImages(randperm(numel(fixationPointImages)));
    videoIdx = 1; % Assuming there's only one video in the TEST folder
    
    videoFilePath = fullfile(videoFolder, videoFiles(videoIdx).name);
    videoReader = VideoReader(videoFilePath);
    
    % Create an output VideoWriter object for each input video
    outputVideoFileName = fullfile(outputVideoFolder, ['blank', '-', num2str(copyIdx)]);
    outputVideo = VideoWriter(outputVideoFileName, 'MPEG-4');
    outputVideo.FrameRate = videoReader.FrameRate;
    open(outputVideo);

    
    % Loop through frames
    frameCount = 0;
    fixationIndex = 1;
    framesPerFixation = fixationDisplayInterval; % Number of frames to display each fixation image
    framesDisplayed = 0; % Counter to track frames displayed for current fixation image
    while hasFrame(videoReader)
    frame = readFrame(videoReader);


        % Check if it's time to switch to the next fixation image
        if framesDisplayed >= framesPerFixation
            fixationIndex = fixationIndex + 1;
            if fixationIndex > numel(fixationPointImages)
                fixationIndex = 1; % Reset fixation index
            end
            framesDisplayed = 0; % Reset frame counter for new fixation image
        end

        % Insert current fixation point
        fixationPointImageColor = shuffledFixationPointImages{fixationIndex};

        % Calculate the position to insert the fixation point in the center
        [frameHeight, frameWidth, ~] = size(frame);
        [fixationHeight, fixationWidth, ~] = size(fixationPointImageColor);

        xPosition = round((frameWidth - fixationWidth) / 2);
        yPosition = round((frameHeight - fixationHeight) / 2);

        % Extract the alpha channel from the fixation point image
        alphaChannel = fixationPointImageColor(:, :, 3); % Assuming alpha channel is the fourth channel

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

         % Increment frame counter for current fixation image
        framesDisplayed = framesDisplayed + 1;


        % Write the modified frame to the output video
        writeVideo(outputVideo, frame);
    end
    
    % Close the VideoWriter
    close(outputVideo);
end
