%this version doesn't have random image at end of run; incorrect indexing
function makeorder_babyloc_static_short(participant)
%% Generates 8 runs/CSV scripts for functional
%% localizer for the infant scans containing 8 stimuli per block with presentation rates of
%% 2Hz.
%
% INPUT: Should be the baby's number 
% OUTPUTS: Separate script files for each run of PTB experiment.
%
% STIMULI: 5 stimulus conditions (aka cateogries)
% 1) Faces: adults sets
% 2) Hands: limbs 
% 3) Cars: cars
% 4) Scenes: places indoor and outdoors 
% 5) blank is the 5th condition
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
nruns = 8; % number of runs
nreps = 4; % number of blocks per category per run
stimsperblock = 8; % number of stimuli in a block
stimdur = .5; % stimulus presentation time (secs)
npadblocks =1; % number of extra baseline blocks at beginning and end
TR = 2; % fMRI TR (secs)
propodd = .5;

nblocks = nconds*nreps + 2*npadblocks; % number of blocks in a run
ntrials = nblocks*stimsperblock; % number of trials in a run
blockdur = stimsperblock*stimdur; % block duration (sec)
rundur = nblocks*blockdur; % run duration (sec)


% Get user input and concatenate it into the file path
participant_folder = fullfile('/Users', 'vpnl', 'Desktop', 'alternating_bb', 'alternating_PsychoPy', 'data', participant, 'short');


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
    condvec = [shuffle([1:5]) shuffle([1:5]) shuffle([1:5])  shuffle([1:5])]    % generate the order of the stim presentation
    % Check for consecutive repetitions and reshuffle if found
    while any(diff(condvec) == 0)
        condvec = [shuffle([1:5]) shuffle([1:5]) shuffle([1:5]) shuffle([1:5])];
    end
    
    condvec = [padblocks; condvec'; padblocks];
    condmat(:, r) = reshape(repmat(condvec', stimsperblock, 1), ntrials, 1);
 
end
       
% Create matrix for Image
imgmat = cell(ntrials, nruns);

% Define the maximum number of stimuli per category
max_stim_per_category = 144;

for r = 1:nruns
    % Calculate the starting stimulus number for this run
    start_stim = (r - 1) * min(nreps * stimsperblock, max_stim_per_category);
    
    counter = 0;

    for tri = 1:ntrials
        if condmat(tri, r) == 5 % for the blank category
            counter = counter + 1;
            % Ensure that stimnums(counter) does not exceed the maximum
            imgmat{tri, r} = strcat(cats{5}, '-', num2str(mod(start_stim + counter - 1, max_stim_per_category) + 1), '.jpg');
        end
    end

    for cat = 1:ncats - 1
        % Calculate the starting stimulus number for this category in this run
        start_stim = (r - 1) * min(nreps * stimsperblock, max_stim_per_category);
        
        counter = 0;

        for tri = 1:ntrials
            if condmat(tri, r) == cat
                counter = counter + 1;
                % Ensure that stimnums(counter) does not exceed the maximum
                imgmat{tri, r} = strcat(cats{cat}, '-', num2str(mod(start_stim + counter - 1, max_stim_per_category) + 1), '.jpg');
            end
        end
    end
end


%%%%%%%%%%%%%%%%%%%
% WRITE CSV

%%%%%%%%%%%%%%%%%%%

% Path to the directory containing image files
image_directory = fullfile('/Users', 'vpnl', 'Desktop', 'alternating_bb', 'alternating_stimuli',  'static_stimuli')

% Write CSV file for each run of the experiment in the participant folder
for r = 1:nruns
    %Make it so first two runs in participant's folder are static
    if r <= 2
        csvfilename = fullfile(participant_folder, strcat('script_babyloc_static_2Hz_run', num2str(r), '.csv'));
        fid = fopen(csvfilename, 'w');
        fprintf(fid, 'Block #,Onset-time(s),Category,TaskMatch,Image Name,Image Path\n');
    %Make it so fifth and sixth runs in participant's folder are static
    elseif 3 <= r && r <= 4
        csvfilename = fullfile(participant_folder, strcat('script_babyloc_static_2Hz_run', num2str(r+2), '.csv'));
        fid = fopen(csvfilename, 'w');
        fprintf(fid, 'Block #,Onset-time(s),Category,TaskMatch,Image Name,Image Path\n');
    %Make it so ninth and tenth runs in participant's folder are static
    elseif 5 <= r && r <= 6
        csvfilename = fullfile(participant_folder, strcat('script_babyloc_static_2Hz_run', num2str(r+4), '.csv'));
        fid = fopen(csvfilename, 'w');
        fprintf(fid, 'Block #,Onset-time(s),Category,TaskMatch,Image Name,Image Path\n');
    %Make it so 13 and 14th runs in participant's folder are static
    elseif 6 <= r
        csvfilename = fullfile(participant_folder, strcat('script_babyloc_static_2Hz_run', num2str(r+6), '.csv'));
        fid = fopen(csvfilename, 'w');
        fprintf(fid, 'Block #,Onset-time(s),Category,TaskMatch,Image Name,Image Path\n');
    end
    for i = 1:ntrials
        if condmat(i, r) == 5 % blank category
            img_name = imgmat{i, r};
            img_path = fullfile(image_directory, img_name);
        else
            img_name = imgmat{i, r};
            img_path = fullfile(image_directory, img_name);
        end
        fprintf(fid, '%i,%f,%i,%s,%s,%s\n', ...
            blockmat(i, r),... % write trial block
            timemat(i, r),... % write trial onset time
            condmat(i, r),... % write trial condition
            cats{condmat(i, r)},... % write stimulus category
            img_name, ... % write video file name
            img_path); % write full video path
    end
    fclose(fid); % Close the CSV file after writing
end


