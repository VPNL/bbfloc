function []=wrapper_mrVistaROI2niftiROI_discs_babies()
%% this code converts the mrvista disc rois in to the freeSurfer nifti
addpath('/share/kalanit/biac2/kgs/projects/CBA/Code/niftiCode/')
Vistasessions ={'bb98_mri4', 'bb108_mri5', 'bb110_mri6', 'bb119_mri6', 'bb125_mri6', 'bb130_mri5', 'bb124_mri4'}


baby ={'bb98', 'bb108', 'bb110', 'bb119', 'bb125', 'bb130', 'bb124'};
sess = {'mri4', 'mri5', 'mri6', 'mri5', 'mri4', 'mri5', 'mri4'};
anatomies = {'T1.nii.gz', 'T2.nii.gz', 'T1.nii.gz', 'T1.nii.gz', 'T1.nii.gz','T1.nii.gz', 'T1.nii.gz'}; %{} %fix
mrVistaDir='/share/kalanit/biac2/kgs/projects/bb2adult/data/babies/';
anatdir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/babybrains/mri';
%% for the babies

for i = 1:length(Vistasessions)
    roiDir = [mrVistaDir, Vistasessions{i}, '/3DAnatomy/ROIs/'];
    matFiles = dir(fullfile(roiDir, '*mat'));

    if isempty(matFiles) 
	    fprintf('No .mat files found for %s, skipping.\n', Vistasessions{i}); 
	    continue 
    end 

    for r=1:length(matFiles) roiName = {matFiles(r).name};
	     fprintf('Converting %s for subject %s\n', roiName{1},Vistasessions{i}); 
	     mrVistaROI2niftiROI([mrVistaDir, Vistasessions{i}], roiName, anatomies{i}, '3DAnatomy', roiDir);
    end 
end

for i = 1:length(Vistasessions) 
	roiDir = [mrVistaDir, Vistasessions{i},'/3DAnatomy/ROIs/']; 
	% Find all .nii.gz ROI files 
	niiFiles = dir(fullfile(roiDir, '*.nii.gz'));
	if isempty(niiFiles) 
		fprintf('No .nii.gz files found for %s, skipping.\n', Vistasessions{i}); 
		continue 
	end 
	cd(roiDir); 
	for r = 1:length(niiFiles) 
		niiName =niiFiles(r).name;
		refVol  = [anatdir, '/', baby{i}, '/', sess{i}, '/preprocessed_aligned/MRF/T1map_aligned_1mm.nii.gz']; 
		if isfile(niiName) && isfile(refVol) 
            command = ['mri_convert ', niiName, ' ', niiName, ' -rl ', refVol]; 
		    fprintf('Running: %s\n',command);
		    unix(command); 
        else 
            fprintf('Skipping %s — file or reference volume not found.\n', niiName); 
		end
 	end
end 
