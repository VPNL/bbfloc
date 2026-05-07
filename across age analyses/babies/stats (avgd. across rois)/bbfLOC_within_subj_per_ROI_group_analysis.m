
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

bbfLOC_setSessions_0429;
dataType=3;
barcolors=[1 0 0; .8 .8 0; 0 0 1; .1 .8 .1];
barXtickLabels={'Faces','Bodies','Objects','Places'};
saveDir='/share/kalanit/biac2/kgs/projects/bb2adult/results_0429/';

%% for each subj get mean amps and tvals for each contrast (visual, places, faces) 
roi_data = table();

for i=1:length(session) %loops thru session data structure; iterates by session
    
    currSession = i
    for c=1:length(contrast)
        %Identify relevant ROIs depending on contrast type
        if strcmp(contrast(c).name,'faces') % if contrast = faces vs all  - continue analysis on fusiform ROIs
            roi_idx=find(contains(session(currSession).ROIs,'faces') | contains(session(currSession).ROIs,'Faces'));
        elseif strcmp(contrast(c).name,'limbs') 
           roi_idx=find(contains(session(currSession).ROIs,'limbs') | contains(session(currSession).ROIs,'Limbs') );         
        elseif strcmp(contrast(c).name,'places') % if contrast = places vs all - continue analysis on CoS ROIs
            roi_idx=find(contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'PPA'));
        else % if contrast = visual vs blank - continue analysis on v1 ROIs
           roi_idx=find(contains(session(currSession).ROIs,'v1') | contains(session(currSession).ROIs,'V1') ); 
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
                [mv, amps, tVals] = bbfLOC_ROI_amps(sessionDir, parfiles, dataType, scans, ROI, contrast(c), plotFlag);

                meantVals=mean(alltVals); %Get the mean tvals across relevant ROIs  
                allAmps=[allAmps; amps(:,1:4)];
                alltVals=[alltVals; tVals'];
                allROIs{end+1} = ROI;
            end
            % Append row to output

            row = table();
            
            row.Session = string(session(currSession).name);
            row.Contrast = string(contrast(c).name);
            % Store ROI names (comma-separated string)
            row.ROIs = string(strjoin(allROIs, ', '));;
                
            row.Age = session(currSession).ageInYears;
            
            row.FaceAmp   = mean(allAmps(:,1), 'omitnan');
            row.BodyAmp   = mean(allAmps(:,2), 'omitnan');
            row.ObjectAmp = mean(allAmps(:,3), 'omitnan');
            row.PlaceAmp  = mean(allAmps(:,4), 'omitnan');
            if c == 1
                row.visualTvals = mean(alltVals, 'omitnan');
                row.faceTvals = NaN;
                row.limbTvals = NaN; 
                row.placeTvals = NaN;           
            elseif c == 2 
                row.visualTvals = NaN;
                row.faceTvals = NaN; 
                row.limbTvals = NaN; 
                row.placeTvals = mean(alltVals, 'omitnan');
            elseif c == 3
                row.visualTvals = NaN;
                row.faceTvals = mean(alltVals, 'omitnan');
                row.limbTvals = NaN; 
                row.placeTvals = NaN;   
            else
                row.visualTvals = NaN;
                row.faceTvals = NaN;
                row.limbTvals = mean(alltVals, 'omitnan'); 
                row.placeTvals = NaN;  
     
            end
            roi_data = [roi_data; row];
           else % if no relevant ROIs
        end
    end
end

% 
% % % Save table as a MAT file
save(fullfile(saveDir, 'baby_tvals_and_amps_0429.mat'), 'roi_data');
