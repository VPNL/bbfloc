
%csvPath = 'kid_and_baby_subj_mean_tvals_amps_and_motion_wTRs_.csv';
cd('/share/kalanit/biac2/kgs/projects/bb2adult/results_0429')
csvPath = 'combined_subj_mean_tvals_TSNR_motion_wTRs_R1.csv'
T = readtable(csvPath);


%% ---- Robust variable name mapping (case-insensitive) ----
ageVar    = pickVar(T, {'age','Age','AGE'});
snrVar    = pickVar(T, {'meantSNR','meanTSNR','mean_tSNR','tSNR','TSNR','meanSNR','mean_tsnr'});

visVar    = pickVar(T, {'visualTvals','visualTval','visual_tvals','VisualTvals','visualT'});
faceVar   = pickVar(T, {'faceTvals','facesTvals','face_tvals','FaceTvals','faceT'});
placeVar  = pickVar(T, {'placeTvals','placesTvals','place_tvals','PlaceTvals','placeT'});
motionVar = pickVar(T, {'meanWithinMotion','mean_within_motion','motion'});
trVar   =   pickVar(T, {'TotalTRs','TRs','nTRs'});
TSNRVar   =   pickVar(T, {'meantSNR'});
r1Var   =   pickVar(T, {'R1'});
% Optional ID column (not required for plotting; scatter is age-color-coded)
%idVar = pickVarOptional(T, {'ID','Id','subID','SubID','Subject','subject','participant','Participant'});

%% ---- Ensure numeric predictors/outcomes ----
T.(ageVar)   = double(T.(ageVar));
T.(motionVar) = double(T.(motionVar))
%.(TSNRVar)   = double(T.(TSNRVar));
T.(visVar)   = double(T.(visVar));
T.(faceVar)  = double(T.(faceVar));
T.(placeVar) = double(T.(placeVar));
T.(motionVar)=double(T.(motionVar));
T.(trVar)=double(T.(trVar));
T.(r1Var)=double(T.(r1Var));


%% ---- Drop rows with missing values in required variables ----
reqVars = {ageVar, snrVar, visVar, faceVar, placeVar};
%if ~isempty(idVar); reqVars{end+1} = idVar; end %#ok<AGROW>

%% R1 and age as factors 
models = struct();
models(1).name = 'Visual';
models(1).yvar = visVar;
models(1).formula = sprintf('%s ~ %s + %s', visVar, ageVar, r1Var);

models(2).name = 'Places';
models(2).yvar = placeVar;
models(2).formula = sprintf('%s ~ %s + %s', placeVar, ageVar, r1Var);

models(3).name = 'Faces';
models(3).yvar = faceVar;
models(3).formula = sprintf('%s ~ %s + %s', faceVar, ageVar, r1Var);

models(4).name = 'Visual';
models(4).yvar = visVar;
models(4).formula = sprintf('%s ~ %s', visVar, r1Var);

models(5).name = 'Places';
models(5).yvar = placeVar;
models(5).formula = sprintf('%s ~ %s', placeVar, r1Var);

models(6).name = 'Faces';
models(6).yvar = faceVar;
models(6).formula = sprintf('%s ~ %s', faceVar, r1Var);



lme = cell(1, numel(models));
for i = 1:numel(models)
    lme{i} = fitlme(T, models(i).formula);  % fitlme as requested
end

comparisons = cell(1,3);

c1 = compare(lme{4}, lme{1});
c2 = compare(lme{5}, lme{2});
c3 = compare(lme{6}, lme{3});
comparisons{1} = c1;
comparisons{2} = c2;
comparisons{3} = c3;


%% ---- Save full results + stats to a text file ----
outTxt = fullfile(pwd, [ erase(csvPath,'.csv') '_lme_R1_results.txt']);
fid = fopen(outTxt, 'w');
if fid < 0; error('Could not open output text file for writing: %s', outTxt); end

fprintf(fid, 'LME results\n');
fprintf(fid, 'Data: %s\n', csvPath);
fprintf(fid, 'N rows used: %d\n', height(T));
fprintf(fid, 'Date: %s\n\n', datestr(now, 0));

