%% calc_withinscan_motion_babies
clx

%sessions= {session.name};
expdir='/share/kalanit/biac2/kgs/projects/bb2adult/data/babies/'

cd('/share/kalanit/biac2/kgs/projects/bb2adult/code/babies/')
addpath('/share/kalanit/biac2/kgs/projects/bb2adult/code/babies/')
addpath('/share/kalanit/biac2/kgs/projects/bb2adult/results/')


bbfLOC_setSessions;

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

%% get motion vals
load('baby_mean_tvals_amps_TSNR.mat')
roi_data.meanWithinMotion = NaN(height(roi_data), 1);
for i = 1:length(session) 
    currSession = i
    session_name = session(currSession).name;
    scans = session(currSession).scans;
    sessionDir = session(currSession).dir;

    for c = 1:length(contrast)
        
        %Identify relevant ROIs depending on contrast type
        if strcmp(contrast(c).name,'faces') % if contrast = faces vs all  - continue analysis on fusiform ROIs
            roi_idx=find(contains(session(currSession).ROIs,'faces') | contains(session(currSession).ROIs,'Faces')); 
        elseif strcmp(contrast(c).name,'places') % if contrast = places vs all - continue analysis on CoS ROIs
            roi_idx=find(contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'PPA'));
        elseif strcmp(contrast(c).name,'visual')% if contrast = visual vs blank - continue analysis on v1 ROIs
           roi_idx=find(contains(session(currSession).ROIs,'v1') | contains(session(currSession).ROIs,'V1') ); 
        else
           roi_idx=find(contains(session(currSession).ROIs,'limbs') | contains(session(currSession).ROIs,'limbs') ); 
        
        end

         if ~isempty(roi_idx) % if no corresponding ROI for contrast in this session - no amps or tvals to be output
            
            load(fullfile(sessionDir, "QA.mat"))
      
            WithinMotion = QA.MotionWithinTotalAvg;
       
            contrastName = string(contrast(c).name)
            rowIdx = strcmp(roi_data.Session, session_name) & ...
            strcmp(roi_data.Contrast, contrastName);

            roi_data.meanWithinMotion(rowIdx) = WithinMotion;
                
            end
         end
end

saveDir = ('/share/kalanit/biac2/kgs/projects/bb2adult/results/')
save(fullfile(saveDir, 'baby_mean_tvals_amps_TSNR_motion.mat'), 'roi_data');          


%% get total # of TRs per sess 

load('baby_mean_tvals_amps_TSNR_motion.mat')

TotalTRs = NaN(height(roi_data), 1);
for i = 1:length(session) 
    currSession = i
    session_name = session(currSession).name;
    scans = session(currSession).scans;
    sessionDir = session(currSession).dir;

    for c = 1:length(contrast)
        
        %Identify relevant ROIs depending on contrast type
        if strcmp(contrast(c).name,'faces') % if contrast = faces vs all  - continue analysis on fusiform ROIs
            roi_idx=find(contains(session(currSession).ROIs,'faces') | contains(session(currSession).ROIs,'Faces')); 
        elseif strcmp(contrast(c).name,'places') % if contrast = places vs all - continue analysis on CoS ROIs
            roi_idx=find(contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'PPA'));
        elseif strcmp(contrast(c).name,'visual')% if contrast = visual vs blank - continue analysis on v1 ROIs
           roi_idx=find(contains(session(currSession).ROIs,'v1') | contains(session(currSession).ROIs,'V1') ); 
        else
           roi_idx=find(contains(session(currSession).ROIs,'limbs') | contains(session(currSession).ROIs,'limbs') ); 
        
        end

         if ~isempty(roi_idx) % if no corresponding ROI for contrast in this session - no amps or tvals to be output
            
            load(fullfile(sessionDir, "mrSESSION.mat"))
      
            TR_totals = sum([mrSESSION.functionals.totalFrames]);
       
            contrastName = string(contrast(c).name)
            rowIdx = strcmp(roi_data.Session, session_name) & ...
            strcmp(roi_data.Contrast, contrastName);

            roi_data.TotalTRs(rowIdx) = TR_totals;
                
        end
      end
end

saveDir = ('/share/kalanit/biac2/kgs/projects/bb2adult/results/')
save(fullfile(saveDir, 'baby_mean_tvals_amps_TSNR_motion_TRs.mat'), 'roi_data');  
