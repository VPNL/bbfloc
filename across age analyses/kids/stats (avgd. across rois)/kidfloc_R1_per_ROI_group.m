
clx
addpath('/share/kalanit/biac2/kgs/projects/bb2adult/code/kids/kids_fLoc_analysis/');
addpath('/share/kalanit/biac2/kgs/projects/bb2adult/results_0429/');
cd('/share/kalanit/biac2/kgs/projects/bb2adult/code/kids/kids_fLoc_analysis/')%script that loops across session and ROIs calculates a contrast and saves
% the voxels betas and t values
% setinformation
contrast(1).name='visual';
contrast(1).active=[1 2 3 4 5 6 7 8];
contrast(1).control=0;
contrast(2).name='places';
contrast(2).active=[7 8];
contrast(2).control=[1 2 3 4 5 6];
contrast(3).name='faces';
contrast(3).active=[1 2];
contrast(3).control=[3 4 5 6 7 8];
contrast(4).name='limbs';
contrast(4).active=[3 4];
contrast(4).control=[1 2 5 6 7 8];

plotFlag=0; %select 1 if you want to see the plots

kidsfLOC_setSessions_4mm_disk;
dataType=3;
barcolors=[1 0 0; .8 .8 0; 0 0 1; .1 .8 .1];
barXtickLabels={'Faces','Bodies','Objects','Places'};
cutvals=2;
%% Assign FSsession anat folder to each subj 

FSsession_anat = {'AG10'  
    'AlS07'
     'AM10'
    'AyS10'                 
    'CGSA11'            
    'CLC06'                   
    'CS11'                    
    'DAPA10'     
    'DJM06'            
    'GEJA09'
    'INW06'      
    'JDB11'            
    'KW10'             
    'LL11'                    
    'MDT09' 
    'MEC05'
    'MFC11'      
    'NW10'             
    'OS12'              
    'RHSA06'
    'RJ09'                    
    'RJM10'            
    'SDS07' 
    'SERA10'
    'SM08'             
    'STM10' 
    'ZCM05'};

load('kid_mean_tvals_amps_TSNR_motion_TRs_0429.mat')

%% 
roi_data.R1 = NaN(height(roi_data), 1);
for s = 1:length(session)         
    currSession = s;
    session_name = session(currSession).name;
    scans = session(currSession).scans;
    sessionDir = session(currSession).dir;
    FSpath = FSsession_anat{s};

   for c = 1:length(contrast)
        
        % Identify relevant ROIs depending on contrast type
        if strcmp(contrast(c).name, 'faces')
            roi_idx = find(contains(session(currSession).ROIs,'Fus') | ...
                           contains(session(currSession).ROIs,'fus'));
        elseif strcmp(contrast(c).name, 'places')
            roi_idx = find(contains(session(currSession).ROIs,'CoS') | ...
                           contains(session(currSession).ROIs,'PPA'));  % FIX 2: removed duplicate CoS condition
        elseif strcmp(contrast(c).name, 'visual')
            roi_idx = find(contains(session(currSession).ROIs,'v1') | ...
                           contains(session(currSession).ROIs,'V1'));
        else 
            roi_idx = find(contains(session(currSession).ROIs,'OTS') | ...
                           contains(session(currSession).ROIs,'ots'));

        end

        contrastName = string(contrast(c).name);
        rowIdx = strcmp(roi_data.Session, session_name) & ...
                 strcmp(roi_data.Contrast, contrastName);
        allR1=[]
        for r=1:length(roi_idx)
            currROI = roi_idx(r);
            ROI = session(currSession).ROIs{currROI}
            if isfile([sessionDir,'/3DAnatomy/ROIs/',ROI,'.nii.gz'])
                
                Nroi=readFileNifti([sessionDir,'/3DAnatomy/ROIs/', ROI,'.nii.gz']);
                rois =reshape(Nroi.data, 1, 256*256*256);
                labels = find(rois>0); % get label indecies
                
                %% go to folders with R1
                qdir =['/share/kalanit/biac2/kgs/projects/Longitudinal/Anatomy/', FSpath,'/mrQ_aligned/OutPutFiles_1/BrainMaps'];
                cd(qdir);
                %% low res
                if ~isfile('T1_map_lsq_rs1mm_rl.nii.gz')
                    command =['mri_convert T1_map_lsq.nii.gz T1_map_lsq_rs1mm_rl.nii.gz -rl /share/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/',FSpath, '/mri/aseg.mgz -nc'];
                    unix(command)
                end
                
                R1file= readFileNifti('T1_map_lsq_rs1mm_rl.nii.gz'); %% get R1*
                R1vals =reshape(R1file.data, 1,256*256*256);
                %%T1 to R1 and msec to sec
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
saveDir = ('/share/kalanit/biac2/kgs/projects/bb2adult/results_0429/')
save(fullfile(saveDir, 'kid_mean_amps_tvals_TSNR_motion_TRs_R1_0429.mat'), 'roi_data');



