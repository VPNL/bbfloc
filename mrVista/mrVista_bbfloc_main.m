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

%% subrun gen
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

%% Copy standard view settings so we can generate montages 
copyfile(fullfile(oak_prefix, 'mesh', 'left', 'MeshSettings.mat'), fullfile(session_path, '3DAnatomy', 'Left', '3DMeshes', 'MeshSettings.mat'));
copyfile(fullfile(oak_prefix, 'mesh', 'right', 'MeshSettings.mat'), fullfile(session_path, '3DAnatomy', 'Right', '3DMeshes', 'MeshSettings.mat'));
copyfile(fullfile(oak_prefix, 'mesh', 'Gray', 'userPrefs.mat'), fullfile(session_path, 'Gray', 'userPrefs.mat'));
addpath(genpath('/oak/stanford/groups/kalanit/biac2/kgs/projects/BBfloc/code/functions/mrVista_visualization_scripts'))

%% let's take some pics
% FIRST make sure you have the views saved, otherwise visualizations will
% NOT be generated! 
load session_setup.mat
hemi_list = [1, 2]; %lh, rh
views = [1]; %lateral, ventral
cats = [1]%  % 1=visual 2 = faces, 3 = limbs, 4 = objects, 5 = scenes,

for view = 1:length(views)  % Assuming views only has 2 options
    for hemi =1:length(hemi_list)
        % Define hemisphere and view settings for visualization
        if hemi == 1
            inputz.hemisphere = 'rh';
            inputz.meshname = 'Right_inflated.mat';
            angles = {'rh_medial'}; %'rh_lateral', 'rh_ventral' %'rh_medial', 
            inputz.meshAngle = angles{view}; % choose based on current view
            %inputz.rois = {'rh_V1_4mm_disk_CT.mat', 'rh_mFus_4mm_disk_CT.mat','rh_pFus_4mm_disk_CT.mat', 'rh_PPA_4mm_disk_CT.mat'};
       
        else
            inputz.hemisphere = 'lh';
            inputz.meshname = 'Left_inflated.mat';
            angles = {'lh_medial'}; %'lh_medial',
            inputz.meshAngle = angles{view}; % choose based on current view
            %inputz.rois = {'lh_V1_4mm_disk_CT.mat', 'lh_mFus_4mm_disk_CT.mat','lh_pFus_4mm_disk_CT.mat', 'lh_PPA_4mm_disk_CT.mat'};
       
        end
        inputz.roiFlag = 0 %1 %0: if no ROIS; 1: if ROIs 
        inputz.outputDir = fullfile(session_path, 'Images/mrVistaMontages');
        inputz.scan = 1;%GLM default is 1
        inputz.colorMap = 1
        
        for cat_val = 1:length(cats)
            cat = cats(cat_val)
            bbfloc_setUpMontages
            clear L
            L.ambient = [0.4 0.4 0.4];
            L.diffuse = [0.3 0.3 0.3];
            if cat == 1
                inputz.montageNameExt = 'vis_vs_blank_contrasts'; % name montage output
                inputz.maps = {'Visual_vs_blank.mat', ...
                    'allStatic_vs_blank.mat', ...
                    'allDynamic_vs_blank.mat'
                    };
                inputz.nrows = 1;%2
                inputz.ncols = 1;%3
                bbfloc_meshImages_Montage(inputz, setup, L)
            elseif cat == 2 
                inputz.montageNameExt = 'face_contrasts';
                inputz.maps = {'faces_vs_all.mat', ...
                    'Faces-S_vs_allStatic.mat', ...
                    'Faces-S_vs_allNonFaces.mat', ...
                    'Faces-D_vs_allDynamic.mat', ...
                    'Faces-D_vs_allNonFaces.mat'
                    };
                inputz.nrows = 2;
                inputz.ncols = 3;
                bbfloc_meshImages_Montage(inputz, setup, L)
            elseif cat == 3 
                inputz.montageNameExt = 'limb_contrasts';
                inputz.maps = {'limbs_vs_all.mat', ...
                    'Limbs-S_vs_allStatic.mat', ...
                    'Limbs-S_vs_allNonLimbs.mat', ...
                    'Limbs-D_vs_allDynamic.mat', ...
                    'Limbs-D_vs_allNonLimbs.mat'
                    };
                inputz.nrows = 2;
                inputz.ncols = 3;
                bbfloc_meshImages_Montage(inputz, setup, L)
            elseif cat == 4
                inputz.montageNameExt = 'object_contrasts';
                inputz.maps = {'objects_vs_all.mat', ...
                    'Objects-S_vs_allStatic.mat', ...
                    'Objects-S_vs_allNonObjects.mat', ...
                    'Objects-D_vs_allDynamic.mat', ...
                    'Objects-D_vs_allNonObjects.mat'
                    };
                inputz.nrows = 2;
                inputz.ncols = 3;
                bbfloc_meshImages_Montage(inputz, setup, L)
            elseif cat == 5 
                inputz.montageNameExt = 'scene_contrasts';
                inputz.maps = {%'scenes_vs_all.mat', ...
                    %'Scenes-S_vs_allStatic.mat', ...
                    %'Scenes-S_vs_allNonScenes.mat', ...
                    'Scenes-D_vs_allDynamic.mat', ...
                    %'Scenes-D_vs_allNonScenes.mat'
                     };
                inputz.nrows = 2;
                inputz.ncols = 1; %3;
                bbfloc_meshImages_Montage(inputz, setup, L)
            end
        end
    end
