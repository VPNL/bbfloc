function makeorder_babyloc_2_long_dyna_runs(participant)
%% Generates 2 runs/CSV scripts for dynamic condition for the infant scans containing 2 stimuli per block with presentation rates of
%% long.
%
% INPUT: Should be the baby's number 
% OUTPUTS: Separate script file for each run of psychopy experiment.
%
% STIMULI: 5 stimulus conditions (aka categories) 
% 6) Faces: adults sets
% 7) Hands: hands only - no limbs 
% 8) Cars: cars, excacvators, dumptrucks, rccars
% 9) Scenes: places indoor and outdoors 
% 0) blank is the 0th condition
% BLANKS: 1 blank block for each cycle through 5 stimulus conditions.
%
%% no task for the infant floc
%% VERSION: 1.0 9/29/2023 by AS & VN & XY & CT
% Department of Psychology, Stanford University

%%%%%%%%%%%%%%%%%%%%%%%%%
% EXPERIMENTAL PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%

% Stimulus categories (categories in same condition must be grouped)
cats = {'faces'   'hands'  'cars'  'scenes'  'blank'};
ncats = length(cats); % number of stimulus conditions
nconds = ncats  % number of conditions to be counterbalanced (including baseline blocks)

% Presentation and design parameters
nruns = 2; % number of runs
nreps = 12; % number of blocks per category per run
stimsperblock = 1; % number of stimuli in a block
stimdur = 4 % stimulus presentation time (secs)
npadblocks =1; % number of extra baseline blocks at beginning and end
TR = 2; % fMRI TR (secs)
propodd = .5;

nblocks = nconds*nreps + 2*npadblocks; % number of blocks in a run
ntrials = nblocks*stimsperblock; % number of trials in a run
blockdur = stimsperblock*stimdur; % block duration (sec)
rundur = nblocks*blockdur; % run duration (sec)

participant_folder = fullfile('/Users', 'vpnl', 'Desktop', 'bbfloc', 'psychopy', 'data', participant, 'grayscale');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE STIMULUS SEQUENCES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create matrix for Block #
blockmat = zeros(ntrials,nruns);
for r = 1:nruns
    blockmat(:,r) = reshape(repmat(1:nblocks,stimsperblock,1),ntrials,1);
end

% Create matrix for Onset-time(s)
timemat = zeros(ntrials,nruns);
for r = 1:nruns
    timemat(:,r) = 0:stimdur:rundur-stimdur;
end

