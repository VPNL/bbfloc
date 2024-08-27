function RUNME_newexp(participant, version, user)
%% Run this function to generate 6 unique bbfloc runs: 
%% INPUT
% participant's initials/number as string i.e. ('BR') 
% version of exp you want (as a string): 1, 2, 3 
% user: user of laptop 

%% OUTPUT
% Generates participant's necessary data folders to run psychopy
% Generates 2 runs/CSV scripts for static condition: runtime (248s) 
% Generates 2 runs/CSV scripts for dynamic condition: runtime (264s)
% Generates 2 runs/CSV scripts for Saxe condition: runtime (200s) 

% Version 1 run order: run1) Saxe, run2) static floc, run3) dynamic, run4) Saxe, run5) static floc, run6) dynamic
% Version 2 run order: run1) dyna, run2) Saxe, run3) static floc, run4) dyna, run5) Saxe, run6) static floc
% Version 3 run order: run1) static floc, run2) dyna, run3) Saxe, run4) static floc, run5) dyna, run6) Saxe

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


%% Generates participant's exp version folder if it doesn't exist yet 

if version == 1
   participant_newexp_folder = fullfile('/Users', user, 'Desktop', 'bbfloc', 'psychopy', 'data', participant, 'exp_v1');
elseif version == 2
   participant_newexp_folder = fullfile('/Users', user, 'Desktop', 'bbfloc', 'psychopy', 'data', participant, 'exp_v2');
elseif version == 3
    participant_newexp_folder = fullfile('/Users', user, 'Desktop', 'bbfloc', 'psychopy', 'data', participant, 'exp_v3');
end

% Check if the folder doesn't already exist
if ~exist(participant_newexp_folder, 'dir')
    % Create the folder
    mkdir(participant_newexp_folder);
    disp(['Folder ''' participant_newexp_folder ''' created successfully.']);
else
    disp(['Folder ''' participant_newexp_folder ''' already exists.']);
end


%% Generates 2 runs/CSV scripts for static condition 
makeorder_babyloc_2_static_runs(participant, version, user)

%% Generates 2 runs/CSV scripts for dynamic condition 
makeorder_babyloc_2_dyna_runs(participant, version, user)

%% Generates 2 runs/CSV scripts for saxe condition
makeorder_2_saxe_runs(participant, version)
