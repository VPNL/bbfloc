function RUNME_makenewexp_bbfloc(participant, user)
%% Run this function to generate 10 unique bbfloc runs of various lengths and conditions 
%% INPUT
% participant's initials/number as string i.e. ('BR') 
% user of laptop for path reasons (i.e. VPNL)
%% OUTPUT
% Generates participant's necessary data folders to run psychopy
% Generates 2 runs/CSV scripts for static condition 
% Generates 2 runs/CSV scripts for dynamic condition

%% Generates participant's data folder if doesn't exist yet
participant_data_folder = fullfile('/Users', user, 'Desktop', 'bbfloc', 'psychopy', 'data', participant);

% Check if the folder doesn't already exist
if ~exist(participant_data_folder, 'dir')
    % Create the folder
    mkdir(participant_data_folder);
    disp(['Folder ''' participant_data_folder ''' created successfully.']);
else
    disp(['Folder ''' participant_data_folder ''' already exists.']);
end

%% Generates participant's long block run folder if it doesn't exist yet 
participant_longblock_folder = fullfile('/Users', user, 'Desktop', 'bbfloc', 'psychopy', 'data', participant, 'longblock');

% Check if the folder doesn't already exist
if ~exist(participant_longblock_folder, 'dir')
    % Create the folder
    mkdir(participant_longblock_folder);
    disp(['Folder ''' participant_longblock_folder ''' created successfully.']);
else
    disp(['Folder ''' participant_longblock_folder ''' already exists.']);
end

%% Generates participant's combined (dynamic and static) data folder if doesn't exist yet
participant_shortblock_folder = fullfile('/Users', user, 'Desktop', 'bbfloc', 'psychopy', 'data', participant, 'shortblock');

% Check if the folder doesn't already exist
if ~exist(participant_shortblock_folder, 'dir')
    % Create the folder
    mkdir(participant_shortblock_folder);
    disp(['Folder ''' participant_shortblock_folder ''' created successfully.']);
else
    disp(['Folder ''' participant_shortblock_folder ''' already exists.']);
end

%% Generates 2 runs/CSV scripts for static long block condition 
makeorder_babyloc_2_longblock_static_runs(participant)

%% Generates 2 runs/CSV scripts for dynamic long block condition 
makeorder_babyloc_2_longblock_dyna_runs(participant)

%% Generates 2 runs/CSV scripts for static short block condition 
makeorder_babyloc_2_shortblock_static_runs(participant)

%% Generates 2 runs/CSV scripts for dyna short block condition 
makeorder_babyloc_2_shortblock_dyna_runs(participant)
