function makeorder_CSV_new_v5(participant, run)

%% Generates the CSV for this run by compiling the blocks generated into one CSV and shuffling them to prevent consecutive category presentations

% Participant folder and file paths
participant_folder = fullfile('/Users', 'ctyagi', 'Desktop', 'bbfloc_5.0', 'psychopy', 'data', participant);

csvfile1 = fullfile(participant_folder, strcat('static_blocks_run', num2str(run), '.csv')); 
csvfile2 = fullfile(participant_folder, strcat('kosakowski_blocks_run', num2str(run), '.csv')); 
csvfile3 = fullfile(participant_folder, strcat('baseline_blocks_run', num2str(run), '.csv'));

% Read the CSV files into tables
data1 = readtable(csvfile1);
data2 = readtable(csvfile2);
data3 = readtable(csvfile3);

% Combine the datasets 
data = vertcat(data1, data2);

% Extract block numbers
blockNumbers = data{:, 1};  % Assuming the first column contains the block numbers

% Identify unique block numbers
uniqueBlocks = unique(blockNumbers);


BlockRemap = [2, 3, 4, 6, 7, 8, 10, 11, 12, 14, 15, 16, 18, 19, 20, 22, 23, 24, 26, 27, 28, 30, 31, 32];


% Define the arrays - each array contains block alternating by cond
uniqueBlocks1 = [2, 3, 4, 6, 7, 8, 10, 11]; 
uniqueBlocks2 = [12, 14, 15, 16, 18, 19, 20, 22]; 
uniqueBlocks3 = [23, 24, 26, 27, 28, 30, 31, 32]; 



% Shuffle each array
shuffledBlocks1 = customshuffle(uniqueBlocks1);
shuffledBlocks2 = customshuffle(uniqueBlocks2);
shuffledBlocks3 = customshuffle(uniqueBlocks3);


uniqueBlocks = [shuffledBlocks1, shuffledBlocks2, shuffledBlocks3];

% Initialize cell array to store grouped data by block
groupedData = cell(length(uniqueBlocks), 1);


% Initialize cell array to store grouped data by block
%groupedData = cell(length(uniqueBlocks), 1);

% Step 3: Group rows by block number and store them in a cell array
for i = 1:length(uniqueBlocks)
    % Find the indices of rows for the current block
    blockIndices = blockNumbers == uniqueBlocks(i);
    
    % Store the rows belonging to this block in the cell array
    groupedData{i} = data(blockIndices, :);
end

% Step 4: Remap block numbers according to the shuffled order
remappedData = [];  % Initialize empty array for remapped data

% Create a new variable to track task matches (by prefix)
lastTaskMatchPrefix = '';  % Initialize an empty string to store the task match prefix of the previous block

% Loop over the shuffled block order and remap block numbers
for i = 1:length(uniqueBlocks)
    % Get the group corresponding to the current shuffled block number
    group = groupedData{i};
    
    % Update the block number in the current group to the new shuffled value
    group{:, 1} = BlockRemap(i);  % Replace block number (first column)
    
    % Concatenate this group to the final data
    remappedData = [remappedData; group];  % Append to remapped data
end

remappedData2 = vertcat(remappedData, data3);
% Step 7: Sort the data so that blocks are in numerical order
sortedData = sortrows(remappedData2, 1);  % Sorting based on the first column (block number)

% Step 5: Set the onset time for the first trial
sortedData.Onset_time_s_(1) = 0.0;  % First trial onset time is 0.0 seconds

% Step 6: Calculate onset times for subsequent trials based on StimDur
for i = 2:height(sortedData)
    % The onset time of the current trial is the onset time of the previous trial + its duration
    sortedData.Onset_time_s_(i) = sortedData.Onset_time_s_(i-1) + sortedData.StimDur(i-1);
end

% Step 7: Save the result to a new CSV file
outputFile = fullfile(participant_folder, strcat('run', num2str(run), '.csv'));
writetable(sortedData, outputFile, 'WriteVariableNames', true);

% Display the final sorted data with onset times
disp(sortedData);



end
