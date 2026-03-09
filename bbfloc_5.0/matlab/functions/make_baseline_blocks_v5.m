function make_baseline_blocks_v5(participant, run)
%%%%%%%%%%%%%%%%%%%%%%%%%
% EXPERIMENTAL PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%
participant_folder = fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'psychopy', 'data', participant);

% Path to the directory containing image files
stim_dir = fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'stimuli',  'static_floc');

% Stimulus categories 
cats = {'blank'};
ncats = length(cats); % number of stimulus conditions
nconds = ncats;  % number of conditions to be counterbalanced (including baseline blocks)

% Presentation and design parameters
nruns = 1; % number of runs
nreps = 9; % number of blocks per category per run
stimsperblock = 16; % number of stimuli in a block
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

% Create matrix for condition (stimulus category)
condmat = zeros(ntrials, nruns);
for r = 1:nruns
    % Since we have only one category, condvec should just be an array of 1's
    condvec = ones(1, nblocks);  % All blocks are of the same condition 'blank'
    
    % Assign the condition (category) to the trials by replicating the condition
    condmat(:, r) = reshape(repmat(condvec, stimsperblock, 1), ntrials, 1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE MATRIX FOR IMAGES 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgmat = cell(ntrials, nruns); %initialize cell array with dims ntrials x nruns

for r = 1:nruns
    for cat = 1:ncats
        stimnums = randperm(512);
        counter = 0;
        for tri = 1:ntrials
            if condmat(tri,r) == cat
                counter = counter + 1;
                imgmat{tri,r} = strcat(lower(cats{cat}),'-',num2str(stimnums(counter)),'.jpg'); % assign unique image for each trial
            else
            end
        end
    end
end

disp(imgmat)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE CSV containing blocks 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stim_type = 'image';

    csvfilename = fullfile(participant_folder, strcat('baseline_blocks_run', num2str(run), '.csv'));
    fid = fopen(csvfilename, 'w');
    if fid == -1
        error('Failed to open file: %s', csvfilename);
    end
    fprintf(fid, 'Block #,Onset-time(s),Category,TaskMatch,Stim Name,Stim Path,Stim Type,Stim Dur\n');

    onset_time = 0; 
    current_block = 1;
    category = 0; 

    % Loop through trials
    for tri = 1:ntrials 
        img_name = imgmat{tri, r};
        stim_path = fullfile(stim_dir, img_name);
        
        % Determine if the current trial is the last in the block
        if mod(tri,16) == 0
            % Reduce the duration of the last trial by 0.0002 seconds
            fprintf(fid, '%i,%f,%i,%s,%s,%s,%s,%f\n', ...
                current_block, onset_time,  category, cats{1}, img_name, stim_path, stim_type, stimdur);
                
                current_block = current_block + 4; 
              
         else
            fprintf(fid, '%i,%f,%i,%s,%s,%s,%s,%f\n', ...
                current_block, onset_time,  category, cats{1}, img_name, stim_path, stim_type, stimdur);
        end
    end

    % Write closing baseline block
    current_block = current_block + 1;
end