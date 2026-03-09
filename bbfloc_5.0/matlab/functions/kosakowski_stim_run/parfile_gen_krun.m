function parfile_gen_krun(participant,run)
%% generates parfile from the CSV 
% single 16s block will be split into two 8s blocks for mrVista
% compatibilty

% Participant folder and file paths
participant_folder = fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'psychopy', 'data', participant);

% Step 7: Save the result to a new CSV file
csvFile = fullfile(participant_folder, strcat('run', num2str(run), '.csv'));

% Define color codes for categories
color_codes = containers.Map( ...
    {0, 5, 6, 7, 8}, ...
    {'0 0 0', '0.7 0.3 0.8', '1 0 0.5', '0.8 0.8 0.5', '0 0.1 0.4'} ...
);

% Initialize an empty cell array for storing parfile data
par_file_data = {};

% Open and read the CSV file
fid = fopen(csvFile, 'r');
if fid == -1
    error('Could not open the CSV file.');
end

% Skip the header row
fgetl(fid);  

% Initialize the current onset time
current_onset_time = 0.0;

% Read the file line by line
while ~feof(fid)
    line = fgetl(fid);  % Read each line
    if isempty(line)
        continue;
    end
    
    parts = strsplit(line, ',');  % Split by commas
    
    % Extract relevant information from the line
    block_num = str2double(parts{1});  % Block number (not used directly in parfile)
    onset_time = str2double(parts{2});  % Onset time (in seconds)
    category = str2double(parts{3});   % Category (used for color code)
    task_match = parts{4};             % Task match (string, e.g. 'Faces-S')
    stim_name = parts{5};              % Stimulus name
    stim_path = parts{6};              % Stimulus path (not used in the parfile)
    stim_type = parts{7};              % Stimulus type (not used in the parfile)
    stim_duration = str2double(parts{8});  % Stimulus duration in seconds

    % Debugging: Check extracted data
    disp(['Block: ' num2str(block_num) ', Onset: ' num2str(onset_time) ...
          ', Category: ' num2str(category) ', TaskMatch: ' task_match ...
          ', Stimulus: ' stim_name ', Duration: ' num2str(stim_duration)]);

    % Get color code based on category
    if isKey(color_codes, category)
        color_code = color_codes(category);
    else
        color_code = '0 0 0';  % Default to blank color if category is not found
    end

    % Add multiple onset times if stimulus duration is greater than 8 seconds
    while current_onset_time < onset_time + stim_duration
        % Add this entry to the parfile data
        par_file_data{end+1, 1} = current_onset_time;  % Onset time
        par_file_data{end, 2} = category;              % Category
        par_file_data{end, 3} = task_match;            % Task match
        par_file_data{end, 4} = color_code;            % Color code

        % Increment onset time by 8 seconds
        current_onset_time = current_onset_time + 8.0; 
    end
end

% Close the CSV file
fclose(fid);

% Check if par_file_data is populated
if isempty(par_file_data)
    error('No data was processed. Please check the CSV input.');
end

% Define the output path for the .par file
output_parfile_path = fullfile(participant_folder, ['run' num2str(run) '.par']);

% Ensure the output directory exists
[output_dir, ~, ~] = fileparts(output_parfile_path);
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Open the .par file for writing
fid = fopen(output_parfile_path, 'w');
if fid == -1
    error('Could not create the output .par file.');
end


% Write each entry in the parfile data
for i = 1:size(par_file_data, 1)
    fprintf(fid, '%.3f\t%d\t%s\t%s\n', ...
        par_file_data{i, 1}, par_file_data{i, 2}, par_file_data{i, 3}, par_file_data{i, 4});
end

% Close the .par file
fclose(fid);

% Display success message
disp(['Par file exported successfully to: ' output_parfile_path]);
