
clx
addpath('/share/kalanit/biac2/kgs/projects/bb2adult/code/kids/kids_fLoc_analysis/');
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

%% for each subj get mean amps and tvals for each contrast (visual, places, faces) 
roi_data = table();
for i=1:length(session) %loops thru session data structure; iterates by session
    currSession = i
    for c=1:length(contrast)
        %Identify relevant ROIs depending on contrast type
        if strcmp(contrast(c).name,'faces') % if contrast = faces vs all  - continue analysis on fusiform ROIs
            roi_idx=find(contains(session(currSession).ROIs,'Fus') | contains(session(currSession).ROIs,'fus'));
        elseif strcmp(contrast(c).name,'places') % if contrast = places vs all - continue analysis on CoS ROIs
            roi_idx=find(contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'PPA'));
        elseif strcmp(contrast(c).name,'visual') % if contrast = visual vs blank - continue analysis on v1 ROIs
           roi_idx=find(contains(session(currSession).ROIs,'v1') | contains(session(currSession).ROIs,'V1') ); 
        else 
           roi_idx=find(contains(session(currSession).ROIs,'OTS') | contains(session(currSession).ROIs,'ots') ); 
        end

        if ~isempty(roi_idx) % if no corresponding ROI for contrast in this session - no amps or tvals to be output
            allAmps=[];
            alltVals=[];
            allROIs  = {};

            for r=1:length(roi_idx) %loop thru each ROI and collect amps and tvals 
                currROI = roi_idx(r);
                sessionDir = session(currSession).dir;
                ROI = session(currSession).ROIs{currROI};
                scans = session(currSession).scans;
                parfiles = session(currSession).parfiles;
                % Run amplitude extraction
                [mv, amps, tVals]=kidsfLOC_ROI_amps(sessionDir,parfiles,dataType,scans,ROI,contrast(c),plotFlag);
                allAmps=[allAmps; amps(:,1:8)];
                alltVals=[alltVals; tVals'];
                allROIs{end+1} = ROI;

    
                % Append row to output
             end
                    row = table();
                
                    row.Session = string(session(currSession).name);
                    row.Contrast = string(contrast(c).name);
                    row.Age     = session(currSession).ageInYears;

                
                    % Store ROI names (comma-separated string)
                    row.ROIs = string(strjoin(allROIs, ', '));;
                
                    % Use ALL amps (not last ROI)
                    row.FaceAmp   = mean(mean(allAmps(:,1:2)), 'omitnan');
                    row.BodyAmp   = mean(mean(allAmps(:,3:4)), 'omitnan');
                    row.ObjectAmp = mean(mean(allAmps(:,5:6)), 'omitnan');
                    row.PlaceAmp  = mean(mean(allAmps(:,7:8)), 'omitnan');
                
                    % Tvals by contrast
                    if strcmp(contrast(c).name,'visual')
                        row.visualTvals = mean(alltVals, 'omitnan');
                        row.faceTvals   = NaN;
                        row.limbTvals = NaN; 
                        row.placeTvals  = NaN;
                
                    elseif strcmp(contrast(c).name,'places')
                        row.visualTvals = NaN;
                        row.faceTvals   = NaN;
                        row.limbTvals = NaN; 
                        row.placeTvals  = mean(alltVals, 'omitnan');
                
                    elseif strcmp(contrast(c).name,'faces')
                        row.visualTvals = NaN;
                        row.faceTvals   = mean(alltVals, 'omitnan');
                        row.limbTvals = NaN; 
                        row.placeTvals  = NaN;
                    else 
                        row.visualTvals = NaN;
                        row.faceTvals   = NaN;
                        row.limbTvals = mean(alltVals, 'omitnan'); 
                        row.placeTvals  = NaN;
                    end
                
                    % ALWAYS append row
                    roi_data = [roi_data; row];
           else % if no relevant ROIs
        end
    end
end

saveDir = ('/share/kalanit/biac2/kgs/projects/bb2adult/results/')
save(fullfile(saveDir, 'kid_tvals_and_amps_new.mat'), 'roi_data');

