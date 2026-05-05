
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

saveDir = ('/share/kalanit/biac2/kgs/projects/bb2adult/results_0429/')
save(fullfile(saveDir, 'kid_tvals_and_amps_new.mat'), 'roi_data');
%% Create a CSV for each ROI containing amps
%This MATLAB script performs ROI-level analysis across multiple sessions and contrasts, extracting t-values for each ROI (not averaged across ROIs, unlike previous scripts). 
% It then compiles these into a structured table and saves it as a .csv.
saveDir='/share/kalanit/biac2/kgs/projects/bb2adult/results_0429';
rows = {};  % use cell array to avoid vertcat issues
contrastNames = {contrast.name};  
cats = {'faces', 'bodies', 'objects', 'places'};

for c=1:length(contrast) % loops thru contrast data structure; iterates by contrast 
    for i=1:length(session) %loops thru session data structure; iterates by session
        currSession=i; 
        row = struct();
        row.subID = session(i).name; % get session name 
        row.ageInYears= session(i).ageInYears; %get age in days of subj
        %Identify relevant ROIs depending on contrast type
        if strcmp(contrast(c).name,'faces') % if contrast = faces vs all  - continue analysis on fusiform ROIs
            roi_idx=find(contains(session(currSession).ROIs,'Fus') | contains(session(currSession).ROIs,'fus'));
        elseif strcmp(contrast(c).name,'places') % if contrast = places vs all - continue analysis on CoS ROIs
             roi_idx=find(contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'cos')| contains(session(currSession).ROIs,'PPA')| contains(session(currSession).ROIs,'ppa'));
        else % if contrast = visual vs blank - continue analysis on v1 ROIs
           roi_idx=find(contains(session(currSession).ROIs,'v1') | contains(session(currSession).ROIs,'V1') ); 
        end
        if ~isempty(roi_idx) % if no corresponding ROI for contrast in this session - no amps or tvals to be output
            allAmps=[];
            alltVals=[];
           for r=1:length(roi_idx) %loop thru each ROI and collect amps and tvals 
                row = struct();  % initialize new row for each ROI
                currROI = roi_idx(r);
                sessionDir = session(currSession).dir;
                ROI = session(currSession).ROIs{currROI};
                scans = session(currSession).scans;
                parfiles = session(currSession).parfiles;

                % Fill in basic metadata
                row.name = session(currSession).name;
                row.ageInYears = session(currSession).ageInYears;
                row.ROI = ROI;

                % Run amplitude extraction
                [mv, amps, tVals] = kidsfLOC_ROI_amps(sessionDir, parfiles, dataType, scans, ROI, contrast(c), plotFlag);

                %meantVals=mean(alltVals); %Get the mean tvals across relevant ROIs  
                allAmps=[allAmps; amps(:,2:7)];
                row.facesAmps = mean(allAmps(:,1));
                row.bodyAmps = mean(mean(allAmps(:,2:3)));
                row.objectAmps = mean(mean(allAmps(:,4:5)));
                row.placeAmps = mean(allAmps(:,6));
                row.visAmps = mean(mean(allAmps));

                % Append row to output
                rows{end+1} = row;
            end
    
        else % if no relevant ROIs
        end
    end
end

% Convert to the cell array struct array, then table

% Normalize field names across all rows
allFieldCells = cellfun(@fieldnames, rows, 'UniformOutput', false);
allFields = unique(vertcat(allFieldCells{:}));

for i = 1:length(rows)
    missing = setdiff(allFields, fieldnames(rows{i}));
    for j = 1:length(missing)
        rows{i}.(missing{j}) = NaN;
    end
end
structArray = [rows{:}];
T = struct2table(structArray);

% Find all unique ROIs
allROIs = unique(T.ROI);

% Save a separate MAT file for each ROI
for r = 1:length(allROIs)
    roiName = allROIs{r};
    roiTable = T(strcmp(T.ROI, roiName), :);  % select only rows for this ROI
    matName = fullfile(saveDir, [roiName '_meanAmps.mat']);
    
    % Check if file exists and append if it does
    if exist(matName, 'file')
        % Load existing data
        existingData = load(matName);
        existingTable = existingData.roiTable;

        % Append new data to existing table
        roiTable = [existingTable; roiTable];
    end
    
    % Save the combined table
    save(matName, 'roiTable');
