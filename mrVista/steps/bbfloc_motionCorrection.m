%% bbfloc_motionCorrection

% open logfile to track progress of analysis
if ~exist(logFileName, 'file')
     lid = fopen(logFileName, 'w+');
else
     lid = fopen(logFileName, 'a');
end
fprintf(lid, 'Starting within-scan motion correction for session %s. \n\n', session_path);
fprintf('Starting within-scan motion correction for session %s. \n\n', session_path);
disp('=========== Starting Motion Correction  ===========');

%% Within Scan motion correction

hi = initHiddenInplane('Original', 1);
disp('=========== Initializing Hidden Inplane Done ===========');

setpref('VISTA', 'verbose', false); % suppress wait bar
if exist(fullfile(session_path, 'Images', 'Within_Scan_Motion_Est.fig'), 'file') ~= 2
    hi = motionCompSelScan(hi, 'MotionComp', 1:length(init_params.functionals), ...
        6, init_params.motionCompSmoothFrames);
    saveSession; close all;
end

%%
% check to see if there is too much motion
fig = openfig(fullfile('Images', 'Within_Scan_Motion_Est.fig'), 'invisible');
L = get(get(fig, 'Children'), 'Children');
if QA
    for rr = 1:length(init_params.functionals)
        motion_est = L{rr + 1}.YData;
        if max(motion_est(:)) > 2
            fprintf(lid, 'Warning -- Within-scan motion exceeds 2 voxels. \n');
            fprintf('Warning -- Within-scan motion exceeds 2 voxels. \n');
            fprintf(lid,'Exited analysis'); 
            fprintf('Exited analysis');
            ffclose(lid); 
            return; 
        end
        fprintf(lid,'QA checks passed for run %i. ',rr);
        fprintf('QA checks passed for run %i. ',rr);
    end
end


fprintf(lid, '%s :Within-scan motion compensation complete. \n\n', char(datetime('now')));
fprintf('Within-scan motion compensation complete. \n\n');

%% Between-scan motion correction
% group motion compensation scans

fprintf(lid, 'Starting between-scan motion correction for session %s. \n\n', session_path);
fprintf('Starting between-scan motion correction for session %s. \n\n', session_path);

hi = initHiddenInplane('MotionComp', init_params.scanGroups{1}(1));
hi = er_groupScans(hi, init_params.scanGroups{1});

% run between-scan motion compensation
if exist(fullfile(session_path, 'Between_Scan_Motion.txt'), 'file') ~= 2
    hi = initHiddenInplane('MotionComp', 1);
    baseScan = 1; targetScans = 1:length(init_params.functionals);
    [hi, M] = betweenScanMotComp(hi, 'MotionComp_RefScan1', baseScan, targetScans);
    fname = fullfile('Inplane', 'MotionComp_RefScan1', 'ScanMotionCompParams');
    save(fname, 'M', 'baseScan', 'targetScans');
    hi = selectDataType(hi, 'MotionComp_RefScan1');
    saveSession; close all;
end

% calculate between-scan motion
fid = fopen(fullfile('Between_Scan_Motion.txt'), 'r');
motion_est = zeros(length(init_params.functionals) - 1, 3);
for rr = 1:length(init_params.functionals) - 1
    ln = strsplit(fgetl(fid), ' ');
    motion_est(rr, 1) = str2double(ln{8});
    motion_est(rr, 2) = str2double(ln{11});
    motion_est(rr, 3) = str2double(ln{14});
end
fclose(fid);

% check to see if there is too much motion
if QA
    if max(motion_est(:)) > 2
        fprintf(lid, 'Warning -- Between-scan motion exceeds 2 voxels. \nExited analysis.');
        fprintf('Warning -- Between-scan motion exceeds 2 voxels. \nExited analysis.');
    	fclose(lid); return; 
    else
        fprintf(lid,'QA checks passed. \n\n');
        fprintf('QA checks passed. \n\n');
    end
end

fprintf(lid, '%s :Between-scan motion compensation complete. \n\n', char(datetime('now')));
fprintf('Between-scan motion compensation complete.\n\n');
fclose(lid)
disp('=========== Motion Correction Done ===========');
