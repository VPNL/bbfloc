
% --- STEP 1: FIND SPLIT POINTS WHERE MOTION > 2 degrees OR 2 mm ---
for rr = 1:length(init_params.functionals)
    motion = dataTYPES(2).scanParams(rr).WithinScanMotion;
    nvols = size(motion, 2);
    
    total_motion = sqrt(sum(motion(1:2, :).^2));
    total_diff = abs(diff(total_motion));
    
    % Find where motion exceeds 2 mm OR 2 degrees between consecutive timepoints
    high_motion_points = total_diff > .84;
    
    % Split points are where high motion occurs
    split_points = find(high_motion_points);
    
    % Create subrun boundaries
    starts = [1, split_points + 1];
    ends = [split_points, nvols];
    
    fprintf('Run %d: found %d split points, creating %d potential subruns\n', rr, length(split_points), length(starts));
    
    % --- STEP 2: SCRUB VOLUMES WITH > 1 mm degrees OR mm motion within each subrun ---
    for i = 1:length(starts)
        % Get volumes for this subrun
        subrun_vols = starts(i):ends(i);
        
        % Calculate motion within this subrun
        subrun_total_motion = total_motion(subrun_vols);
        
        % Find volumes to scrub (> 1 mm motion between consecutive volumes within subrun)
        if length(subrun_vols) > 1
            subrun_total_diff = abs(diff(subrun_total_motion));
           
            % Volumes to scrub within this subrun
            scrub_within_subrun = subrun_total_diff > 0.4;
            
            % Mark both volumes in high-motion pairs for scrubbing
            volumes_to_scrub = false(1, length(subrun_vols));
            volumes_to_scrub(1:end-1) = volumes_to_scrub(1:end-1) | scrub_within_subrun;  % earlier vol
            volumes_to_scrub(2:end) = volumes_to_scrub(2:end) | scrub_within_subrun;      % later vol
            
            % Keep only good volumes
            good_vols_mask = ~volumes_to_scrub;
            good_subrun_vols = subrun_vols(good_vols_mask);
        else
            good_subrun_vols = subrun_vols; % single volume, keep it
        end
        
        runLength = length(good_subrun_vols);
        
        % Must have at least 24 consecutive low-motion volumes
        if runLength < 20
            fprintf('Run %d subrun %d: too short after scrubbing (%d vols), skipping\n', rr, i, runLength);
            continue;
        end
        
        % --- STEP 3: CREATE SUBRUN FILES ---
        nifti_file = fullfile(session_path, 'functionals', ['run' num2str(rr) '.nii.gz']);
        niftiStruct = readFileNifti(nifti_file);
        niftiData = niftiStruct.data;
        
        runStart_keep = good_subrun_vols(1);
        runEnd_keep = good_subrun_vols(end);
        
        fprintf('Run %d subrun %d: TRs %d to %d (%d vols after scrubbing)\n', rr, i, runStart_keep, runEnd_keep, runLength);
        
        % Extract only the good volumes
        niftiData_clipped = niftiData(:, :, :, good_subrun_vols);
        
        % Update paradigm files
        run_name = ['run' num2str(rr) '_subrun_TR' num2str(runStart_keep) 'to' num2str(runEnd_keep) '.par'];
        TR = 2;  % set your TR in seconds
        blah(rr, good_subrun_vols, session_path, run_name, TR);
        
        % Save new NIfTI file for this subrun
        out_file = fullfile(session_path, 'functionals', ...
            ['run' num2str(rr) '_subrun_TR' num2str(runStart_keep) 'to' num2str(runEnd_keep) '.nii.gz']);
        niftiStruct_out = niftiStruct;
        niftiStruct_out.data = niftiData_clipped;
        niftiStruct_out.dim = size(niftiData_clipped);
        niftiStruct_out.fname = out_file;
        writeFileNifti(niftiStruct_out);
        
        disp(['Subrun ' num2str(i) ': saved ' num2str(runLength) ' volumes to ' out_file]);
    end
end