end


%% %% let's take some pics
% FIRST make sure you have the views saved, otherwise visualizations will
% NOT be generated! 
load session_setup.mat
hemi_list = [1, 2]; %lh, rh
views = [1 2]; %lateral, ventral
cats = [1]; % 1=visual 2 = faces, hands, cars, 5 = scenes,

for view = 1:length(views)  % Assuming views only has 2 options
    for hemi = 1:length(hemi_list)
        % Define hemisphere and view settings for visualization
        if hemi == 1
            inputz.hemisphere = 'rh';
            inputz.meshname = 'Right_inflated.mat';
            angles = {'rh_lateral', 'rh_medial'}; %'rh_lateral', 'rh_ventral' %'rh_medial', 
            inputz.meshAngle = angles{view}; % choose based on current view
            inputz.rois = {'rh_V1_4mm_disk_CT.mat'};
       
        else
            inputz.hemisphere = 'lh';
            inputz.meshname = 'Left_inflated.mat';
            angles = {'lh_lateral', 'lh_medial'}; %'lh_medial',
            inputz.meshAngle = angles{view}; % choose based on current view
            inputz.rois = {'lh_V1_4mm_disk_CT.mat'};
       
        end
        inputz.roiFlag = 1 %0; %if no ROIS 
        inputz.outputDir = fullfile(session_path, 'Images/mrVistaMontages');
        inputz.scan = 1;
        
        for cat_val = 1:length(cats)
            cat = cats(cat_val)
            bbfloc_setUpMontages
            clear L
            L.ambient = [0.4 0.4 0.4];
            L.diffuse = [0.3 0.3 0.3];
            if cat == 1
                inputz.montageNameExt = 'Visual_vs_blank_contrasts'; % name montage output
                inputz.maps = {'Visual_vs_blank.mat', ...
                    'allStatic_vs_blank.mat', ...
                    'allDynamic_vs_blank.mat'
                    };
                inputz.nrows = 1;%2
                inputz.ncols = 3;%3
                bbfloc_meshImages_Montage(inputz, setup, L)
            elseif cat == 2 
                inputz.montageNameExt = 'face_contrasts';
                inputz.maps = {'faces_vs_all.mat', ...
                    'Faces-S_vs_allStatic.mat', ...
                    'Faces-S_vs_allNonFaces.mat', ...
                    'Faces-D_vs_allDynamic.mat', ...
                    'Faces-D_vs_allNonFaces.mat'
                    };
                inputz.nrows = 2;
                inputz.ncols = 3;
                bbfloc_meshImages_Montage(inputz, setup, L)
            elseif cat == 3 
                inputz.montageNameExt = 'limb_contrasts';
                inputz.maps = {'limbs_vs_all.mat', ...
                    'Limbs-S_vs_allStatic.mat', ...
                    'Limbs-S_vs_allNonLimbs.mat', ...
                    'Limbs-D_vs_allDynamic.mat', ...
                    'Limbs-D_vs_allNonLimbs.mat'
                    };
                inputz.nrows = 2;
                inputz.ncols = 3;
                bbfloc_meshImages_Montage(inputz, setup, L)
            elseif cat == 4
                inputz.montageNameExt = 'object_contrasts';
                inputz.maps = {'objects_vs_all.mat', ...
                    'Objects-S_vs_allStatic.mat', ...
                    'Objects-S_vs_allNonObjects.mat', ...
                    'Objects-D_vs_allDynamic.mat', ...
                    'Objects-D_vs_allNonObjects.mat'
                    };
                inputz.nrows = 2;
                inputz.ncols = 3;
                bbfloc_meshImages_Montage(inputz, setup, L)
            elseif cat == 5 
                inputz.montageNameExt = 'scene_contrasts';
                inputz.maps = {'scenes_vs_all.mat', ...
                    'Scenes-S_vs_allStatic.mat', ...
                    'Scenes-S_vs_allNonScenes.mat', ...
                    'Scenes-D_vs_allDynamic.mat', ...
                    'Scenes-D_vs_allNonScenes.mat'
                     };
                inputz.nrows = 2;
                inputz.ncols = 3;
                bbfloc_meshImages_Montage(inputz, setup, L)
            end
        end
    end
