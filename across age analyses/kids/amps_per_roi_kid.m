
%% Generate a separate CSV file for each ROI (rh_mFus, lh_mFus, rh_pFus, etc.), with each row representing one subject's response amplitude in that ROI. 


% It then compiles these into a structured table and saves it as a .csv.
saveDir='/share/kalanit/biac2/kgs/projects/bb2adult/results';
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
