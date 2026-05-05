%% Turns aseg generated into a ribbon.nii.gz compatible w/ mrVista to generate a class file

%function [] = reslice_nifti_to_ribbon(subID, session, scan)

addpath(genpath('/share/kalanit/software/vistasoft/'));

% Subject and session setup
folder = '3DAnatomy';

segmentationfilepath = ['/oak/stanford/groups/kalanit/biac2/kgs/projects/BBfloc/data/', subID, '/', session,  '/', folder];
segmentationfilename = 't1_class_gray_ventricle.nii.gz';


cd(segmentationfilepath);

% Check if the file exists
if ~exist(segmentationfilename, 'file')
    error('The specified file does not exist.');
end

% Read the segmentation NIfTI file
segmentation_data = readFileNifti(segmentationfilename);
data = segmentation_data.data;

% Replace specified values
% % Replace specified values
% data(data == 4) = 41; % Change 4 to 41
% data(data == 2) = 42; % Change 2 to 42
% data(data == 5) = 2;  % Change 5 to 2
data(ismember(data, [43, 44, 49, 50, 51, 52, 53, 54, 58, 60])) = 41;
data(ismember(data, [4, 5, 10, 11, 12, 13, 17, 18, 26, 28])) = 2;



% Replace specified values
data(data ~= 41 & data ~= 42 & data ~= 2 & data ~= 3 & data ~= 1) = 0;  % Replace all other values with 0

% Update the NIfTI structure with modified data
segmentation_data.data = data;

% Save the modified segmentation file
modified_segmentation_filename = 'ribbon.nii.gz';
niftiWrite(segmentation_data, modified_segmentation_filename);

% Convert the NIfTI to MGZ
mgz_filename = strrep(modified_segmentation_filename, '.nii.gz', '.mgz');
cmd = ['mri_convert ' modified_segmentation_filename ' ' mgz_filename];
unix(cmd);  % This will convert NIfTI to MGZ

% Display success message
disp(['Modified segmentation saved as ', modified_segmentation_filename]);

% Check if the commands were successful
if status1 == 0
    disp('Fullcloud file copied successfully.');
else
    disp('Error copying fullcloud file.');
end

if status2 == 0
    disp('Modified ventricle class file copied successfully.');
else
    disp('Error copying modified ventricle class file.');
end