% Create matrix for Condition without consecutive repetitions
condmat = zeros(ntrials,nruns);
padblocks = repmat(5,npadblocks,1); % vector of baseline blocks to pad run with
for r = 1:nruns
    condvec = [randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5)]    % generate the order of the stim presentation
    % Check for consecutive repetitions and reshuffle if found
    while any(diff(condvec) == 0)
        condvec = [randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5) randperm(5)];
    end
    
    condvec = [padblocks; condvec'; padblocks];
    condmat(:, r) = reshape(repmat(condvec', stimsperblock, 1), ntrials, 1);
end

stim_dir = '/Users/vpnl/Desktop/bbfloc/stimuli/dynamic_grayscale_stim';
blank_video_path = '/Users/vpnl/Desktop/bbfloc/stimuli/dynamic_stimuli/blank/blank.mp4'

% Create matrix for Image
vidmat = cell(ntrials,nruns);

% Create cell arrays of actor names for each category
faceact = cell(1, nruns);
handact = cell(1, nruns);
caract = cell(1, nruns);
sceneact = cell(1, nruns);

% Create cell arrays to keep track of used actors for each category
used_face_actors = cell(1, nruns);
used_hand_actors = cell(1, nruns);
used_car_actors = cell(1, nruns);
used_scene_actors = cell(1, nruns);


%% Shuffle order of actors for all categories, then define the video ranges for different actors
for r = 1:nruns
    % Shuffle the order of actors for the faces category
    faceact{r} = shuffle({'AX_faces', 'BP_faces', 'BR_faces', 'BS_faces', 'DO_faces', 'EC_faces', 'HO_faces', 'IK_faces', 'JC_faces', 'JO_faces', 'JY_faces', 'KP_faces', 'KW_faces', 'SS_faces'});
    %Define the video ranges for different faces
    faceVideoRanges = {
    'AX_faces', 3;
    'BP_faces', 4;
    'BR_faces', 3;
    'BS_faces', 4;
    'DO_faces', 3; 
    'EC_faces', 4;
    'HO_faces', 4;
    'IK_faces', 3; 
    'JC_faces', 4;
    'JO_faces', 4;
    'JY_faces', 3; 
    'KP_faces', 3; 
    'KW_faces', 3; 
    'SS_faces', 3; 
};

    % Shuffle the order of actors for the hands category
    handact{r} = shuffle({'AX_hands', 'BP_hands', 'BS_hands', 'DO_hands', 'EC_hands', 'IK_hands', 'JO_hands', 'KP_hands', 'KW_hands', 'polished_hands', 'rando_hands', 'SS_hands'});
    %Define the video ranges for different hands
    handVideoRanges = {
    'AX_hands', 4;
    'BP_hands', 4;
    'BS_hands', 4;
    'DO_hands', 4; 
    'EC_hands', 4;
    'IK_hands', 4; 
    'JO_hands', 4;
    'KP_hands', 4; 
    'KW_hands', 4; 
    'polished_hands', 4;
    'rando_hands', 4; 
    'SS_hands', 4; 
};

     %Shuffle the order of actors for the cars category
    caract{r} = shuffle({'excavator', 'dumptruck1', 'dumptruck2', 'dumptruck3', 'dumptruck4', 'dumptruck5', 'dumptruck6', 'dumptruck7', 'dumptruck8', 'dumptruck9', 'car1', 'car2', 'car3', 'car4', 'car5', 'car6', 'car7', 'car8', 'car9', 'yellowexcavator', 'rccar', 'racecar'});
    %Define the video ranges for different types of cars 
    carVideoRanges = {
    'excavator', 22;
    'dumptruck1', 1;
    'dumptruck2', 1;
    'dumptruck3', 1;
    'dumptruck4', 1;
    'dumptruck5', 1;
    'dumptruck6', 1;
    'dumptruck7', 1;
    'dumptruck8', 1; 
    'dumptruck9', 1;
    'car1', 1; 
    'car2', 1;
    'car3', 1; 
    'car4', 1; 
    'car5', 2; 
    'car6', 1;
    'car7', 1;
    'car8', 1;
    'car9', 1;
    'yellowexcavator', 3;
    'rccar', 2; 
    'racecar', 1;
};

    %Shuffle the order of actors for the scenes category; all have one
    %video so no need to define video ranges
    sceneact{r} = shuffle({'waves', 'waterfallpond', 'trees', 'snow', 'rockystream', 'river', 'leaves', 'lake', 'grass', 'bigwaterfall', 'smallwaterfall', 'clouds', 'volcano'});

    sceneVideoRanges = {
    'waves', 4;
    'waterfallpond', 2;
    'trees', 2; 
    'snow', 3; 
    'rockystream', 8; 
    'river', 7; 
    'leaves', 5; 
    'lake', 2;
    'grass', 2; 
    'bigwaterfall', 3;
    'smallwaterfall', 3;
    'clouds', 3; 
    'volcano', 4; 
};

    % Initialize used actors for each run
    used_face_actors{r} = {};
    used_hand_actors{r} = {};
    used_car_actors{r} = {};
    used_scene_actors{r} = {};

end

%This loop is used to initialize variables and generate video file names for each run.
for r = 1:nruns

    %These counters will be used to keep track of how many video files have been generated for each category (face, hands, cars, scenes) in the current run.
    fcounter = 0;
    hcounter = 0;
    ccounter = 0;
    scounter = 0;

    % % Initialize used actors for each run
    % used_face_actors{r} = {};
    % used_hand_actors{r} = {};
    % used_car_actors{r} = {};
    % used_scene_actors{r} = {};

    for tri = 1:ntrials %Inside this loop, the code checks the value of condmat(tri, r) to determine the category for the current trial (tri) in the current run (r).
        if condmat(tri, r) == 1 % for face category
            fcounter = fcounter + 1;
            % Generate a random number within the length of unused face actors
            unused_actors = setdiff(faceact{r}, used_face_actors{r});
            if isempty(unused_actors)
                % If all actors have been used, shuffle the actors and reset the used list
                unused_actors = faceact{r};
                used_face_actors{r} = {};
            end
            actor_num = randi(length(unused_actors));
            actor_name = unused_actors{actor_num};
            used_face_actors{r} = [used_face_actors{r}, actor_name];
            face_range = faceVideoRanges{strcmp(faceVideoRanges(:, 1), actor_name), 2};
            vidmat{tri, r} = strcat([actor_name, '_', num2str(randi(face_range)), '.mp4']);
        elseif condmat(tri, r) == 2 % for hands category
            hcounter = hcounter + 1;
            % Generate a random number within the length of unused face actors
            unused_actors = setdiff(handact{r}, used_hand_actors{r});
            if isempty(unused_actors)
                % If all actors have been used, shuffle the actors and reset the used list
                unused_actors = handact{r};
                used_face_actors{r} = {};
            end
            actor_num = randi(length(unused_actors));
            actor_name = unused_actors{actor_num};
            used_hand_actors{r} = [used_hand_actors{r}, actor_name];
            hand_range = handVideoRanges{strcmp(handVideoRanges(:, 1), actor_name), 2};
            vidmat{tri, r} = strcat([actor_name, '_',  num2str(randi(hand_range)), '.mp4']);
        elseif condmat(tri, r) == 3 % for cars category
            ccounter = ccounter + 1;
            % Generate a random number within the length of unused car actors
            unused_actors = setdiff(caract{r}, used_car_actors{r});
            if isempty(unused_actors)
                % If all actors have been used, shuffle the actors and reset the used list
                unused_actors = caract{r};
                used_car_actors{r} = {};
            end
            actor_num = randi(length(unused_actors));
            actor_name = unused_actors{actor_num};
            used_car_actors{r} = [used_car_actors{r}, actor_name];
            car_range = carVideoRanges{strcmp(carVideoRanges(:, 1), actor_name), 2};
            vidmat{tri, r} = strcat([actor_name, '_', num2str(randi(car_range)), '.mp4']);
        elseif condmat(tri, r) == 4 % for scenes category
            scounter = scounter + 1;
            % Generate a random number within the length of unused car actors
            unused_actors = setdiff(sceneact{r}, used_scene_actors{r});
            if isempty(unused_actors)
                % If all actors have been used, shuffle the actors and reset the used list
                unused_actors = sceneact{r};
                used_scene_actors{r} = {};
            end
            actor_num = randi(length(unused_actors));
            actor_name = unused_actors{actor_num};
            used_scene_actors{r} = [used_scene_actors{r}, actor_name];
            scene_range = sceneVideoRanges{strcmp(sceneVideoRanges(:, 1), actor_name), 2};
            vidmat{tri, r} = strcat([actor_name, '_', num2str(randi(scene_range)), '.mp4']);
        elseif condmat(tri, r) == 5 % for the blank category
            vidmat{tri, r} = 'blank.mp4';

        end
    end
end


% Path to the directory containing video files
video_directory = fullfile('/Users', 'vpnl', 'Desktop', 'bbfloc',  'stimuli', 'dynamic_grayscale_stim');

% Map the original category index to a new index
category_mapping = [9, 10, 11, 12, 0];

% Write CSV file for each run of the experiment in the participant folder
for r = 1:nruns
    %Makes it so 6th run in participant's combined folder is dyna long
    if r == 1
        csvfilename = fullfile(participant_folder, strcat('script_babyloc_dyna_long_run', num2str(9), '.csv'));
        fid = fopen(csvfilename, 'w');
        fprintf(fid, 'Block #,Onset-time(s),Category,TaskMatch,Video Name,Video Path\n');
    else
        %Makes it so 8th run in participant's combined folder is dyna long
        csvfilename = fullfile(participant_folder, strcat('script_babyloc_dyna_long_run', num2str(10), '.csv'));
        fid = fopen(csvfilename, 'w');
        fprintf(fid, 'Block #,Onset-time(s),Category,TaskMatch,Video Name,Video Path\n');
    end 

    for i = 1:ntrials
        original_category_index = condmat(i, r);
        mapped_category_index = category_mapping(original_category_index); % Map the category index
        
        vid_name = vidmat{i, r};
        vid_path = fullfile(video_directory, vid_name);
        
        fprintf(fid, '%i,%f,%i,%s,%s,%s\n', ...
            blockmat(i, r),... % write trial block
            timemat(i, r),... % write trial onset time
            mapped_category_index, ... % mapped category index
            cats{condmat(i, r)},... % write stimulus category
            vid_name, ... % write video file name
            vid_path); % write full video path
    end
end