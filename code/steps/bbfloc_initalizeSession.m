%% bbfloc_initializeSession

% Outputs:
% 1) mrSession.m
% 2) Within-scan and between-scan motion correction
% 3) Alignment
% 4) GLMs based on parfiles
% 5) installed segmentation

%% 1) Set subject session information based on the clip, and QA inputs

QA = false; 
cd(session_path)
load session_setup.mat

logFileName = 'bbflocAnalysis_log.txt';

% open logfile for tracking progress 
if ~exist(logFileName, 'file')
     lid = fopen(logFileName, 'w+');
else
     lid = fopen(logFileName, 'a');
end

%% 2) set init_params and GLM parameters
[~, init_params, dglm_params] = bbfloc_AnalysisParams(session_path, clip, setup);

glm_params = dglm_params;

% save init_params and glm_params
save bbfloc_AnalysisParams.mat init_params glm_params
save session_setup.mat  subID  session  session_path  setup

%% 3) read Nifti files and initialize session with mrInit
% Read nifti files
nii = readFileNifti(init_params.functionals{1}); 
nslices = size(nii.data, 3);

% Initialize vistasoft session and open hidden inplane view
fprintf(lid, 'Initializing vistasoft session directory in: \n%s \n\n', session_path);
fprintf('Initializing vistasoft session directory in: \n%s \n\n', session_path);
setpref('VISTA', 'verbose', false); % suppress wait bar

mrsession_path = fullfile(session_path, 'mrSESSION.mat');
mrInit(init_params); % saves mrSESSION.mat under session's folder


%% Close analysis tracking log file
fprintf(lid, ' \n');
fprintf(lid, '%s : Finished initializing vistasoft session. \n\n', char(datetime('now')));
disp('=========== Finished initializing vistasoft session completed ===========');
% close log file
fclose(lid);