end

%% Create a CSV for each ROI containing amps
%This MATLAB script performs ROI-level analysis across multiple sessions and contrasts, extracting t-values for each ROI (not averaged across ROIs, unlike previous scripts). 
% It then compiles these into a structured table and saves it as a .csv.
saveDir='/share/kalanit/biac2/kgs/projects/bb2adult/results_0429';
rows = {};  % use cell array to avoid vertcat issues
contrastNames = {contrast.name};  
cats = {'faces', 'bodies', 'objects', 'places'};

for c=1:length(contrast) % loops thru contrast data structure; iterates by contrast 
    for i=1:length(session) %loops thru session data structure; iterates by session
        currSession=i; 
        row = struct();
        row.subID = session(i).name; % get session name 
        row.ageInYears= session(i).ageInYears; %get age in days of subj
        %Identify relevant ROIs depending on contrast type
        if strcmp(contrast(c).name,'faces') % if contrast = faces vs all  - continue analysis on fusiform ROIs
            roi_idx=find(contains(session(currSession).ROIs,'Fus') | contains(session(currSession).ROIs,'fus'));
        elseif strcmp(contrast(c).name,'places') % if contrast = places vs all - continue analysis on CoS ROIs
             roi_idx=find(contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'cos')| contains(session(currSession).ROIs,'PPA')| contains(session(currSession).ROIs,'ppa'));
        else % if contrast = visual vs blank - continue analysis on v1 ROIs
           roi_idx=find(contains(session(currSession).ROIs,'v1') | contains(session(currSession).ROIs,'V1') ); 
        end
        if ~isempty(roi_idx) % if no corresponding ROI for contrast in this session - no amps or tvals to be output
            allAmps=[];
            alltVals=[];
           for r=1:length(roi_idx) %loop thru each ROI and collect amps and tvals 
                row = struct();  % initialize new row for each ROI
                currROI = roi_idx(r);
                sessionDir = session(currSession).dir;
                ROI = session(currSession).ROIs{currROI};
                scans = session(currSession).scans;
                parfiles = session(currSession).parfiles;

                % Fill in basic metadata
                row.name = session(currSession).name;
                row.ageInYears = session(currSession).ageInYears;
                row.ROI = ROI;

                % Run amplitude extraction
                [mv, amps, tVals] = kidsfLOC_ROI_amps(sessionDir, parfiles, dataType, scans, ROI, contrast(c), plotFlag);

                %meantVals=mean(alltVals); %Get the mean tvals across relevant ROIs  
                allAmps=[allAmps; amps(:,2:7)];
                row.facesAmps = mean(allAmps(:,1));
                row.bodyAmps = mean(mean(allAmps(:,2:3)));
                row.objectAmps = mean(mean(allAmps(:,4:5)));
                row.placeAmps = mean(allAmps(:,6));
                row.visAmps = mean(mean(allAmps));

                % Append row to output
                rows{end+1} = row;
            end
    
        else % if no relevant ROIs
        end
    end
end

% Convert to the cell array struct array, then table

% Normalize field names across all rows
allFieldCells = cellfun(@fieldnames, rows, 'UniformOutput', false);
allFields = unique(vertcat(allFieldCells{:}));

for i = 1:length(rows)
    missing = setdiff(allFields, fieldnames(rows{i}));
    for j = 1:length(missing)
        rows{i}.(missing{j}) = NaN;
    end
end
structArray = [rows{:}];
T = struct2table(structArray);

% Find all unique ROIs
allROIs = unique(T.ROI);

% Save a separate MAT file for each ROI
for r = 1:length(allROIs)
    roiName = allROIs{r};
    roiTable = T(strcmp(T.ROI, roiName), :);  % select only rows for this ROI
    matName = fullfile(saveDir, [roiName '_meanAmps.mat']);
    
    % % Check if file exists and append if it does
    % if exist(matName, 'file')
    %     % Load existing data
    %     existingData = load(matName);
    %     existingTable = existingData.roiTable;
    % 
    %     % Append new data to existing table
    %     roiTable = [existingTable; roiTable];
    % end
    
    % Save the combined table
    save(matName, 'roiTable');
end