for i = 1:numel(models)
    fprintf(fid, '============================================================\n');
    fprintf(fid, 'Contrast: %s\n', models(i).name);
    fprintf(fid, 'Formula:  %s\n\n', models(i).formula);

    % Full textual summary
    fprintf(fid, '--- Model summary (fitlme display) ---\n');
    fprintf(fid, '%s\n', evalc('disp(lme{i})'));

    % ANOVA table
    fprintf(fid, '\n--- ANOVA ---\n');
    try
        fprintf(fid, '%s\n', evalc('disp(anova(lme{i}))'));
    catch
        fprintf(fid, '(anova not available)\n');
    end

    % Fixed effects table
    fprintf(fid, '\n--- Fixed effects ---\n');
    try
        fprintf(fid, '%s\n', evalc('disp(lme{i}.Coefficients)'));
    catch
        fprintf(fid, '(Coefficients table not available)\n');
    end

    % Fit statistics
    fprintf(fid, '\n--- Fit statistics ---\n');
    try
        stats = lme{i}.ModelCriterion;
        fprintf(fid, 'AIC: %.4f\n', stats.AIC);
        fprintf(fid, 'BIC: %.4f\n', stats.BIC);
        fprintf(fid, 'LogLikelihood: %.4f\n', stats.LogLikelihood);
        fprintf(fid, 'Deviance: %.4f\n', stats.Deviance);
    catch
        fprintf(fid, '(ModelCriterion not available)\n');
    end
    fprintf(fid, '\n');
end

compNames = {'Visual', 'Places', 'Faces'};
compPairs = {[1 4],[2 5],[3 6]};

fprintf(fid, '======================================\n');
fprintf(fid, 'MODEL COMPARISONS: Effect of Age (full v. R1 only) ---\n');
fprintf(fid, '======================================\n');
for k = 1:3
    fprintf(fid, '--- %s: Model %d (with age) vs Model %d (R1 only) ---\n', ...
        compNames{k}, compPairs{k}(1), compPairs{k}(2));
        fprintf(fid, 'Age & R1: %s\n', models(compPairs{k}(1)).formula); 
        fprintf(fid, 'R1 only: %s\n',models(compPairs{k}(2)).formula);
 
        fprintf(fid, '%s\n', evalc('disp(comparisons{k})'));
        % Also pull out key stats explicitly
        ct = comparisons{k};  % this is a table
        fprintf(fid, 'Chi-sq(df=%d) = %.4f, p = %.4f\n', ...
        ct.deltaDF(2), ct.LRStat(2), ct.pValue(2));
end

fclose(fid);
fprintf('Saved LME outputs to: %s\n', outTxt);

% fprintf(fid, 'Comparison results\n');
%% ---- Plotting settings ----
%% ---- Plotting settings ----
ageVals = T.(ageVar);
TSNRVals = T.(TSNRVar)
motionVals = T.(motionVar)
cmap = plasma(256);
ageMin = min(ageVals);
ageMax = max(ageVals);
TSNRMin = min(TSNRVals);
TSNRMax = max(TSNRVals);
motionMin = min(motionVals);
motionMax = max(motionVals);
ageIdx = 1 + round(255 * (ageVals - ageMin) ./ max(eps, (ageMax - ageMin)));
ageIdx = max(1, min(256, ageIdx));
ptColors = cmap(ageIdx, :);

meanAge = mean(T.(ageVar), 'omitnan');

alphaCI  = 0.05;  % 95% CI
alphaSig = 0.05;  % significance threshold for drawing regression + CI
markerSize=200;


% Compute shared y-limits for Faces and Places (data-driven, with padding)
yFP = [T.(faceVar); T.(placeVar)];
yFP = yFP(~isnan(yFP));
if isempty(yFP)
    yFPmin = NaN; yFPmax = NaN;
else
    yFPmin = min(yFP);
    yFPmax = max(yFP);
    pad = 0.05 * max(eps, (yFPmax - yFPmin));
    yFPmin = yFPmin - pad;
    yFPmax = yFPmax + pad;
end

%% One figure with 3 panels (Visual/Faces/Places), same age color-coding as above.
% Faces + Places panels share the same y-axis limits.
fSum = figure('Name', 'Tvals_vs_R1', 'Color', 'w','Units','normalized','Position',[ 0 0 .8 1]);
tlSum = tiledlayout(fSum, 1, 3, 'Padding', 'compact', 'TileSpacing', 'compact');

