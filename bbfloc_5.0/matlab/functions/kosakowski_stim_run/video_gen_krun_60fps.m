function video_gen_krun_60fps(participant, run)

% Generates a 60 FPS video for a participant's run by combining images and videos
% Converts 30 FPS videos to 60 FPS by duplicating frames

    %% Paths
    participant_folder = fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'psychopy', 'data', participant);
    csvFile = fullfile(participant_folder, sprintf('run%d.csv', run));
    videoFile = fullfile(participant_folder, sprintf('run%d.mp4', run));
    countdown_path = fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'psychopy', 'countdown_imgs_resize');

    %% Read CSV
    data = readtable(csvFile);

    %% Video writer setup
    outputFPS = 60;
    videoWriter = VideoWriter(videoFile, 'MPEG-4');
    videoWriter.FrameRate = outputFPS;
    open(videoWriter);

    %% Load countdown images
    countdown_images = dir(fullfile(countdown_path, '*.jpg'));
    for i = 1:length(countdown_images)
        imgPath = fullfile(countdown_path, countdown_images(i).name);
        img = imread(imgPath);

        numFrames = round(1 * outputFPS);  % 1 second per countdown image
        for j = 1:numFrames
            writeVideo(videoWriter, img);
        end
    end

    %% Loop through stimuli
    for i = 1:height(data)
        stimName = data.StimName{i};
        stimPath = data.StimPath{i};
        stimDur  = data.StimDur(i);
        stimType = data.StimType{i};

        if strcmp(stimType, 'image')
            if exist(stimPath, 'file') ~= 2
                warning('Image not found: %s', stimPath); continue;
            end
            img = imread(stimPath);
            img = imresize(img, [1080, 1920]);

            numFrames = round(stimDur * outputFPS);
            for j = 1:numFrames
                writeVideo(videoWriter, img);
            end

        elseif strcmp(stimType, 'video')
            if exist(stimPath, 'file') ~= 2
                warning('Video not found: %s', stimPath); continue;
            end

            vr = VideoReader(stimPath);
            inputFPS = vr.FrameRate;
            dupFactor = round(outputFPS / inputFPS);
            totalFrames = min(round(stimDur * inputFPS), vr.NumFrames);

            for f = 1:totalFrames
                if hasFrame(vr)
                    frame = readFrame(vr);
                    frame = imresize(frame, [1080, 1920]);

                    % Duplicate frames to convert FPS
                    for k = 1:dupFactor
                        writeVideo(videoWriter, frame);
                    end
                end
            end
        else
            warning('Unknown stimulus type: %s', stimType);
        end
    end

    %% Close video writer
    close(videoWriter);

    %% Display info
    videoObj = VideoReader(videoFile);
    fprintf('Video creation complete!\n');
    fprintf('Total frames: %d\n', round(videoObj.Duration * videoObj.FrameRate));
    fprintf('Duration: %.2f s\n', videoObj.Duration);
end
