function makeorder_babyloc_2_longblock_static_runs(participant, user)
%% Generates 2 runs/CSV scripts for functional
%% localizer for the infant scans containing 16 stimuli per block with presentation rates of
%% 2Hz. Last image in a run is a random pattern, to account for lag in measuring frame rate.
%
% INPUT: Should be the baby's number, user of the laptop 
% OUTPUTS: Separate script files for each run of PTB experiment.
%
% STIMULI: 4 stimulus conditions (aka cateogries)
% 1) Faces-S: adult set; static
% 2) Hands-S: limbs static
% 3) Cars-S: cars static
% 4) Scenes-S: places static indoor and outdoors 
%
%
% BLANKS: 1 blank block appears between each block of stimuli 
%
%% no task for the infant floc
%% VERSION: 1.0 9/29/2023 by AS & VN & XY & CT
% Department of Psychology, Stanford University

%%%%%%%%%%%%%%%%%%%%%%%%%
% EXPERIMENTAL PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%

% Stimulus categories (categories in same condition must be grouped)
cats = {'Faces-S', 'Hands-S', 'Cars-S', 'Scenes-S'};
ncats = length(cats); % number of stimulus conditions
nconds = ncats;  % number of conditions to be counterbalanced (including baseline blocks)

% Presentation and design parameters
nruns = 2; % number of runs
nreps = 4; % number of blocks per category per run
stimsperblock = 16; % number of stimuli in a block
stimdur = .5; % stimulus presentation time (secs)
TR = 2; % fMRI TR (secs)
propodd = .5;

nblocks = nconds*nreps; % number of blocks in a run
ntrials = nblocks*stimsperblock; % number of trials in a run
blockdur = stimsperblock*stimdur; % block duration (sec)
rundur = nblocks*blockdur; % run duration (sec)


% Get user input and concatenate it into the file path
participant_folder = fullfile('/Users', user, 'Desktop', 'bbfloc', 'psychopy', 'data', participant, 'longblock');

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
for r = 1:nruns
    condvec = [randperm(ncats), randperm(ncats), randperm(ncats), randperm(ncats)];    % generate the order of the stim presentation
    % Check for consecutive repetitions of category and reshuffle if found;
    % ensure each category repeats exactly four times within a run
    while any(diff(condvec) == 0)
        condvec = [randperm(ncats), randperm(ncats), randperm(ncats), randperm(ncats)];
    end
    
    condvec = [condvec'];
    condmat(:, r) = reshape(repmat(condvec', stimsperblock, 1), ntrials, 1);
 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE MATRIX FOR IMAGES 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgmat = cell(ntrials, nruns); %initialize cell array with dims ntrials x nruns

for r = 1:nruns
      % function that tells you unique entries
      stimnums = randperm((nreps+2)*stimsperblock);
      stimnums = stimnums + (r - 1)*((nreps+2)*stimsperblock); % randomize order of stimuli to be used in current run
      counter = 0;
       
   
    for cat = 1:ncats
     
        stimnums = randperm(nreps*stimsperblock);
        stimnums = stimnums + (r - 1)*(nreps*stimsperblock); % randomize order of stimuli to be used in current run
        counter = 0;
        for tri = 1:ntrials
           
            if condmat(tri,r) == cat
                counter = counter + 1;
                imgmat{tri,r} = strcat(lower(cats{cat}(1:end-2)),'-',num2str(stimnums(counter)),'.jpg'); % assign unique image for each trial
            else
            end
        end
    end
    counter = 0;
end

disp(imgmat)

%%%%%%%%%%%%%%%%%%%
% WRITE CSV
%%%%%%%%%%%%%%%%%%%


% Path to the directory containing image files
image_directory = fullfile('/Users', user, 'Desktop', 'bbfloc', 'stimuli',  'static_stimuli');

% Define base name for blank images
blank_base_name = 'blank';

for r = 1:nruns
        csvfilename = fullfile(participant_folder, strcat('script_babyloc_static_longblock_run', num2str(r*2), '.csv'));
        fid = fopen(csvfilename, 'w');
        fprintf(fid, 'Block #,Onset-time(s),Category,TaskMatch,Image Name,Image Path\n');
 
        onset_time = 0; %initalize onset time
        baseline_block = 1; % initalize block #


        % Add 8-second blank block (baseline) before the first category
        % block is presented
        for dur = 1:16 %loop thru each trial
            random_index = randi([1, 144]); %pick a random image for the current trial
            % Construct the image name with the current loop index
            blank_img_name = sprintf('%s-%d', blank_base_name, random_index); %generate image name for the current trial
            blank_img_path = fullfile(image_directory, blank_img_name); %generate image path for the current trial
            
            fprintf(fid, '%i,%f,%i,%s,%s,%s\n', ...
                baseline_block,... % write blank block
                onset_time,... % write blank onset time
                0, ... % write blank condition
                'Blank', ... % write blank category
                blank_img_name, ... % empty image name
                blank_img_path); % empty image path
            onset_time = onset_time + stimdur; % Update onset time for the next trial
        
        end

        % Update block number for the next block to be presented
        current_block = baseline_block + 1;
       
        % Iterate over each trial in ntrials
        for i = 1:ntrials

            % Write the stimulus block (from img_mat)
            img_name = imgmat{i, r};
            img_path = fullfile(image_directory, img_name);

            fprintf(fid, '%i,%f,%i,%s,%s,%s\n', ...
                current_block,... % write trial block
                onset_time,... % write trial onset time
                condmat(i, r),... % write trial condition,
                cats{condmat(i, r)},... % write stimulus category
                img_name, ... % write image file name
                img_path); % write full image path

            % Update onset time for the next stimulus
            onset_time = onset_time + stimdur; % Update onset time for the next trial

            % Check if the next trial belongs to a different category
            if i < ntrials && condmat(i, r) ~= condmat(i + 1, r) 
                
                % Increment block number for the next stimulus trial
                current_block = current_block + 1;

                % Insert a blank block with 16 blank images before the next
                % stimulus trial 
                for dur = 1:16 %loop thru each trial 
                    random_index = randi([1, 144]); %pick a random image for the current trial
                    blank_img_name = sprintf('%s-%d', blank_base_name, random_index);
                    blank_img_path = fullfile(image_directory, blank_img_name);
                    fprintf(fid, '%i,%f,%i,%s,%s,%s\n', ...
                        current_block,... % write blank block
                        onset_time,... % write trial onset time
                        0, ... % write blank condition
                        'Blank', ... % write blank category
                        blank_img_name, ... % empty image name
                        blank_img_path); % empty image path
                    onset_time = onset_time + stimdur; % Update onset time for the next trial
                end

                % Update block number for the next category block
                current_block = current_block + 1;
            end
        end

        % Add 8-second blank baseline block after the last category block
        % is presented
        for dur = 1:16 %loop thru each trial
            random_index = randi([1, 144]); %pick a random image for the current trial
            blank_img_name = sprintf('%s-%d', blank_base_name, random_index); %generate image name for the current trial
            blank_img_path = fullfile(image_directory, blank_img_name); %generate image path for the current trial
            fprintf(fid, '%i,%f,%i,%s,%s,%s\n', ...
                current_block+1,... % write blank block
                onset_time,... % write blank onset time
                0, ... % write blank condition
                'Blank', ... % write blank category
                blank_img_name, ... % empty image name
                blank_img_path); % empty image path
            onset_time = onset_time + stimdur; % Update onset time for the next blank imag   
        end

    end        
end
