% 
rr=3
% % % Define the path to the .par file
par_file = fullfile(pwd, ['run' num2str(rr) '_2TR.par']);


% Check if the .par file exists
if ~exist(par_file, 'file')
    error(['.par file not found: ', par_file]);
end

% Load the .par file
% Assuming each line corresponds to a timing point (TR), and we're interested in the first column (time or TR)
%par_data = readtable(par_file, 'FileType', 'text', 'Delimiter', '/', 'ReadVariableNames', false);  % Adjust the delimiter as needed
par_data = readtable(par_file, 'FileType', 'text'); 

%% bb106 need to remap vals and conds 
% groupMap = containers.Map({'Blank', 'Faces_side', 'Faces_front', 'Limbs_hands', 'Limbs_feet', 'Objects_collisions', 'Objects_shapes', 'Scenes_fences', 'Scenes_egomotion'}, {'blank', 'faces', 'faces', 'bodies',  'bodies', 'objects', 'objects', 'places', 'places'});
% valueMap = containers.Map([0, 10, 11, 12, 13, 14, 15, 16, 17], [0, 1, 1, 2, 2, 3, 3, 4, 4]);
% 
% groupMap = containers.Map({'Blank', 'Faces_side', 'Faces_front', 'Limbs_hands', 'Limbs_feet', 'Objects_collisions', 'Objects_shapes', 'Scenes_fences', 'Scenes_egomotion'}, {'blank', 'faces', 'faces', 'bodies',  'bodies', 'objects', 'objects', 'places', 'places'});

%% bb108: need to remap conds and vals (also has additional food category!)
groupMap = containers.Map({'Blank', 'Faces-S', 'Faces-D', 'Limbs-S', 'Limbs-D', 'Cars-S', 'Objects-D', 'Scenes-S', 'Scenes-D', 'Food-S'}, {'blank', 'faces', 'faces', 'bodies', 'bodies', 'objects', 'objects', 'places', 'places', 'food'});
valueMap = containers.Map([0, 1, 6, 2, 7, 3, 8, 4, 9, 5], [0, 1, 1, 2, 2, 3, 3, 4, 4, 5]);


%% bb110, bb119, bb124 bb125, bb130: need to remap conds and vals
groupMap = containers.Map({'Blank', 'Faces-S', 'Faces-D', 'Limbs-S', 'Limbs-D', 'Cars-S', 'Objects-D', 'Scenes-S', 'Scenes-D'}, {'blank', 'faces', 'faces', 'bodies', 'bodies', 'objects', 'objects', 'places', 'places'});
valueMap = containers.Map([0, 1, 5, 2, 6, 3, 7, 4, 8], [0, 1, 1, 2, 2, 3, 3, 4, 4]);

%% bb100: need to remap conds and vals
% groupMap = containers.Map({'Blank', 'Faces-S', 'Faces-M', 'Hands-S', 'Hands-M', 'Cars-S', 'Cars-M', 'Scenes-S', 'Scenes-M'}, {'blank', 'faces', 'faces', 'bodies', 'bodies', 'objects', 'objects', 'places', 'places'});
% valueMap = containers.Map([0, 1, 5, 2, 6, 3, 7, 4, 8], [0, 1, 1, 2, 2, 3, 3, 4, 4]);

%% bb98 (only need to remap values) conds are fine
% groupMap = containers.Map({'Blank', 'Faces-S', 'Faces-D', 'Limbs-S', 'Limbs-D', 'Cars-S', 'Objects-D', 'Scenes-S', 'Scenes-D'}, {'blank', 'faces', 'faces', 'bodies', 'bodies', 'objects', 'objects', 'places', 'places'});
% 
% valueMap = containers.Map([0, 1, 5, 2, 6, 3, 7, 4, 8], [0, 1, 1, 2, 2, 3, 3, 4, 4]);

new_data = {};  
counter = 0.0;

for i = 1:size(par_data, 1)
    % Time
    new_data{i, 1} = counter;

    % Remap Value (col 2)
    orig_val = double(par_data{i, 2});
    if isKey(valueMap, orig_val)
        new_val = valueMap(orig_val);
    else
        new_val = orig_val; % fallback
    end
    new_data{i, 2} = double(new_val);
    if new_val == 1
        new_data {i, 4} = num2str(1);
        new_data {i, 5} = num2str(0);
        new_data {i, 6} = num2str(0);
    elseif new_val == 2
        new_data {i, 4} = num2str(0.8);
        new_data {i, 5} = num2str(0.8);
        new_data {i, 6} = num2str(0);
    elseif new_val == 3
        new_data {i, 4} = num2str(0);
        new_data {i, 5} = num2str(0);
        new_data {i, 6} = num2str(1);
    elseif new_val == 4
        new_data {i, 4} = num2str(0);
        new_data {i, 5} = num2str(1);
        new_data {i, 6} = num2str(0);
    else  
        new_data {i, 4} = num2str(0);
        new_data {i, 5} = num2str(0);
        new_data {i, 6} = num2str(0);

    end



    % Remap Group (col 3)
    orig_group = string(par_data{i, 3});
    if isKey(groupMap, orig_group)
        new_group = groupMap(orig_group);
    else
        new_group = orig_group; % fallback
    end
    new_data{i, 3} = string(new_group);

    % % Pass through remaining columns
    % new_data{i, 4} = string(par_data{i, 4});
    % new_data{i, 5} = string(par_data{i, 5});
    % new_data{i, 6} = string(par_data{i, 6});

    % Increment time
    counter = counter + 2.0;
end

% Convert to table
result_table = cell2table(new_data, 'VariableNames', {'Time', 'Value', 'Group', 'Val1', 'Val2', 'Val3'});
result_table.colorcode = join([result_table.Val1, result_table.Val2, result_table.Val3]);
result_table(:, {'Val1', 'Val2', 'Val3'}) = [];


output_par_file = fullfile(pwd, ['run' num2str(rr) '_NSF.par']);
% Open the .par file for writing
fid = fopen(output_par_file, 'w');
if fid == -1
    error('Could not create the output .par file.');
end

% Save the modified .par file
for i = 1:size(result_table, 1)
    fprintf(fid, '%.1f\t%d\t%s\t%s\n', ...
        result_table.Time(i), result_table.Value(i), result_table.Group(i), char(result_table.colorcode(i)));
end

% Close the .par file
fclose(fid);

% Display success message
disp('Par file exported successfully to: output_par_file')
clx
