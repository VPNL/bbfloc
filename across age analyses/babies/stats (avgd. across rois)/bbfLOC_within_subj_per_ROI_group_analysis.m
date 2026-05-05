
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

%% Create a CSV for each ROI containing amps
%This MATLAB script performs ROI-level analysis across multiple sessions and contrasts, extracting t-values for each ROI (not averaged across ROIs, unlike previous scripts). 
% It then compiles these into a structured table and saves it as a .csv.
saveDir='/share/kalanit/biac2/kgs/projects/bb2adult/results_0429';
rows = {};  % use cell array to avoid vertcat issues
contrastNames = {contrast.name};  


for c=1:length(contrast) % loops thru contrast data structure; iterates by contrast 
    for i=1:length(session) %loops thru session data structure; iterates by session
        currSession=i; 
        row = struct();
        row.subID = session(i).name; % get session name 
        row.ageInYears= session(i).ageInYears; %get age in days of subj
        if strcmp(contrast(c).name,'faces') % if contrast = faces vs all  - continue analysis on fusiform ROIs
            roi_idx=find(contains(session(currSession).ROIs,'faces') | contains(session(currSession).ROIs,'faces'));
        elseif strcmp(contrast(c).name,'limbs') 
           roi_idx=find(contains(session(currSession).ROIs,'limbs') | contains(session(currSession).ROIs,'limbs') );         
        elseif strcmp(contrast(c).name,'places') % if contrast = places vs all - continue analysis on CoS ROIs
            roi_idx=find(contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'PPA'));
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
                [mv, amps, tVals] = bbfLOC_ROI_amps(sessionDir, parfiles, dataType, scans, ROI, contrast(c), plotFlag);

                %meantVals=mean(alltVals); %Get the mean tvals across relevant ROIs  
                allAmps=[allAmps; amps(:,1:4)];
                row.facesAmps = mean(allAmps(:,1));
                row.bodyAmps = mean(allAmps(:,2));
                row.objectAmps = mean(allAmps(:,3));
                row.placeAmps = mean(allAmps(:,4));
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
    
    % Extract the first two parts of the ROI name (before first two underscores)
    roiParts = strsplit(roiName, '_');
    if length(roiParts) >= 2
        roiPrefix = [roiParts{1} '_' roiParts{2}];  % e.g., 'rh_pfus'
    else
        roiPrefix = roiName;  % if less than 2 parts, use full name
    end
    
    % Look for existing MAT files with matching prefix
    existingFiles = dir(fullfile(saveDir, [roiPrefix '_*.mat']));
    
    if ~isempty(existingFiles)
        % Use the first matching file
        matName = fullfile(saveDir, existingFiles(1).name);
        
        % Load existing data
        existingData = load(matName);
        existingTable = existingData.roiTable;
        
        % Append new data to existing table
        roiTable = [existingTable; roiTable];
    else
        % Create new file with ROI name
        matName = fullfile(saveDir, [roiName '_meanAmps.mat']);
    end
    
    % Save the combined table
    save(matName, 'roiTable');
end