for j = 4:6
    yvar = models(j).yvar;

    % Determine w hether AGE is significant for this model (for line/CI gating)
    coefTbl = lme{j}.Coefficients;
    coefNames = string(coefTbl.Name);
    namesCell = cellstr(coefTbl.Name);
    pVals = coefTbl.pValue;
    pR1 = NaN; 
   
    % R1term (robust match: exact, then contains; case-insensitive)
    idxR1 = find(strcmpi(namesCell, r1Var), 1, 'first');
    if isempty(idxR1)
        idxR1 = find(contains(lower(string(namesCell)), lower(string(R1Var))), 1, 'first');
    end
    if ~isempty(idxR1)
        pR1 = pVals(idxR1);
    end

    %ageIsSig = ~isnan(pAge) && (pAge < alphaSig);
    R1IsSig = ~isnan(pR1) && (pR1 < alphaSig);
    ax = nexttile(tlSum, j-3);
    hold(ax, 'on');

    scatter(ax, T.(r1Var), T.(yvar), markerSize, T.(motionVar), 'filled');

    % Plot regression + CI only if REGRESSION is significant (consistent with main figs)
    %if ageIsSig
    if R1IsSig



        xr1 = linspace(min(T.(r1Var)), max(T.(r1Var)), 200)';
        newTbl = T(1, :);
        newTbl = repmat(newTbl, numel(xr1), 1);
        newTbl.(r1Var) = xr1;
     

        [yhat, yci] = predict(lme{j}, newTbl, 'Alpha', alphaCI, 'Conditional', false);
        plotCI(ax, xr1, yci, [0.5 0.5 0.5], 0.25);
        plot(ax, xr1, yhat, 'k-', 'LineWidth', 2);
       yline(0, 'k-', 'LineWidth', 1);
    end

    xlabel(ax, 'R1 [s^{-1}]');
    ylabel(ax, 'T-value', 'Interpreter', 'none');
     set(gca,'FontName','Helvetica','FontSize',32,'FontWeight','normal')
      title(ax, sprintf('%s \n p(R1)=%.3g', ...
          models(j).name, pR1), 'Interpreter', 'none',...
         'FontName','Helvetica','FontSize',24,'FontWeight','normal');
  
    colormap(ax, cmap);
    caxis(ax, [motionMin motionMax]);
    %caxis(ax, [TSNRMin TSNRMax]);


    % Enforce shared y-limits for Faces and Places panels (j=2,3)
    if (j == 5 || j == 6) && ~isnan(yFPmin) && ~isnan(yFPmax)
        ylim(ax, [yFPmin yFPmax]);
    else
        %ylim(ax, [yFPmin  max(T.(visVar))]);
    end

end

cb = colorbar(nexttile(tlSum, 3));

cb.Label.String = 'Mean motion [voxels]';

% Export summary figure as 600 dpi PNG
outPngSum = fullfile(pwd, sprintf('Selectivity~R1.png', datestr(now,'yyyymmdd')));
exportgraphics(fSum, outPngSum, 'Resolution', 600);
fprintf('Saved summary figure: %s\n', outPngSum);


%% 2 factor models
fSum = figure('Name', 'Tvals_vs_R1_Age', 'Color', 'w','Units','normalized','Position',[ 0 0 1 .5]);
tlSum = tiledlayout(fSum, 1, 6, 'Padding', 'tight', 'TileSpacing', 'loose');

% Row 1 = R1 panels, Row 2 = Age panels
% Tile ordering: [1 2 3; 4 5 6]

