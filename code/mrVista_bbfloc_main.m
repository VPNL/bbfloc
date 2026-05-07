%% mrVista_bbfloc_main
%% analysis pipeline for bbFloc 
%
% CT/KGS April 2025

%% before set up make sure the baby has a mrVista (BBfloc/data/bbXX/mriYY) session folder containing:

% 1. functional folder
% 2. Inplane folder
% 3. parfiles folder 
% 4. runfile folder
% Subj session directory must contain the following files:
% 1) An inplane nifti that contains 'Inplane' in the file name and ends in
%    nii.gz inside a folder titled 'Inplane'
% 2) Functional niftis ending in runX.nii.gz where X is the corresponding
%    run number inside a folder titled 'functionals'
% 3) Parfiles ending in runX.par where X is the corresponding run number
%    inside a folder titled 'parfiles'


%% Set session, experiment, coded dir and basic info for the example subject
% Change these inputs 
subID = 'bb108'; 
session = 'mri5_new'; %mrSession'

oak_prefix = '/oak/stanford/groups/kalanit/biac2/kgs/projects/BBfloc/';
session_path = fullfile(oak_prefix, 'data', subID, session);
cd(session_path)

addpath(genpath('/oak/stanford/groups/kalanit/biac2/kgs/projects/BBfloc/code/steps'));
addpath(genpath('/oak/stanford/groups/kalanit/biac2/kgs/projects/BBfloc/code/functions'));

%% open logfile to track progress of analysis
logFileName = fullfile('./bbflocAnalysis_log.txt');
if ~exist(logFileName, 'file')
 lid = fopen(logFileName, 'w+');
else
 lid = fopen(logFileName, 'a');
end

%% SECTION 1: Set-up directories and vAnatomy path 
% NOTE: if subject doesn't have fsrecon folder make sure their babybrains folder(kgs/projects/babybrains/mri/.../preprocessed_aligned/) contains a subfolder called 3DAnatomy
% containing anatomical1 (T1w_0.8mm_nii.gz, T2w_0.8mm_nii.gz) and a class file 
bbfloc_initalizeDirs(session_path, subID, session, exp_version)

%% SECTION 2: Initialize session and Analysis Parameters
clip = [0]; 
bbfloc_initalizeSession

%% SECTION 3: Motion3 correction
% Within-scan & between scan motion correction
bbfloc_motionCorrection

%% subrun gen (ONLY RUN ON ORIG FILES)
subrungeneration_mit_updated 


%% SECTION 4:  RUN GLM and generate main contrast maps for fLOC
% Use this code if all runs are good; have no significant motion!) 
bbfloc_runGLM

%% Section 4.5: Compute contrast maps 
GLM = 1; %input the GLM you want to compute contrast amps for 

bbfloc_computeContrastMaps_v5(GLM)


fprintf(lid, '%s: completed generating contrast maps \n\n', char(datetime('now')));
disp('=========== Contrasts computations - Done! ===========');

%% Section 5: Align session to whole brain anatomy 
vANATOMYPATH = fullfile(session_path, '/3DAnatomy/T1.nii.gz');
disp('=========== Set vAnatomyPath ===========');
%saveSession
save('vANATOMYPATH.mat', 'vANATOMYPATH');
rxAlign


%bbfloc_aligntoVolume
% alignment bestrotvol.mat is generated

%% SECTION 5.5 
% %TODO 4 Seda and Cristina
% steps leading to segmentation (acpc alignment, mgz file gen, recon_all) 
% ADD: how to manually correct in itkgray add it to the tutorial 

%% SECTION 6: Install FreeSurfer Segmentation & meshes into mrVista SKIP THIS IF subject already has a session

%%if baby doesn't have FSrecon 
%reslice_nifti_to_ribbon



bbfloc_InstallSegmentation
%% SECTION 7: Transform contrast maps and time series from inplane to gray view
bbfloc_Xform

%% Update the log file for documentation
lid = fopen(logFileName, 'a');
fprintf(lid,['---------------------------------------------------','\n\n']);
fprintf(lid,['MATLAB version ',version,'\n\n']);
load mrSESSION.mat
fprintf(lid,['mrVista Version ',mrSESSION.mrVistaVersion,'\n\n']);

% add all parameters used to logfile
fprintf(lid,['---------------------------------------------------','\n\n']);
load mrInit_params.mat
% initialization params
fprintf(lid,['Initialization parameters used\n\n',evalc('disp(params)')]);
fprintf(lid,['including: functionals\n\n',evalc('disp(params.functionals(:))')]);
fprintf(lid,['keepFrames\n\n',evalc('disp(params.keepFrames)')]);
fprintf(lid,['parfiles\n\n',evalc('disp(params.parfile(:))')]);
fprintf(lid,['---------------------------------------------------','\n\n']);
% scan params
for l = 1:length(dataTYPES(1).scanParams)
    fprintf(lid,['Original data type scan ',num2str(l),' params:\n\n',l,evalc( 'disp(dataTYPES(1).scanParams(l))' )]);
end
fprintf(lid,['GLM data type scan params:\n\n',evalc('disp(dataTYPES(4).scanParams)')]);
fprintf(lid,['---------------------------------------------------','\n\n']);
% GLM params
fprintf(lid,['Event analysis parameters used\n\n',evalc('disp(dataTYPES(length(dataTYPES)).eventAnalysisParams)')]);
disp('=========== Finished initializing vistasoft session completed ===========');
fclose(lid)
disp('=========== Transfrom contrast maps to gray Done ===========');

%% 4) this is the end of the mrvista protocol. Now you can visualize the maps in GRAY view and continue to draw ROIs %% 
%% you can run additional master_MRVISTA_to_FS_setup_protocol.m to visualize the parameter maps on the FSrecon surface
mrVista 3

