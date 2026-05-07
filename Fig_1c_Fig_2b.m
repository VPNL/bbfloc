
%% Generate figures containing results - COMBINED HEMISPHERES
ROIpairs = {...
 {'lh_V1_4mm_disk_CT_meanAmps.csv', 'rh_V1_4mm_disk_CT_meanAmps.csv'}, ...
 {'lh_PPA_4mm_disk_CT_meanAmps.csv', 'rh_PPA_4mm_disk_CT_meanAmps.csv'}, ...
 {'lh_pFus_4mm_disk_CT_meanAmps.csv','rh_pFus_4mm_disk_CT_meanAmps.csv'}, ...
 {'lh_mFus_4mm_disk_CT_meanAmps.csv', 'rh_mFus_4mm_disk_CT_meanAmps.csv'}, ...
 };

barXtickLabels = {'Faces','Bodies','Objects','Places'};
yStr = {'Response Amplitude'};
ageGroups = {'Infants','Children'};
barcolors = [1 0 0; .8 .8 0; 0 0 1; .1 .8 .1];


% Define colors for each age group
% Infants: lighter colors
infantColors = [1 0.6 0.6;    % light red (faces)
                1 1 0.6;      % light yellow (bodies)  
                0.6 0.6 1;    % light blue (objects)
                0.6 1 0.6];   % light green (places)

% Children: darker/saturated colors
childColors = [1 0 0;         % red (faces)
               .8 .8 0;       % yellow (bodies)
               0 0 1;         % blue (objects)
               .1 .8 .1];     % green (places)
for p = 2:length(ROIpairs)
    
    pair = ROIpairs{p};
    lhData = readtable(pair{1});
    rhData = readtable(pair{2});
   
    lhAmps = table2array(lhData(:, 4:7));
    rhAmps = table2array(rhData(:, 4:7));

    allAmps = [lhAmps(:); rhAmps(:)];  % combine left and right hemisphere data
    limits = ([-3, 3]);
    
    % Create figure with 2 tiles (one per age group, combining hemispheres)
    fig = figure('Color',[1 1 1],'Units','normalized','Position',[0 0 1.2 1]);
    t = tiledlayout(1,2,'Padding','loose','TileSpacing','loose'); 
    
    % Extract ROI name for title/saving
    name = pair{1};
    name_no_csv = erase(name, '.csv');
    name_no_hemi = erase(name_no_csv, 'lh_');
    
    % Loop through age groups
    for g = 1:2
        % Define age groups
        switch g
            case 1
                lhIdx = lhData.ageInYears < 2; 
                rhIdx = rhData.ageInYears < 2;
            case 2
                lhIdx = lhData.ageInYears >=5 & lhData.ageInYears<18; 
                rhIdx = rhData.ageInYears >=5 & rhData.ageInYears<18;
        end

        % COMBINE BOTH HEMISPHERES
        lhAmps_group = table2array(lhData(lhIdx, 4:7));
        rhAmps_group = table2array(rhData(rhIdx, 4:7));
        
        % Concatenate vertically (pool subjects from both hemispheres)
        combinedAmps = [lhAmps_group; rhAmps_group];

        % Create subplot
        nexttile(g); hold on;
       
        if ~isempty(combinedAmps)
            if size(combinedAmps, 1) == 1 || numel(combinedAmps) == 1
                % Only one value → no std, set error to 0
                meanVal = combinedAmps(:)';           
                errVal = zeros(size(meanVal)); 
            else
                % Multiple values → use std
                meanVal = nanmean(combinedAmps);
                errVal = nanstd(combinedAmps);
            end
            
         % Select colors based on age group
        if g == 1
            barcolors = infantColors;  % lighter for infants
        else
            barcolors = childColors;   % darker for children
        end
            mybar(meanVal, errVal, barXtickLabels, yStr, barcolors);
        end
        
        set(gca, 'FontSize', 40, 'FontName', 'Helvetica');
        set(gca, 'XTick', [], 'XTickLabel', []); 
        ax = gca;
        ax.XColor = 'none';
        
        % Only show y-axis on first plot
        if g > 1
            set(gca, 'YTick', [], 'YTickLabel', []); 
            ylabel(''); 
            ax.YColor = 'none';   
        end
        
        ylim(limits);
        %title(ageGroups{g}, 'Interpreter','none','FontSize', 40);
        box off
    end
   
    % Save figure
    saveDir = '/share/kalanit/biac2/kgs/projects/bb2adult/results/';
    saveas(fig, fullfile(saveDir, [name_no_hemi '_combined.png']));
    saveas(fig, fullfile(saveDir, [name_no_hemi '_combined.fig']));
end