regressors = {r1Var, ageVar};
rowLabels  = {'R1 [s^{-1}]', 'Age [Years]'};
pFieldName = {'pR1', 'pAge'};
for j = 1:3

    yvar = models(j).yvar;
    coefTbl = lme{j}.Coefficients;
    namesCell = cellstr(coefTbl.Name);
    pVals = coefTbl.pValue;
    pR1 = NaN; pAge = NaN;

    idxR1 = find(strcmpi(namesCell, r1Var), 1, 'first');
    if ~isempty(idxR1), pR1 = pVals(idxR1); end

    idxAge = find(strcmpi(namesCell, ageVar), 1, 'first');
    if ~isempty(idxAge), pAge = pVals(idxAge); end

    pBoth = [pR1, pAge];

    for row = 1:2%1%:2
        xVar  = regressors{row};
        pThis = pBoth(row);
        isSig = ~isnan(pThis) && (pThis < alphaSig);

        %tileIdx = j;
        tileIdx = (row-1)*3+j
        ax = nexttile(tlSum, tileIdx);

        hold(ax, 'on');

        % Color by the other variable
        if row == 1
            %colorData = T.(ageVar); cLim = [ageMin ageMax];
            colorData = T.(TSNRVar); cLim = [TSNRMin TSNRMax];
            %colorData = T.(motionVar); cLim = [motionMin motionMax]
        else
            %colorData = T.(ageVar); cLim = [ageMin ageMax];
            colorData = T.(TSNRVar); cLim = [TSNRMin TSNRMax];
            
            %colorData = T.(motionVar); cLim = [motionMin motionMax];
        end

        scatter(ax, T.(xVar), T.(yvar), markerSize, colorData, 'filled');
 
        if row == 1 && j==1
            ylabel(ax, 'T-value');
        end

        if isSig
            xgrid = linspace(min(T.(xVar)), max(T.(xVar)), 200)';
            newTbl = repmat(T(1,:), numel(xgrid), 1);
            newTbl.(xVar) = xgrid;
            % Hold other regressor at its mean

            
            % if row == 1
            %     newTbl.(ageVar) = repmat(mean(T.(ageVar), 'omitnan'), numel(xgrid), 1);
            % else
            %     newTbl.(r1Var) = repmat(mean(T.(r1Var), 'omitnan'), numel(xgrid), 1);
            % end
            [yhat, yci] = predict(lme{j}, newTbl, 'Alpha', alphaCI, 'Conditional', false);
            plotCI(ax, xgrid, yci, [0.5 0.5 0.5], 0.25);
            plot(ax, xgrid, yhat, 'k-', 'LineWidth', 2);
            yline(ax, 0, 'k-', 'LineWidth', 1);
        end

        xlabel(ax, rowLabels{row});
        
        set(ax, 'FontName', 'Avenir', 'FontSize', 28, 'FontWeight', 'normal');
        title(ax, sprintf('%s\np(%s)=%.3g', models(j).name, xVar, pThis), ...
            'Interpreter', 'none', 'FontName', 'Avenir', 'FontSize', 24, 'FontWeight', 'normal');
        colormap(ax, cmap);
        caxis(ax, cLim);
        ylabel(ax, 'T-value');
    end
end

% Colorbars on last R1 and last Age panels
cb1 = colorbar('EastOutside');
%cb1.Label.String = 'Age [Years]';
cb1.Label.String = 'TSNR';
%cb1.Label.String = 'Mean Motion [Voxels]';
cb2.Label.Interpreter = 'tex';

saveas(gcf,'Selectivity~R1+Age_coloredbyTSNR.png')
   
%% ===================== Local helper functions =====================
function v = pickVar(T, candidates)
% Return the first candidate that matches a table variable name (case-insensitive).
    names = string(T.Properties.VariableNames);
    lowerNames = lower(names);

    v = "";
    for k = 1:numel(candidates)
        c = lower(string(candidates{k}));
        idx = find(lowerNames == c, 1, 'first');
        if ~isempty(idx)
            v = names(idx);
            return;
        end
    end

    % If no exact match, try contains-based fallback
    for k = 1:numel(candidates)
        c = lower(string(candidates{k}));
        idx = find(contains(lowerNames, c), 1, 'first');
        if ~isempty(idx)
            v = names(idx);
            return;
        end
    end

    error('Could not find required variable in table. Tried: %s\nAvailable vars: %s', ...
        strjoin(string(candidates), ', '), strjoin(names, ', '));
end

function v = pickVarOptional(T, candidates)
% Optional version: returns "" if not found.
    names = string(T.Properties.VariableNames);
    lowerNames = lower(names);

    v = "";
    for k = 1:numel(candidates)
        c = lower(string(candidates{k}));
        idx = find(lowerNames == c, 1, 'first');
        if ~isempty(idx)
            v = names(idx);
            return;
        end
    end

    for k = 1:numel(candidates)
        c = lower(string(candidates{k}));
        idx = find(contains(lowerNames, c), 1, 'first');
        if ~isempty(idx)
            v = names(idx);
            return;
        end
    end
end

function plotCI(ax, x, yci, rgb, faceAlpha)
% Plot a confidence band given x and yci (Nx2).
    if isempty(yci) || size(yci,2) ~= 2
        return;
    end
    x = x(:);
    lo = yci(:,1);
    hi = yci(:,2);

    X = [x; flipud(x)];
    Y = [lo; flipud(hi)];
    h = fill(ax, X, Y, rgb, 'LineStyle', 'none');
    h.FaceAlpha = faceAlpha;
end
