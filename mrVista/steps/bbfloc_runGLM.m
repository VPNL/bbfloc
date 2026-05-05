%% bbfloc_runGLM and generate main contrast maps for fLOC

% open logfile to track progress of analysis
if ~exist(logFileName, 'file')
     lid = fopen(logFileName, 'w+');
else
     lid = fopen(logFileName, 'a');
end

%% Use this code if all runs are good; have no significant motion!) 
disp('=========== Starting GLM ===========');

% load the analysis params set in the bbfloc_initializeSession
load bbfloc_AnalysisParams.mat

fprintf(lid, 'Performing GLM analysis for %s... \n\n', session_path);
fprintf('Performing GLM analysis for %s... \n\n', session_path);
hi = initHiddenInplane('MotionComp_RefScan1', init_params.scanGroups{1}(1));
hi = applyGlm(hi, 'MotionComp_RefScan1', init_params.scanGroups{1}, glm_params);

% %fprintf(lid, '%s : GLM completed \n\n', char(datetime('now')));
% disp('=========== Run GLM Done ===========');
% % 
% % % % % % % % %% Use this code if you want to exclude runs with too much motion
fprintf(lid, 'Performing GLM analysis for %s... \n\n', session_path);

% Reset again after er_groupScans in case it overwrote
for s = 1:3
    dataTYPES(3).scanParams(s).keepFrames = [0 -1];
end
saveSession;

hi = initHiddenInplane('MotionComp_RefScan1', init_params.scanGroups{1}(1)); 
newscangroup = [1 2 3]; % set runs to include
hi = er_groupScans(hi, newscangroup);
hi = applyGlm(hi, 'MotionComp_RefScan1', newscangroup, glm_params);
fprintf('Performing GLM analysis for %s... \n\n', session_path);

% hi = initHiddenInplane('MotionComp_RefScan1', init_params.scanGroups{1}(1)); 
% %in future change to ('MotionComp_RefScan1', 2)
% hi = er_groupScans(hi, newscangroup);
% hi = applyGlm(hi, 'MotionComp_RefScan1', newscangroup, glm_params);
% % 
% % run glm on gaussian blurred t-series
% fprintf(lid, 'Performing GLM analysis for %s... \n\n', session_path);
% fprintf('Performing GLM analysis for %s... \n\n', session_path);
%  hi = initHiddenInplane('Blurred5mm', init_params.scanGroups{1}(1));
% hi = applyGlm(hi, 'Blurred5mm', init_params.scanGroups{1}, glm_params);
% % 
fprintf(lid, '%s : GLM completed \n\n', char(datetime('now')));
disp('=========== Run GLM Done ===========');