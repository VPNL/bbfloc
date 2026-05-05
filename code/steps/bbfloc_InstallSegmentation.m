% bbfloc_InstallSegmentation.m
%
%
% Convert the FS ribbon.mgz to a nifti class file (which is used by mrVista
% to create 3D meshes)


lid = fopen(logFileName, 'a');
fprintf(lid, 'Starting Install segementation %s. \n\n', session_path);
disp('=========== Starting Install FreeSurfer Segmentation  ===========');
cd(session_path)

% Convert the FS ribbon.mgz to a nifti class file (which is used by mrVista
% to create 3D meshes)

fsRibbonFile  = fullfile('./3DAnatomy/mri/ribbon.mgz');  % Full path to the ribbon.mgz file, or it can be name of directory in freesurfer subject directory (string). 
outfile       = fullfile('./3DAnatomy/mri/t1_class.nii.gz');
fillWithCSF   = true;

T1.nii = vANATOMYPATH;
saveSession
alignTo= T1.nii;

resample_type = [];


fs_ribbon2itk(fsRibbonFile, outfile, fillWithCSF, alignTo, resample_type) % this function runs only on linux machines needs to use FreeSurfer commands
fprintf(lid, '%s : FS ribbon file converted to class file. \n\n', char(datetime('now')));


% make sure the class file is ready to go for alignment in the 3DAnatomy/t1_class_grayventricle.nii.gz
% Update log file
cd(session_path)

%% If subje has fsRecon folder 
% Create and save freesurfer meshes
hemi = 'b';
surfaces = {'white' 'pial' 'sphere' 'inflated'};
%load session_setup.mat
subjid=setup.fsReconPath;
% this will generate in the freesurfer recon directory subjid=setup.fsReconPath
% two directories: Left and Right and each one will have a subdirectory
% called 3Dmeshes with 4 meshes:'white' 'pial' 'sphere' 'inflated'

[meshes, fnames] = meshImportFreesurferSurfaces(subjid, hemi, surfaces);
% Inputs:
%   subjid: Either the subjid recognized by freesurfer, or the path to the
%               freesurfer subject directory.
%   hemi:   'l', 'r', or 'b' (left, right, or both). [Default = 'b']
%   surfaces: cell array with one or more of 'white', 'pial', 'sphere',
%               'inflated'
%                [Default = {'white' 'pial' 'sphere' 'inflated'};]

[meshes, fnames] = meshImportFreesurferSurfaces(subjid, hemi, surfaces);

%% Visualize 
%  %
%  % before visualizing the meshes you need to initialize mrMeshSrv.exe
%  % using wine for Ubuntu 20 and higher or macOS
%  %
%  % wine /vistasoftpath/mrMesh/meshserver/mrMeshSrv.exe 
%  % e.g. on our linux machines:
%  % wine /share/kalanit/software/vistasoft/mrMesh/meshserver/mrMeshSrv.exe 
%  % 
% 
% % View the 4 left meshes: white, pial, inflated, sphere
% 
% for ii = 1:4
%     meshVisualize(meshes(ii)) 
%     % Ymou can rotate, zoom, and translate with
%     % the appropriate mouse actions. We BELIEVE that the mouse buttons are as
%     % follows:
%     %   Rotation:  left mouse button plus movement
%     %   Zoom:      right mouse button plus up/down movement
%     %   Translate: left and right together plus movement
% 
% end
% 
% disp('=========== Install Segmentation Done ===========');
% fclose (lid)