end
%
%%
% load session_setup.mat
% 
% hemi_list = [1, 2]; % 1 = rh, 2 = lh
% views = {'lateral', 'medial', 'ventral'}; % all 3 views
% cats = [1, 2, 3, 4, 5]; % faces, hands, cars, scenes, visual
% 
% view_angles = struct( ...
%     'rh', {{'rh_lateral', 'rh_medial', 'rh_ventral'}}, ...
%     'lh', {{'lh_lateral', 'lh_medial', 'lh_ventral'}} ...
% );
% 
% inputz.scan = 2;
% 
% for hemi = 1:length(hemi_list)
%     % Hemisphere setup
%     if hemi_list(hemi) == 1
%         inputz.hemisphere = 'rh';
%         inputz.meshname = 'Right_inflated.mat';
%     else
%         inputz.hemisphere = 'lh';
%         inputz.meshname = 'Left_inflated.mat';
%     end
% 
%     inputz.roiFlag = 0;
%     inputz.outputDir = fullfile(session_path, 'Images/mrVistaMontages');
% 
%     for cat = 1:length(cats)
%         % Setup lighting
%         bbfloc_setUpMontages
%         clear L
%         L.ambient = [0.4 0.4 0.4];
%         L.diffuse = [0.3 0.3 0.3];
% 
%         % Define map and name per category
%         switch cat
%             case 1
%                 inputz.montageNameExt = 'vis_vs_blank_contrasts';
%                 inputz.maps = {'Visual_vs_blank.mat'};
%             case 2
%                 inputz.montageNameExt = 'face_contrasts';
%                 inputz.maps = {'faces_vs_all.mat'};
%             case 3
%                 inputz.montageNameExt = 'limb_contrasts';
%                 inputz.maps = {'limbs_vs_all.mat'};
%             case 4
%                 inputz.montageNameExt = 'object_contrasts';
%                 inputz.maps = {'objects_vs_all.mat'};
%             case 5
%                 inputz.montageNameExt = 'scene_contrasts';
%                 inputz.maps = {'scenes_vs_all.mat'};
%         end
% 
%         % Set up montage layout for 3 views
%         inputz.nrows = 1;
%         inputz.ncols = 3;
% 
%         % Optionally, combine the 3 view images into a single image using external tool (e.g., montage, ImageMagick)
%         % This step is outside of MATLAB unless bbfloc_meshImages_Montage can do the combining.
%         bbfloc_meshImages_Montage_view(inputz, setup, L, view_angles)
%     end
% end
