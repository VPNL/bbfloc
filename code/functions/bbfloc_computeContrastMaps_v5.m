function bbfloc_computeContrastMaps_v5(GLM)

% based on compute_allcontrasts from Longitudinal (% VN 05/2014)
% CT 4/26

% This code is appropriate localizer scans with
% parfiles corresponding to the conditions listed below:
% 0 Blank
% 1 faces-static    
% 2 limbs-static
% 3 cars-static
% 4 scenes-static
% 5 faces-dynamic
% 6 limbs-dynamic
% 7 cars-dynamic
% 8 scenes-dynamic 
%%%%%%%%%%%%

% adapted from Longi for Kids AcrossYears (MN 2019) 

hI = initHiddenInplane('GLMs');
hI = setCurScan(hI,GLM);

% ALL visual contrasts (sanity checks) 
hI=computeContrastMap2(hI, [1 2 3 4 5 6 7 8], 0,'Visual_vs_blank','test','T', 'mapUnits', 'T'); 
hI=computeContrastMap2(hI, [1 2 3 4], 0, 'allStatic_vs_blank','test','T', 'mapUnits', 'T');
hI=computeContrastMap2(hI, [5 6 7 8], 0, 'allDynamic_vs_blank','test','T', 'mapUnits', 'T'); 

% ALL face contrasts
hI=computeContrastMap2(hI, [1 5], [2 3 4 6 7 8],'faces_vs_all','test','T', 'mapUnits', 'T'); 

hI=computeContrastMap2(hI, 1, [2 3 4], 'Faces-S_vs_allStatic','test','T', 'mapUnits', 'T');
hI=computeContrastMap2(hI, 1, [2 3 4 6 7 8], 'Faces-S_vs_allNonFaces','test','T', 'mapUnits', 'T');

hI=computeContrastMap2(hI, 5, [6 7 8], 'Faces-D_vs_allDynamic','test','T', 'mapUnits', 'T'); 
hI=computeContrastMap2(hI, 5, [2 3 4 6 7 8], 'Faces-D_vs_allNonFaces','test','T', 'mapUnits', 'T'); 

% ALL limb contrasts
hI=computeContrastMap2(hI, [2 6], [1 3 4 5 8 7],'limbs_vs_all','test','T', 'mapUnits', 'T'); 

hI=computeContrastMap2(hI, 2, [1 3 4], 'Limbs-S_vs_allStatic','test','T', 'mapUnits', 'T');
hI=computeContrastMap2(hI, 2, [1 3 4 5 8 7], 'Limbs-S_vs_allNonLimbs','test','T', 'mapUnits', 'T');

hI=computeContrastMap2(hI, 6, [5 7 8], 'Limbs-D_vs_allDynamic','test','T', 'mapUnits', 'T'); 
hI=computeContrastMap2(hI, 6, [1 3 4 5 8 7], 'Limbs-D_vs_allNonLimbs','test','T', 'mapUnits', 'T');

% ALL car contrasts
hI=computeContrastMap2(hI, [3 7], [1 2 4 5 6 8],'objects_vs_all','test','T', 'mapUnits', 'T'); 

hI=computeContrastMap2(hI, 3, [1 2 4], 'Objects-S_vs_allStatic','test','T', 'mapUnits', 'T');
hI=computeContrastMap2(hI, 3, [1 2 4 5 6 8], 'Objects-S_vs_allNonObjects','test','T', 'mapUnits', 'T');

hI=computeContrastMap2(hI, 7, [5 6 8], 'Objects-D_vs_allDynamic','test','T', 'mapUnits', 'T'); 
hI=computeContrastMap2(hI, 7, [1 2 4 5 6 8], 'Objects-D_vs_allNonObjects','test','T', 'mapUnits', 'T');

% ALL scene contrasts
hI=computeContrastMap2(hI, [4 8], [1 2 3 5 6 7],'scenes_vs_all','test','T', 'mapUnits', 'T'); 

hI=computeContrastMap2(hI, 4, [1 2 3], 'Scenes-S_vs_allStatic','test','T', 'mapUnits', 'T');
hI=computeContrastMap2(hI, 4, [1 2 3 5 6 7], 'Scenes-S_vs_allNonScenes','test','T', 'mapUnits', 'T');

hI=computeContrastMap2(hI, 8, [5 6 7], 'Scenes-D_vs_allDynamic','test','T', 'mapUnits', 'T'); 
hI=computeContrastMap2(hI, 8, [1 2 3 5 6 7], 'Scenes-D_vs_allNonScenes','test','T', 'mapUnits', 'T');


% Animate vs inanimate
hI=computeContrastMap2(hI, [1 2 5 6], [3 4 7 8],'animate_vs_inanimate','test','T', 'mapUnits', 'T'); 

% Faces_vs_scenes
hI=computeContrastMap2(hI, [1 5], [4 8],'faces_vs_scenes','test','T', 'mapUnits', 'T');


%% Tally how many times each condition appears - save tally in txt file 
% complile list of all conditions in parfiles
load mrInit_params.mat
load mrSESSION.mat

[cond_nums, conds] = deal([]); cnt = 0;
for rr = 1:length(params.functionals) %% make sure rr is pointing to the parfiles you want (rr = 1, rr = 2)
    fid = fopen(params.parfile{rr}, 'r');
    while ~feof(fid)
        ln = fgetl(fid); cnt = cnt + 1;
        if isempty(ln); return; end; ln(ln == sprintf('\t')) = ' ';
        prts = deblank(strsplit(ln, ' ')); prts(cellfun(@isempty, prts)) = [];
        cond_nums(cnt) = str2double(prts{2});
        conds{cnt} = prts{3};
    end
    fclose(fid);
end
% make a list of unique condition numbers and corresponding condition names
cond_num_list = unique(cond_nums); cond_list = cell(1, length(cond_num_list));
for cc = 1:length(cond_num_list)
    cond_list{cc} = conds{find(cond_nums == cond_num_list(cc), 1)};
end

% Count how many times each unique condition number appears
[cond_num_counts] = histcounts(cond_nums, 'BinMethod', 'integers');

% Open a text file to save the results
output_filename = 'condition_counts.txt';
fid = fopen(output_filename, 'w');  % Open file for writing ('w' mode)
if fid == -1
    error('Error opening file: %s', output_filename);
end
fprintf(fid, 'Condition | Count\n');
fprintf(fid, '---------------------------------\n');
for i = 1:length(cond_num_list)
    fprintf(fid, '%s appears %d times\n', cond_list{i}, cond_num_counts(i));
end
fclose(fid);
fprintf('Tallying has been saved to %s\n', output_filename);
