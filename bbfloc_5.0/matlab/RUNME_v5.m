function RUNME_v5(participant)
%% Run this function to generate 2 unique runs containing blocks of Heather Kosakowski's dynamic stimuli with 4 reps per category 
%% and 2 unique runs containing blocks of fLoc-static stimuli with 4 reps per category 

%% INPUT:
% participant's initials/number as string i.e. ('BR') 
% run: run you're generating as integer (ie.: 1, 2, 3)

%% OUTPUT:
% Generates participant's necessary combinedData folders to run psychopy
% Generates a CSV and parfile for the run, as well as an mp4.video
% containing all the stimuli for the run (to be used in runMe.Py)

%% Generates participant's combinedData folder if doesn't exist yet

addpath(fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'matlab', 'functions'));
addpath(fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'matlab'));
addpath(fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'matlab', 'functions', 'kosakowski_stim_run'));
addpath(fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'matlab', 'functions', 'static_stim_run'));

participant_folder = fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'psychopy', 'data', participant);

% Check if the folder doesn't already exist
if ~exist(participant_folder, 'dir')
    % Create the folder
    mkdir(participant_folder);
    disp(['Folder ''' participant_folder ''' created successfully.']);
else
    disp(['Folder ''' participant_folder ''' already exists.']);
end

for run = 1:4
    %% Generate run CSV and parfile for runs
    if mod(run, 2) == 0 %if an even run it will be an fLoc-static run
    
        % First generate the blocks for the run
        % Generate blocks containing static-fLoc stimuli
        make_sblocks_2reps(participant, run)
        % Generate baseline blocks
        make_baseline_blocks_srun(participant,run)
    
        % Combine these blocks in a CSV
        makeorder_CSV_srun(participant, run)
    
        % Generate a par file for the run
        parfile_gen_srun(participant, run)
        parfile_2TR_gen_srun(participant, run)
        
        % Generate video of the run
        video_gen_krun(participant, run)
    
    else %if an odd run - it will contain dynamic kosakowski stimuli
    
        % First generate the blocks for the run
        % Generate blocks containing Kosakowkski's dynamic stimuli
        make_kblocks_2reps(participant, run)
        % Generate baseline blocks
        make_baseline_blocks_krun(participant,run)
    
        % Combine these blocks in a CSV
        makeorder_CSV_krun(participant, run)
    
        % Generate a par file for the run
        parfile_gen_krun(participant, run)
        parfile_2TR_gen_krun(participant, run)
        
        % Generate video of the run
        video_gen_krun(participant, run)
    end
    
end

