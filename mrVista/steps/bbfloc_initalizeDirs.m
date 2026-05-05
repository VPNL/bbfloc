function bbfloc_initalizeDirs(session_path, subID, session, exp_version)

%% open logfile to track progress of analysis
logFileName = fullfile('./bbflocAnalysis_log.txt');
if ~exist(logFileName, 'file')
 lid = fopen(logFileName, 'w+');
else
 lid = fopen(logFileName, 'a');
end

%% Save set-up variables
setup.vistaDir = fullfile('/oak/stanford/groups/kalanit/biac2/kgs/projects/BBfloc/data'); % experiment folder
setup.subID = subID;
setup.sessionID = session;
setup.expSessionName = exp_version; 

setpref('VISTA', 'verbose', false); % suppress wait bar
fprintf(lid, '%s : ------ initialize dir  ------ \n', char(datetime('now')));

%% set vAnatomy and make '3DAnatomy' shortcut - steps vary depending on if subject has fs_reconfolder or not
prompt = 'Does subject have an fsrecon folder? Press 1 for yes, press 2 for no but has 3DAnatomy, press 3 for no anatomicals: ';
has_recon_folder = input(prompt);
anatDir = fullfile(session_path, '3DAnatomy');
 if has_recon_folder == 1

    % Set fs recon folder name for subject
    fs_session = input('Enter the fs_session name: ', 's');
    setup.fsDir = fullfile('/oak/stanford/groups/kalanit/biac2/kgs/anatomy/freesurferRecon/babybrains'); % fs recon dir for babies
    setup.fsSession = fs_session;
    setup.fsReconPath = fullfile(setup.fsDir, setup.fsSession);
    
    % Get subject's FreeSurfer recon path 
    cd(setup.fsReconPath)
    
    % Path to T1.mgz file created by FreeSurfer
    T1.mgz = sprintf('./mri/T1.mgz');

    % Path to t1.nii.gz to be output by conversion
    T1.nii = sprintf('./t1.nii.gz');

    % Convert FS recon t1.mgz to nifti format (using nearest neighbor).
    % This function cannot overwrite any existing files, so if there is an
    % existing file, it will ask the user what to do. 
    if exist(T1.nii, 'file')
        prompt = 'This T1.nii file already exists. Are you sure you want to overwrite it? Press 1 for yes, 2 for no: ';
        x = input(prompt);
        if x == 1
            delete './t1.nii.gz'
            str = sprintf('mri_convert --resample_type nearest --out_orientation RAS -i %s -o %s', T1.mgz, T1.nii);
            system(str)
        end
    else
        str = sprintf('mri_convert --resample_type nearest --out_orientation RAS -i %s -o %s', T1.mgz, T1.nii);
        system(str)
    end

    cd(session_path);

    % create a shortcut to fsReconfolder called '3DAnatomy' 
    cd(session_path)
    cmd = ['ln -s ' setup.fsReconPath ' 3DAnatomy'];
    system(cmd)


    fprintf(lid, '%s : 3DAnatomy softlink set. \n\n', char(datetime('now')));
    fprintf(lid, '%s : Softlink folder path: %s \n\n', char(datetime('now')), setup.fsReconPath);
    disp('=========== 3DAnatomy softlink set. ===========');
    

 elseif has_recon_folder == 2
    anat_session = split(session, '_');
    anat_session = anat_session{1}; 

    % Make 3DAnatomy folder softlink
    anat_dir = fullfile(session_path, '3DAnatomy');
    anat_orig_path = fullfile('/oak/stanford/groups/kalanit/biac2/kgs/projects/babybrains/mri/', subID, anat_session, '/preprocessed_aligned/', 'BIBSnet');
    if ~exist(anat_dir,'dir')
        cd(session_path)
        cmd = ['ln -s '  anat_orig_path ' 3DAnatomy'];
        system(cmd)
    else
        disp('3DAnatomy folder already exists.')
    end
    
    fprintf(lid, '%s : 3DAnatomy softlink set. \n\n');
    fprintf(lid, '%s : Softlink folder path: %s \n\n');
    disp('=========== 3DAnatomy softlink set. ===========');
  

 else
 end
    
%% save setup
save session_setup.mat setup  
fprintf(lid, '%s : setup.mat generated and saved. \n', char(datetime('now')));

%% close analysis tracking log file
fprintf(lid, '%s : initializeDirs analysis completed. \n\n', char(datetime('now')));
disp('=========== initializeDirs completed ===========');
% close log file
fclose(lid);