%% get amps and tvals for each ROI per subject
% 
% for i=1:length(session) %loops thru session data structure; iterates by session
%     roi_data = table();
%     currSession = i;
%     for c=1:length(contrast)
%         %Identify relevant ROIs depending on contrast type
%         if strcmp(contrast(c).name,'faces') % if contrast = faces vs all  - continue analysis on fusiform ROIs
%             roi_idx=find(contains(session(currSession).ROIs,'Fus') | contains(session(currSession).ROIs,'fus') | contains(session(currSession).ROIs,'OTS') | contains(session(currSession).ROIs,'IOG') |contains(session(currSession).ROIs,'faces'));
%         elseif strcmp(contrast(c).name,'places') % if contrast = places vs all - continue analysis on CoS ROIs
%             roi_idx=find(contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'PPA'));
%         else % if contrast = visual vs blank - continue analysis on v1 ROIs
%            roi_idx=find(contains(session(currSession).ROIs,'v1') | contains(session(currSession).ROIs,'V1') ); 
%         end
% 
%         if ~isempty(roi_idx) % if no corresponding ROI for contrast in this session - no amps or tvals to be output
% 
%             for r=1:length(roi_idx) %loop thru each ROI and collect amps and tvals 
%                 allAmps=[];
%                 alltVals=[];
% 
%                 currROI = roi_idx(r);
%                 sessionDir = session(currSession).dir;
%                 ROI = session(currSession).ROIs{currROI};
%                 scans = session(currSession).scans;
%                 parfiles = session(currSession).parfiles;
%                 % Run amplitude extraction
%                 [mv, amps, tVals] = bbfLOC_ROI_amps(sessionDir, parfiles, dataType, scans, ROI, contrast(c), plotFlag);
% 
%                 %meantVals=mean(alltVals); %Get the mean tvals across relevant ROIs  
%                 allAmps=[allAmps; amps(:,1:4)];
%                 alltVals=[alltVals; tVals'];
%                 % Append row to output
% 
%                 row = table();
% 
%                 row.Session = string(session(currSession).name);
%                 % Store ROI names (comma-separated string)
%                 row.ROI = string(ROI);
%                 row.Age = session(currSession).ageInYears;
% 
%                 row.FaceAmp   = mean(amps(:,1), 'omitnan');
%                 row.BodyAmp   = mean(amps(:,2), 'omitnan');
%                 row.ObjectAmp = mean(amps(:,3), 'omitnan');
%                 row.PlaceAmp  = mean(amps(:,4), 'omitnan');clx
%                 if c == 1
%                     row.visualTvals = mean(alltVals, 'omitnan');
%                     row.faceTvals = NaN;
%                     row.placeTvals = NaN; 
%                 elseif c == 2 
%                     row.visualTvals = NaN;
%                     row.faceTvals = NaN; 
%                     row.placeTvals = mean(alltVals, 'omitnan');
%                 else
%                     row.visualTvals = NaN;
%                     row.faceTvals = mean(alltVals, 'omitnan');
%                     row.placeTvals = NaN; 
% 
%                 end
%                 roi_data = [roi_data; row];
%             end
% 
%            else % if no relevant ROIs
%         end
%     end
%     % % Save table as a MAT file
%     save(fullfile(saveDir, 'baby_tvals_and_amps_per_ROI.mat'), 'roi_data');
% 
% end
% 
% % 


%% plot amps per subj

for i=1:length(session) %loops thru session data structure; iterates by session
    fa=figure('Color',[ 1 1 1],'Units','Norm','Position',[ 0 0 1 .5]);
    currSession = i;
    name = session(currSession).name;
    sgtitle([name 'RH and LH Combined Mean Amps &  T-vals'], 'FontSize', 20);
    allData = struct();
    for c=1:length(contrast)
        s(c) = subplot(1,3,c);
        contrastName = contrast(c).name;
        roi_data = table();
        %Identify relevant ROIs depending on contrast type
        if strcmp(contrast(c).name,'faces') % if contrast = faces vs all  - continue analysis on fusiform ROIs
            roi_idx=find(contains(session(currSession).ROIs,'Fus') | contains(session(currSession).ROIs,'fus') | contains(session(currSession).ROIs,'OTS') | contains(session(currSession).ROIs,'IOG') |contains(session(currSession).ROIs,'faces'));
        elseif strcmp(contrast(c).name,'places') % if contrast = places vs all - continue analysis on CoS ROIs
            roi_idx=find(contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'CoS')| contains(session(currSession).ROIs,'PPA'));
        else % if contrast = visual vs blank - continue analysis on v1 ROIs
           roi_idx=find(contains(session(currSession).ROIs,'v1') | contains(session(currSession).ROIs,'V1') ); 
        end

        if ~isempty(roi_idx) % if no corresponding ROI for contrast in this session - no amps or tvals to be output

            for r=1:length(roi_idx) %loop thru each ROI and collect amps and tvals 
                allAmps=[];
                alltVals=[];
      
                currROI = roi_idx(r);
                sessionDir = session(currSession).dir;
                ROI = session(currSession).ROIs{currROI};
                scans = session(currSession).scans;
                parfiles = session(currSession).parfiles;
                % Run amplitude extraction
                [mv, amps, tVals] = bbfLOC_ROI_amps(sessionDir, parfiles, dataType, scans, ROI, contrast(c), plotFlag);

                %meantVals=mean(alltVals); %Get the mean tvals across relevant ROIs  
                allAmps=[allAmps; amps(:,1:4)];
                alltVals=[alltVals; tVals'];
                % Append row to output

                row = table();
                
                row.Session = string(session(currSession).name);
                % Store ROI names (comma-separated string)
                row.ROI = string(ROI);
                row.Age = session(currSession).ageInYears;
            
                row.FaceAmp   = mean(allAmps(:,1), 'omitnan');
                row.BodyAmp   = mean(allAmps(:,2), 'omitnan');
                row.ObjectAmp = mean(allAmps(:,3), 'omitnan');
                row.PlaceAmp  = mean(allAmps(:,4), 'omitnan');
                if c == 1
                    row.visualTvals = mean(alltVals, 'omitnan');
                    row.faceTvals = NaN;
                    row.placeTvals = NaN; 
                elseif c == 2 
                    row.visualTvals = NaN;
                    row.faceTvals = NaN; 
                    row.placeTvals = mean(alltVals, 'omitnan');
                else
                    row.visualTvals = NaN;
                    row.faceTvals = mean(alltVals, 'omitnan');
                    row.placeTvals = NaN; 
         
                end
                roi_data = [roi_data; row];
                allData.(contrastName) = roi_data;
            end

            if size(roi_data,1) > 1
                errVals = std(roi_data{:,4:7}, 'omitnan');
            else
                errVals = [NaN NaN NaN NaN];
            end
            
            mybar(mean(roi_data{:,4:7},1), errVals, ...
                  barXtickLabels, [], barcolors)
            
            set(gca,'box','off')
            title(contrast(c).name)
            
            if c == 1
                ylabel('% Signal')
            end
          
           
           else % if no relevant ROIs
        end
    end
    filename = fullfile(saveDir, [name '_amps.png']);
    saveas(gcf, filename)

    save(fullfile(saveDir, [name '_amps_and_tvals.mat']), 'allData');
end
%
%% get tval plots per subject
for i=1:length(session) %loops thru session data structure; iterates by session

    fa=figure('Color',[ 1 1 1],'Units','Norm','Position',[ 0 0 1 .5]);
    currSession = i;
    name = session(i).name;
    load(fullfile(saveDir, [name '_amps_and_tvals.mat']));
    sgtitle([name 'RH and LH Combined Mean Amps &  T-vals'], 'FontSize', 20)

    for c=1:length(contrast)
        s(c) = subplot(1,3,c);
        contrastName = contrast(c).name;
        
        % Select correct tvals column
        if c == 1
            tvals = allData.visual.visualTvals;
            ROI = allData.visual.ROI;
        elseif c == 2
  
           if isfield(allData, 'places')  % ✅ check if field exists
                tvals = allData.places.placeTvals;
                ROI   = allData.places.ROI;
           else
                warning('allData.places does not exist. Skipping this contrast.');
                continue;   % skip this iteration of the loop
           end
        else
            if isfield(allData, 'faces')   % ✅ check if field exists
                tvals = allData.faces.faceTvals;
                ROI   = allData.faces.ROI;
            else
                warning('allData.faces does not exist. Skipping this contrast.');
                continue;   % skip this iteration
            end
        end
        % Keep only non-NaN values
        validIdx = ~isnan(tvals);

        if any(validIdx)
        
            % X positions: shift first point right, spread evenly
            n = sum(validIdx);
            x = linspace(1, n, n) + 0.3;  % 0.3 offset from y-axis
            
            % Scatter plot
            scatter(x, tvals(validIdx), 100, 'filled', 'MarkerFaceColor', [0 0.4470 0.7410]);
            
            % Labels
            set(gca,'XTick', x);
            set(gca,'XTickLabel', ROI(validIdx));
            xtickangle(45);
            
            % Optional: add light grid
            grid on;
            ax = gca;
            ax.YGrid = 'on';
            ax.XGrid = 'off';
            
            % Axis labels & title
            ylabel('T-value', 'FontSize', 14, 'FontWeight', 'bold');
            title([contrast(c).name ' ROI T-values'], 'FontSize', 12);
            
            % Adjust axes so points aren’t on the edge
            xlim([0.5, n+1]);
            
            set(gca,'Box','off','FontSize',12);
   
            

        end
    end
    filename = fullfile(saveDir, [name '_tval.png']);
    saveas(gcf, filename)
end



% % hold on
% % % 
% % if size(data,1) > 1
% %     errVals = std(data(:,1:4), 'omitnan');
% % else
% %     errVals = [NaN, NaN, NaN, NaN];
% % end
% 
% 
% % 
% %         maxA(c)=max(max(data(:,1:4)),[],'omitnan');
% %         minA(c)=min(min(data(:,1:4)),[],'omitnan');
% % 
% %         % Plot a bar graph of mean amplitudes (avgd across ROIs)
% %         mybar(mean(data(:,1:4),1), errVals, barXtickLabels,[], barcolors) %barplot plotting mean response amplitudes across relevant ROIs (by condition)
% %         set(gca,'box','off')
% %         title(contrast(c).name);
% %            if c==1
% %                 ylabel('% Signal')
% %            else
% %                 s(c).YColor='w';
% %            end
% %                 set(gca,'FontSize',18);
% % 
% % 
% %          s(c).YLim=[min(minA) max(maxA)];
% % 
% %         yticks = linspace(min(minA), max(maxA), 5); % 5 ticks (nice spacing)
% %         s(c).YTick = yticks;
% % 
% %         %subplot(1,4,4)
% % 
% %         % uniqueROIs = unique(roi_data.ROI, 'stable');   % get ROI names in order of appearance
% %         % nROIs = numel(uniqueROIs);
% %         % xPos = 1:nROIs;   
% %         % legendEntries = cell(1,length(contrast));
% %         % x = zeros(height(roi_data),1);
% %         % for r = 1:nROIs
% %         %     x(strcmp(roi_data.ROI, uniqueROIs{r})) = xPos(r);
% %         % end
% %         % npoints=size(data,1);
% %         % figure; hold on;
% %         % 
% %         % scatter(x, roi_data.tVals, 80, 'filled');   % 80 = marker size
% %         % xticks(xPos);
% %         % xticklabels(uniqueROIs);
% %         % ylabel('T-value');
% %         % xlabel('ROI');
% %         % title('T-values by ROI');
% %         % set(gca,'FontSize',8);
% %         % grid on;
% %         % 
% %         %      annotation('textbox', [0.8 0.6 0.1 0.1], ... % [x y w h] normalized coords
% %         %            'String', legendEntries, ...
% %         %            'FitBoxToText','on', ...
% %         % %            'EdgeColor','none', ...
% %         %            'FontSize',10);
% % 
% % 
% %     end
% % end
% %      % Add as annotation text box instead of legend
% %         annotation('textbox', [0.8 0.6 0.1 0.1], ... % [x y w h] normalized coords
% %                        'String', legendEntries, ...
% %                        'FitBoxToText','on', ...
% %                        'EdgeColor','none', ...
% %                        'FontSize',10);
% % 
% %         saveDir='/share/kalanit/biac2/kgs/projects/bb2adult/results';
% %         %savefile=fullfile(saveDir,'baby_rh_and_lh_combined_meanamps_andtvals.mat');
% %         savefig(fa, fullfile(saveDir, 'baby_rh_and_lh_combined_meanamps_andtvals.fig'));
% %         %savefig(fa, fullfile(saveDir, 'baby_rh_and_lh_combined_meanamps_andtvals.png'));
% %     end
% % 
% % 
% % 
% % 
% % 
% %         end
% % 
% % 
% % end
% % 
% % 
% % 
% % 
% % 
