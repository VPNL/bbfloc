function bbfloc_computeContrastMaps_v5(GLM)

% based on compute_allcontrasts from Longitudinal (% VSN 05/2014)


% This code is appropriate localizer scans with
% parfiles corresponding to the conditions listed below:
% 0 Blank
% 1 faces-static    
% 2 limbs-static
% 3 cars-static
% 4 scenes-static
% 5 food-static
% 6 faces-dynamic
% 7 limbs-dynamic
% 8 cars-dynamic
% 9 scenes-dynamic 
%%%%%%%%%%%%

% adapted from Longi for Kids AcrossYears (MN 2019) 

hI = initHiddenInplane('GLMs');
hI = setCurScan(hI,GLM);

% ALL visual contrasts (sanity checks) 
hI=computeContrastMap2(hI, [1 2 3 4 5 6 7 8], 0,'Visual_vs_blank','test','T', 'mapUnits', 'T'); 

% ALL face contrasts
hI=computeContrastMap2(hI, 1, [2 3 4], 'Faces-D_vs_allDynamic','test','T', 'mapUnits', 'T'); 

% ALL limb contrasts
hI=computeContrastMap2(hI, 2, [1 3 4], 'Limbs-D_vs_allDynamic','test','T', 'mapUnits', 'T'); 

% ALL car contrasts
hI=computeContrastMap2(hI, 3, [1 2 4], 'Cars-D_vs_allDynamic','test','T', 'mapUnits', 'T'); 

% ALL scene contrasts
hI=computeContrastMap2(hI, 4, [1 2 3], 'Scenes-D_vs_allDynamic','test','T', 'mapUnits', 'T'); 

% Animate vs inanimate
hI=computeContrastMap2(hI, [1 2], [3 4],'animate_vs_inanimate','test','T', 'mapUnits', 'T'); 

% Faces_vs_scenes
hI=computeContrastMap2(hI, 1, 4,'faces_vs_scenes','test','T', 'mapUnits', 'T');


%% Tally how many times each condition appears - save tally in txt file 
% complile list of all conditions in parfiles
%% Tally how many times each condition appears - save tally in txt file 
load mrInit_params.mat
load mrSESSION.mat

[cond_nums, conds] = deal([]); cnt = 0;
for rr = 1:length(params.functionals)  % Adjust if only certain runs are needed
    fid = fopen(params.parfile{rr}, 'r');
    if fid == -1
        error('Cannot open parfile: %s', params.parfile{rr});
    end
    while ~feof(fid)
        ln = strtrim(fgetl(fid));
        if isempty(ln), continue; end  % skip empty lines, but don’t exit
        ln(ln == sprintf('\t')) = ' ';  % convert tabs to spaces
        prts = strsplit(ln, ' ');
        prts(cellfun(@isempty, prts)) = [];
        if length(prts) >= 3
            cnt = cnt + 1;
            cond_nums(cnt) = str2double(prts{2});
            conds{cnt} = prts{3};
        end
    end
    fclose(fid);
end

% Get list of unique condition numbers and their names
[cond_num_list, ~, ic] = unique(cond_nums);
cond_list = cell(size(cond_num_list));
for i = 1:length(cond_num_list)
    first_idx = find(cond_nums == cond_num_list(i), 1);
    cond_list{i} = conds{first_idx};
end

% Count occurrences
cond_counts = histcounts(cond_nums, 'BinMethod', 'integers');

% Write to file
output_filename = 'condition_counts.txt';
fid = fopen(output_filename, 'w');
if fid == -1
    error('Error opening file for writing: %s', output_filename);
end

fprintf(fid, 'Condition | Count\n');
fprintf(fid, '----------------------------\n');
for i = 1:length(cond_num_list)
    if i == 1 
        fprintf(fid, '%s appears %d times\n', cond_list{1}, cond_counts(1));
    else
        fprintf(fid, '%s appears %d times\n', cond_list{i}, cond_counts(i+4));
    end
end
fclose(fid);

fprintf('Tallying has been saved to %s\n', output_filename);

