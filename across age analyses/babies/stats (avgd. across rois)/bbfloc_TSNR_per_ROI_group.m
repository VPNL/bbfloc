%% calc_tsnr_babies
clx

%sessions= {session.name};
expdir='/share/kalanit/biac2/kgs/projects/bb2adult/data/babies/'

cd('/share/kalanit/biac2/kgs/projects/bb2adult/code/babies/')
addpath('/share/kalanit/biac2/kgs/projects/bb2adult/code/')
addpath('/share/kalanit/biac2/kgs/projects/bb2adult/results/')
saveDir=('/share/kalanit/biac2/kgs/projects/bb2adult/results/')

load('baby_tvals_and_amps.mat')
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

plotFlag=0;

roi_data.meantSNR = NaN(height(roi_data), 1);

for i = 1:length(session) 
    currSession = i
    session_name = session(currSession).name;
    scans = session(currSession).scans;
    sessionDir = session(currSession).dir;

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
  

         if ~isempty(roi_idx) % if no corresponding ROI for contrast in this session - no amps or tvals to be output
            
      
            allBvoxeltSNR=[];
            rois = session(currSession).ROIs{roi_idx}

            for r=1:length(roi_idx) %loop thru each ROI and collect amps and tvals 
                currROI = roi_idx(r);
                ROI = session(currSession).ROIs{currROI};
                % Run amplitude extraction
                [~, ~, BvoxeltSNR, ~, ~, ~, ~]=calc_tSNR_roi(expdir,{session_name},{ROI},[3],[scans],['blah'],'i',[2],[1]);
               
                allBvoxeltSNR=[allBvoxeltSNR, BvoxeltSNR];
                
            end
            contrastName = string(contrast(c).name)
            rowIdx = strcmp(roi_data.Session, session_name) & ...
            strcmp(roi_data.Contrast, contrastName);

            roi_data.meantSNR(rowIdx) = mean(allBvoxeltSNR);
         end
    end
end

          
save(fullfile(saveDir, 'baby_mean_tvals_amps_TSNR.mat'), 'roi_data');
