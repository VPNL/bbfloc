%% calc_within scan motion for kid scans 
clx

addpath('/share/kalanit/biac2/kgs/projects/bb2adult/code/kids/kids_fLoc_analysis/');
cd('/share/kalanit/biac2/kgs/projects/bb2adult/code/kids/kids_fLoc_analysis/')
%sessions= {session.name};
expdir='/share/kalanit/biac2/kgs/projects/bb2adult/data/kids/'

cd('/share/kalanit/biac2/kgs/projects/bb2adult/code/kids/')
addpath('/share/kalanit/biac2/kgs/projects/bb2adult/code/kids/')
addpath('/share/kalanit/biac2/kgs/projects/bb2adult/results_0429/')

kidsfLOC_setSessions_4mm_disk;

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
contrast(4).active=[3 4];
contrast(4).control=[1 2 5 6 7 8];
plotFlag=0; %select 1 if you want to see the plots

plotFlag=0;

%% Get motion vals
load('kid_mean_tvals_amps_and_TSNR_0429.mat')

roi_data.meanWithinMotion = NaN(height(roi_data), 1);
for i = 1:length(session) 
    currSession = i
    session_name = session(currSession).name;
    scans = session(currSession).scans;
    sessionDir = session(currSession).dir;

    for c = 1:length(contrast)
        
        %Identify relevant ROIs depending on contrast type
        if strcmp(contrast(c).name,'faces') % if contrast = faces vs all  - continue analysis on fusiform ROIs
            roi_idx=find(contains(session(currSession).ROIs,'Fus') | contains(session(currSession).ROIs,'fus'));
        elseif strcmp(contrast(c).name,'places') % if contrast = places vs all - continue analysis on CoS ROIs
            roi_idx=find(contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'PPA'));
        elseif strcmp(contrast(c).name,'visual') % if contrast = visual vs blank - continue analysis on v1 ROIs
           roi_idx=find(contains(session(currSession).ROIs,'v1') | contains(session(currSession).ROIs,'V1') ); 
        else 
           roi_idx=find(contains(session(currSession).ROIs,'OTS') | contains(session(currSession).ROIs,'OTS') ); 
        end

         if ~isempty(roi_idx) % if no corresponding ROI for contrast in this session - no amps or tvals to be output
            
            load(fullfile(sessionDir, "QA.mat"))
      
            WithinMotion = QA.scan(scans).MotionWithinTotalAvg;
         
            
            contrastName = string(contrast(c).name)
            rowIdx = strcmp(roi_data.Session, session_name) & ...
            strcmp(roi_data.Contrast, contrastName);

            roi_data.meanWithinMotion(rowIdx) = WithinMotion;
         end
    end
end

saveDir = ('/share/kalanit/biac2/kgs/projects/bb2adult/results_0429/')
save(fullfile(saveDir, 'kid_mean_tvals_amps_TSNR_motion_0429.mat'), 'roi_data');

%% calc total TRs for kids


load('kid_mean_tvals_amps_TSNR_motion_0429.mat')

kidsfLOC_setSessions_4mm_disk;


TotalTRs = NaN(height(roi_data), 1);
for i = 1:length(session) 
    currSession = i
    session_name = session(currSession).name;
    scans = session(currSession).scans;
    sessionDir = session(currSession).dir;

    for c = 1:length(contrast)
        
        %Identify relevant ROIs depending on contrast type
        if strcmp(contrast(c).name,'faces') % if contrast = faces vs all  - continue analysis on fusiform ROIs
            roi_idx=find(contains(session(currSession).ROIs,'Fus') | contains(session(currSession).ROIs,'fus') | contains(session(currSession).ROIs,'OTS') | contains(session(currSession).ROIs,'IOG') |contains(session(currSession).ROIs,'faces'));
        elseif strcmp(contrast(c).name,'places') % if contrast = places vs all - continue analysis on CoS ROIs
            roi_idx=find(contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'PPA'));
        elseif strcmp(contrast(c).name,'visual') % if contrast = visual vs blank - continue analysis on v1 ROIs
           roi_idx=find(contains(session(currSession).ROIs,'v1') | contains(session(currSession).ROIs,'V1') ); 
        else 
           roi_idx=find(contains(session(currSession).ROIs,'OTS') | contains(session(currSession).ROIs,'OTS') ); 
        end

         if ~isempty(roi_idx) % if no corresponding ROI for contrast in this session - no amps or tvals to be output
            
                
            load(fullfile(sessionDir, "mrSESSION.mat"))
      
            TR_totals = mrSESSION.functionals(scans).totalFrames;
       
            contrastName = string(contrast(c).name)
            rowIdx = strcmp(roi_data.Session, session_name) & ...
            strcmp(roi_data.Contrast, contrastName);

            roi_data.TotalTRs(rowIdx) = TR_totals;
         end
    end
end

saveDir = ('/share/kalanit/biac2/kgs/projects/bb2adult/results_0429/')
save(fullfile(saveDir, 'kid_mean_tvals_amps_TSNR_motion_TRs_0429.mat'), 'roi_data');