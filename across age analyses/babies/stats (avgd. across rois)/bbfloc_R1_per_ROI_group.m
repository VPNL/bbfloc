
clx
cd('/share/kalanit/biac2/kgs/projects/bb2adult/code/babies/')
addpath('/share/kalanit/biac2/kgs/projects/bb2adult/code/babies/')
%script that loops across session and ROIs calculates a contrast and saves
% the voxels betas and t values
% setinformation
contrast(1).name='visual';
contrast(1).active=[1 2 3 4];
contrast(1).control=0;
contrast(2).name='places';
contrast(2).active=4;
contrast(2).control=[1 2 3];
contrast(3).name='faces';
contrast(3).active=1;
contrast(3).control=[2 3 4];
contrast(4).name='limbs';
contrast(4).active=2;
contrast(4).control=[1 3 4];
plotFlag=0;

bbfLOC_setSessions;
dataType=3;
barcolors=[1 0 0; .8 .8 0; 0 0 1; .1 .8 .1];
barXtickLabels={'Faces','Bodies','Objects','Places'};
saveDir='/share/kalanit/biac2/kgs/projects/bb2adult/results';
cutvals=2;
%% Assign FSsession anat folder to each subj 

baby ={'bb124', 'bb133', ',bb106', 'bb98', 'bb108', 'bb130', 'bb112', 'bb119', 'bb100', 'bb110', 'bb126', 'bb125'};
sess = {'mri4', 'mri3', 'mri4', 'mri4', 'mri5', 'mri5', 'mri5', 'mri5', 'mri5', 'mri6', 'mri6', 'mri4'};
addpath('/share/kalanit/biac2/kgs/projects/bb2adult/results/')
load('baby_mean_tvals_amps_TSNR_motion_TRs.mat')

anat_path = '/oak/stanford/groups/kalanit/biac2/kgs/projects/babybrains/mri/';

%% 
roi_data.R1 = NaN(height(roi_data), 1);
for s = 1:length(session)         
    currSession = s;
    session_name = session(currSession).name;
    scans = session(currSession).scans;
    sessionDir = session(currSession).dir;
    timepoint = sess{s};
    baby_subj = baby{s};
    
    T1mapPath = [anat_path, baby_subj, '/', timepoint,'/preprocessed_aligned/MRF/T1map_aligned_1mm.nii.gz'];
    if ~isfile(T1mapPath) 
	    fprintf('No T1map found for %s %s — skipping R1.\n', baby_subj, timepoint); 
	    continue 
    end

   for c = 1:length(contrast)
        
        %Identify relevant ROIs depending on contrast type
        if strcmp(contrast(c).name,'faces') % if contrast = faces vs all  - continue analysis on fusiform ROIs
            roi_idx=find(contains(session(currSession).ROIs,'Fus') | contains(session(currSession).ROIs,'fus'));
        elseif strcmp(contrast(c).name,'limbs') 
           roi_idx=find(contains(session(currSession).ROIs,'OTS') | contains(session(currSession).ROIs,'ots') );         
        elseif strcmp(contrast(c).name,'places') % if contrast = places vs all - continue analysis on CoS ROIs
            roi_idx=find(contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'PPA'));
        else % if contrast = visual vs blank - continue analysis on v1 ROIs
           roi_idx=find(contains(session(currSession).ROIs,'v1') | contains(session(currSession).ROIs,'V1') ); 
        end

        contrastName = string(contrast(c).name);
        rowIdx = strcmp(roi_data.Session, session_name) & ...
                 strcmp(roi_data.Contrast, contrastName);
        allR1=[]

        for r=1:length(roi_idx)
            currROI = roi_idx(r);
            ROI = session(currSession).ROIs{currROI};
            if isfile([sessionDir,'3DAnatomy/ROIs/',ROI,'.nii.gz'])
                
                Nroi=readFileNifti([sessionDir,'/3DAnatomy/ROIs/', ROI,'.nii.gz']);
                rois =reshape(Nroi.data, 1, 256*256*256);
                labels = find(rois>0); % get label indecies
                
         
                % go to folders with R1
                qdir = [anat_path, baby_subj, '/', timepoint, '/preprocessed_aligned/MRF'];
                cd(qdir);
               
                R1file= readFileNifti('T1map_aligned_1mm.nii.gz'); %% get R1*
                R1vals =reshape(R1file.data, 1,256*256*256);
                %%T1 to R1 and msec to sec
                R1vals= R1vals/1000; %% T1 to R1
                R1vals= 1./R1vals; %% T1 to R1
                R1vals(isinf(R1vals))=0;
                
                allval= R1vals(labels);
                R1mean = mean(nonzeros(allval(allval<cutvals & allval>0))); % remove anything above 4 s
                allR1=[allR1; R1mean];
             
            else
                display('no roi');
                
            end
      end
    
      roi_data.R1(rowIdx) = mean(allR1);
   end
end

%%
saveDir = ('/share/kalanit/biac2/kgs/projects/bb2adult/results/')
save(fullfile(saveDir, 'baby_mean_amps_tvals_TSNR_motion_TRs_R1.mat'), 'roi_data');



