function RUNME_makeorderbabyloc(participant)
%% Run this function to generate 10 unique bbfloc runs of various lengths and conditions 
%% INPUT
% participant's initials/number as string i.e. ('BR') 
%% OUTPUT
% Generates participant's necessary data folders to run psychopy
% Generates 2 runs/CSV scripts for short static condition 
% Generates 2 runs/CSV scripts for short dynamic condition 
% Generates 2 runs/CSV scripts for long static condition 
% Generates 2 runs/CSV scripts for long dynamic condition 


%% Generates participant's data folder if doesn't exist yet
participant_data_folder = fullfile('/Users', 'vpnl', 'Desktop', 'bbfloc', 'psychopy', 'data', participant);

% Check if the folder doesn't already exist
if ~exist(participant_data_folder, 'dir')
    % Create the folder
    mkdir(participant_data_folder);
    disp(['Folder ''' participant_data_folder ''' created successfully.']);
else
    disp(['Folder ''' participant_data_folder ''' already exists.']);
end

%% Generates participant's combined (dynamic and static) data folder if doesn't exist yet
participant_combinedrun_folder = fullfile('/Users', 'vpnl', 'Desktop', 'bbfloc', 'psychopy', 'data', participant, 'combined');

% Check if the folder doesn't already exist
if ~exist(participant_combinedrun_folder, 'dir')
    % Create the folder
    mkdir(participant_combinedrun_folder);
    disp(['Folder ''' participant_combinedrun_folder ''' created successfully.']);
else
    disp(['Folder ''' participant_combinedrun_folder ''' already exists.']);
end

%% Generates participant's grayscale dynamic data folder if doesn't exist yet
participant_grayscale_folder = fullfile('/Users', 'vpnl', 'Desktop', 'bbfloc', 'psychopy', 'data', participant, 'grayscale');

% Check if the folder doesn't already exist
if ~exist(participant_grayscale_folder, 'dir')
    % Create the folder
    mkdir(participant_grayscale_folder);
    disp(['Folder ''' participant_grayscale_folder ''' created successfully.']);
else
    disp(['Folder ''' participant_grayscale_folder ''' already exists.']);
end

%% Generates 2 runs/CSV scripts for short static condition 
makeorder_babyloc_2_short_static_runs(participant)

%% Generates 2 runs/CSV scripts for short dynamic condition 
makeorder_babyloc_2_short_dyna_runs(participant)

%% Generates 2 runs/CSV scripts for long static condition 
makeorder_babyloc_2_long_static_runs(participant)

%% Generates 2 runs/CSV scripts for long dynamic condition 
makeorder_babyloc_2_long_dyna_runs(participant)

%% Generates 2 runs/CSV scripts for long GRAYScale dynamic condition 
makeorder_babyloc_2_long_grayscale_dyna_runs(participant)
