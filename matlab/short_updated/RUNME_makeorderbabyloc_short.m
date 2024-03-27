function RUNME_makeorderbabyloc_short(participant, user)
%% Run this function to generate 12 short unique bbfloc runs 
%% INPUT
% participant's initials/number as string i.e. ('BR') 
% user of laptop for path reasons (i.e. VPNL) 
%% OUTPUT
% Generates participant's necessary data folders to run psychopy
% Generates 6 runs/CSV scripts for short static condition 
% Generates 6 runs/CSV scripts for short dynamic condition 


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

%% Generates participant's data folder if doesn't exist yet
participant_combinedrun_folder = fullfile('/Users', user, 'Desktop', 'bbfloc', 'psychopy', 'data', participant, 'short');

% Check if the folder doesn't already exist
if ~exist(participant_combinedrun_folder, 'dir')
    % Create the folder
    mkdir(participant_combinedrun_folder);
    disp(['Folder ''' participant_combinedrun_folder ''' created successfully.']);
else
    disp(['Folder ''' participant_combinedrun_folder ''' already exists.']);
end

%% Generates 6 runs/CSV scripts for short static condition 
makeorder_babyloc_static_short_updated(participant, user)

%% Generates 6 runs/CSV scripts for short dynamic condition 
makeorder_babyloc_dyna_short_updated(participant, user)
