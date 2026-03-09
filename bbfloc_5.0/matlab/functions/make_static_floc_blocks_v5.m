function make_static_floc_blocks_v5(participant, run)
%% Generates blocks for Stigliani's static fLoc; 3 reps per category 
% thirty-two stimuli per block, presented for 0.5 seconds each = 16s blocks

% INPUT: Should be the baby's number 
%
% STIMULI: 5 stimulus categories
% 1) Faces-S: adult set; static
% 2) Hands-S: limbs static
% 3) Cars-S: cars static
% 4) Scenes-S: places static indoor and outdoors 
% 5) Food-S: foods
%
%% no task for the infant flocd
%% VERSION: 1.0 9/29/2023 by AS & VN & XY & CT
% Department of Psychology, Stanford University
%%%%%%%%%%%%%%%%%%%%%%%%%
% EXPERIMENTAL PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%

% Stimulus categories (categories in same condition must be grouped)
cats = {'Faces-S', 'Limbs-S', 'Cars-S', 'Scenes-S'};
ncats = length(cats); % number of stimulus conditions
nconds = ncats;  % number of conditions to be counterbalanced (including baseline blocks)

% Presentation and design parameters
nruns = 1; % number of runs
nreps = 3; % number of blocks per category per run
stimsperblock = 32; % number of stimuli in a block
stimdur = 0.5; % stimulus presentation time (secs)
TR = 2; % fMRI TR (secs)
propodd = .5;

nblocks = nconds*nreps; % number of blocks in a run
ntrials = nblocks*stimsperblock; % number of trials in a run
blockdur = stimsperblock*stimdur; % block duration (sec)
rundur = nblocks*blockdur; % run duration (sec)

participant_folder = fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'psychopy', 'data', participant);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE STIMULUS SEQUENCES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Trials are grouped into blocks, and each block consists of trials from the same category.
% The order of blocks within a run is randomized due to the randomization of stimulus categories.

% Create matrix for Block #
blockmat = zeros(ntrials,nruns);
for r = 1:nruns
    blockmat(:,r) = reshape(repmat(1:nblocks,stimsperblock,1),ntrials,1);
end

% Create matrix for condition (stimulus category); where the randomness
% component comes from
condmat = zeros(ntrials,nruns);
% Loop over runs
for r = 1:nruns
    % Generate a fixed order of the stimulus categories
    condvec = repmat([1:ncats], 1, 3);  % Each category repeats exactly 3 times
    % No need to reshuffle, this will ensure each category repeats 3 times
    condvec = condvec(:);  % Convert to a column vector
    
    % Ensure the total number of trials matches the number of categories
    condmat(:, r) = reshape(repmat(condvec', stimsperblock, 1), ntrials, 1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE MATRIX FOR IMAGES 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgmat = cell(ntrials, nruns); %initialize cell array with dims ntrials x nruns

for r = 1:nruns
    for cat = 1:ncats
        stimnums = randperm(144);
        counter = 0;
        for tri = 1:ntrials
            if condmat(tri,r) == cat
                counter = counter + 1;
                imgmat{tri,r} = strcat(lower(cats{cat}(1:end-2)),'-',num2str(stimnums(counter)),'.jpg'); % assign unique image for each trial
            else
            end
        end
    end
end

disp(imgmat)

% Path to the directory containing image files
stim_directory = fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'stimuli',  'static_floc');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE CSV containing static blocks 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% List of valid block numbers
static = [3, 6, 8, 11, 14, 16, 19, 22, 24, 27, 30, 32];

imgmat;
stim_type = 'image';

csvfilename = fullfile(participant_folder, strcat('static_blocks_run', num2str(run), '.csv'));
fid = fopen(csvfilename, 'w');
if fid == -1
    error('Failed to open file: %s', csvfilename);
end
fprintf(fid, 'Block #,Onset-time(s),Category,TaskMatch,Stim Name,Stim Path,Stim Type,Stim Dur\n');

onset_time = 0; 
current_block_idx = 1;  % Initialize an index to track position in the static array
current_block = static(current_block_idx);  % Start with the first valid block number

% Iterate over each trial in ntrials
for i = 1:ntrials

    % Write the stimulus block (from img_mat)
    img_name = imgmat{i, r};
    img_path = fullfile(stim_directory, img_name);

    fprintf(fid, '%i,%f,%i,%s,%s,%s,%s,%f\n', ...
        current_block,... % write trial block
        onset_time,... % write trial onset time
        condmat(i, r),... % write trial condition,
        cats{condmat(i, r)},... % write stimulus category
        img_name, ... % write image file name
        img_path, ... % write full image path
        stim_type, ... % write stim type
        stimdur);

    % Check if the next trial belongs to a different category
    if i < ntrials && condmat(i, r) ~= condmat(i + 1, r) 
        % Increment current block by 1 step (valid block number)
        current_block_idx = current_block_idx + 1;
        
        % If we've reached the end of the static array, restart from the beginning
        if current_block_idx > length(static)
            current_block_idx = 1;  % Reset to the first valid block number
        end
        
        % Assign the next block number from the static array
        current_block = static(current_block_idx);
    end
end     

