%% bbfloc_runGLM and generate main contrast maps for fLOC

% open logfile to track progress of analysis
if ~exist(logFileName, 'file')
     lid = fopen(logFileName, 'w+');
else
     lid = fopen(logFileName, 'a');
end

%% Use this code if all runs are good; have no significant motion!) 
disp('=========== Starting combined GLM ===========');

% load the analysis params set in the bbfloc_initializeSession
load bbfloc_AnalysisParams.mat

newscangroup = [1, 2, 3]; % set runs to include
hg = initHiddenGray('MotionComp_RefScan1'); 
hg = er_groupScans(hg, newscangroup);
hg = applyGlm(hg, 'MotionComp_RefScan1', newscangroup, glm_params);
