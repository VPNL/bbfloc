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
%r1Var   =   pickVar(T, {'R1'});
% Optional ID column (not required for plotting; scatter is age-color-coded)
%idVar = pickVarOptional(T, {'ID','Id','subID','SubID','Subject','subject','participant','Participant'});

%% ---- Ensure numeric predictors/outcomes ----
T.(ageVar)   = double(T.(ageVar));
T.(snrVar)   = double(T.(snrVar));
T.(visVar)   = double(T.(visVar));
T.(faceVar)  = double(T.(faceVar));
T.(placeVar) = double(T.(placeVar));
T.(motionVar)=double(T.(motionVar));
T.(trVar)=double(T.(trVar));
%T.(r1Var)=double(T.(r1Var));

%% ---- Drop rows with missing values in required variables ----
reqVars = {ageVar, snrVar, visVar, faceVar, placeVar};
%if ~isempty(idVar); reqVars{end+1} = idVar; end %#ok<AGROW>

%% ---- Fit models ----
% models = struct();
% models(1).name = 'Visual_byage';
% models(1).yvar = visVar;
% models(1).formula = sprintf('%s ~ %s', visVar, ageVar);
% 
% models(2).name = 'Places_byage';
% models(2).yvar = placeVar;
% models(2).formula = sprintf('%s ~ %s', placeVar, ageVar);
% 
% models(3).name = 'Faces_byage';
% models(3).yvar = faceVar;
% models(3).formula = sprintf('%s ~ %s', faceVar, ageVar);

models(1).name = 'Visual';
models(1).yvar = visVar;
models(1).formula = sprintf('%s ~ %s + %s + %s', visVar, ageVar, snrVar, motionVar);

models(2).name = 'Places';
models(2).yvar = placeVar;
models(2).formula = sprintf('%s ~ %s + %s + %s', placeVar, ageVar, snrVar, motionVar);

models(3).name = 'Faces';
models(3).yvar = faceVar;
models(3).formula = sprintf('%s ~ %s + %s + %s', faceVar, ageVar, snrVar, motionVar);

% models(4).name = 'Motion by age';
% models(4).yvar = motionVar;
% models(4).formula = sprintf('%s ~ %s', motionVar, ageVar);
% 
% models(5).name = 'TSNR by age';
% models(5).yvar = snrVar;
% models(5).formula = sprintf('%s ~ %s', snrVar, ageVar);
% 
% models(6).name = 'TR by age';
% models(6).yvar = trVar;
% models(6).formula = sprintf('%s ~ %s', trVar, ageVar);
% 
% models(7).name = 'Visual_noTR';
% models(7).yvar = visVar;
% models(7).formula = sprintf('%s ~ %s + %s + %s', visVar, ageVar, snrVar, motionVar);
% 
% models(8).name = 'Places_noTR';
% models(8).yvar = placeVar;
% models(8).formula = sprintf('%s ~ %s + %s + %s', placeVar, ageVar, snrVar,motionVar);
% 
% models(9).name = 'Faces_noTR';
% models(9).yvar = faceVar;
% models(9).formula = sprintf('%s ~ %s + %s + %s', faceVar, ageVar, snrVar,motionVar);
% 
% models(10).name = 'Visual_byage';
% models(10).yvar = visVar;
% models(10).formula = sprintf('%s ~ %s', visVar, ageVar);
% 
% models(11).name = 'Places_byage';
% models(11).yvar = placeVar;
% models(11).formula = sprintf('%s ~ %s', placeVar, ageVar);
% 
% models(12).name = 'Faces_byage';
% models(12).yvar = faceVar;
% models(12).formula = sprintf('%s ~ %s', faceVar, ageVar);
% 
% models(13).name = 'Visual_age&motion';
% models(13).yvar = visVar;
% models(13).formula = sprintf('%s ~ %s + %s', visVar, ageVar, motionVar);
% 
% models(14).name = 'Places_ages&motion';
% models(14).yvar = placeVar;
% models(14).formula = sprintf('%s ~ %s + %s', placeVar, ageVar, motionVar);
% 
% models(15).name = 'Faces_age&motion';
% models(15).yvar = faceVar;
% models(15).formula = sprintf('%s ~ %s + %s', faceVar, ageVar, motionVar);
% 
% models(16).name = 'Visual_age&SNR';
% models(16).yvar = visVar;
% models(16).formula = sprintf('%s ~ %s + %s', visVar, ageVar, snrVar);
% 
% models(17).name = 'Places_ages&sNR';
% models(17).yvar = placeVar;
% models(17).formula = sprintf('%s ~ %s + %s', placeVar, ageVar, snrVar);
% 
% models(18).name = 'Faces_age&SNR';
% models(18).yvar = faceVar;
% models(18).formula = sprintf('%s ~ %s + %s', faceVar, ageVar, snrVar);
% 
% models(19).name = 'Visual_age&TRs';
% models(19).yvar = visVar;
% models(19).formula = sprintf('%s ~ %s + %s', visVar, ageVar, trVar);
% 
% models(20).name = 'Places_ages&TRs';
% models(20).yvar = placeVar;
% models(20).formula = sprintf('%s ~ %s + %s', placeVar, ageVar, trVar);
% 
% models(21).name = 'Faces_age&TRs';
% models(21).yvar = faceVar;
% models(21).formula = sprintf('%s ~ %s + %s', faceVar, ageVar, trVar);
% 

lme = cell(1, numel(models));
for i = 1:numel(models)
    lme{i} = fitlme(T, models(i).formula);  % fitlme as requested
end

%% ---- Save full results + stats to a text file ----
outTxt = fullfile(pwd, [ erase(csvPath,'.csv') '_lme_results.txt']);
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

fclose(fid);
fprintf('Saved LME outputs to: %s\n', outTxt);


%% ---- Plotting settings ----
ageVals = T.(ageVar);
snrVals = T.(snrVar);
cmap = plasma(256);
snrMin = min(snrVals);
snrMax = max(snrVals);
snrIdx = 1 + round(255 * (snrVals - snrMin) ./ max(eps, (snrMax - snrMin)));
snrIdx = max(1, min(256, snrIdx));
snrIdx = 1 + round(255 * (snrVals - snrMin) ./ max(eps, (snrMax - snrMin)));
snrIdx = max(1, min(256, snrIdx));
ptColors = cmap(snrIdx, :);

meanAge = mean(T.(ageVar), 'omitnan');
meanSNR = mean(T.(snrVar), 'omitnan');

alphaCI  = 0.05;  % 95% CI
alphaSig = 0.05;  % significance threshold for drawing regression + CI
markerSize=150;

%% 
% One figure with 3 panels (Visual/Faces/Places), same age color-coding as above.
% Faces + Places panels share the same y-axis limits.

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

fSum = figure('Name', 'Summary_Tvals_vs_Age', 'Color', 'w','Units','normalized','Position',[ 0 0 .8 1]);
tlSum = tiledlayout(fSum, 1, 3, 'Padding', 'compact', 'TileSpacing', 'compact');

for j = 1:numel(models)
    yvar = models(j).yvar;

    % Determine whether AGE is significant for this model (for line/CI gating)
    coefTbl = lme{j}.Coefficients;
    coefNames = string(coefTbl.Name);
    namesCell = cellstr(coefTbl.Name);
    pVals = coefTbl.pValue;
    pAge = NaN;
    
    % idxAge = find(coefNames == string(ageVar), 1, 'first');
    % if ~isempty(idxAge), pAge = pVals(idxAge); end

     % AGE term (robust match: exact, then contains; case-insensitive)
    idxAge = find(strcmpi(namesCell, ageVar), 1, 'first');
    if isempty(idxAge)
        idxAge = find(contains(lower(string(namesCell)), lower(string(ageVar))), 1, 'first');
    end
    if ~isempty(idxAge), pAge = pVals(idxAge); end

    % tSNR term (robust match: exact, then contains; case-insensitive)
    idxSNR = find(strcmpi(namesCell, snrVar), 1, 'first');
    if isempty(idxSNR)
        idxSNR = find(contains(lower(string(namesCell)), lower(string(snrVar))), 1, 'first');
    end
    if ~isempty(idxSNR), pSNR = pVals(idxSNR); end

    idxMotion = find(strcmpi(namesCell, motionVar), 1, 'first')
    if isempty(idxMotion)
        idxMotion = find(contains(lower(string(namesCell)), lower(string(motionVar))), 1, 'first');
    end
    if ~isempty(idxMotion), pMotion = pVals(idxMotion); end

    % 
    % idxTR = find(strcmpi(namesCell,  trVar), 1, 'first');
    % if isempty(idxTR)
    %     idxTR = find(contains(lower(string(namesCell)), lower(string(TRVar))), 1, 'first');
    % end
    % if ~isempty(idxTR), pTR = pVals(idxTR); end

    ageIsSig = ~isnan(pAge) && (pAge < alphaSig);
    ax = nexttile(tlSum, j);
    hold(ax, 'on');

    scatter(ax, T.(ageVar), T.(yvar), markerSize, ptColors, 'filled', ...
        'MarkerFaceAlpha', 0.85, 'MarkerEdgeAlpha', 0.0);

    % Plot regression + CI only if AGE is significant (consistent with main figs)
    if ageIsSig
        xAge = linspace(min(T.(ageVar)), max(T.(ageVar)), 200)';
        newTbl = T(1, :);
        newTbl = repmat(newTbl, numel(xAge), 1);
        newTbl.(ageVar) = xAge;
        newTbl.(snrVar) = repmat(meanSNR, numel(xAge), 1);

        [yhat, yci] = predict(lme{j}, newTbl, 'Alpha', alphaCI, 'Conditional', false);
        plotCI(ax, xAge, yci, [0.5 0.5 0.5], 0.25);
        plot(ax, xAge, yhat, 'k-', 'LineWidth', 2);
       yline(0, 'k-', 'LineWidth', 1);
    end

    xlabel(ax, 'Age [Years]', 'Interpreter', 'none');
    ylabel(ax, 'T-value', 'Interpreter', 'none');
     set(gca,'FontName','Helvetica','FontSize',32,'FontWeight','normal')
     %  title(ax, sprintf('\n p(age)=%.3g\n', ...
     % pAge), 'Interpreter', 'none',...
     % 'FontName','Helvetica','FontSize',24,'FontWeight','normal');
     %  % 
     title(ax, sprintf('%s \n p(age)=%.3g\n p(tSNR)=%.3g \n p(Motion)=%.3g \n ', ...
          models(j).name, pAge, pSNR, pMotion), 'Interpreter', 'none',...
         'FontName','Avenir','FontSize',14,'FontWeight','normal');
  
    colormap(ax, cmap);
    caxis(ax, [snrMin snrMax]);

    % Enforce shared y-limits for Faces and Places panels (j=2,3)
    if (j == 2 || j == 3) && ~isnan(yFPmin) && ~isnan(yFPmax)
        ylim(ax, [yFPmin yFPmax]);
    else
        %ylim(ax, [yFPmin  max(T.(visVar))]);
    end

end
cb = colorbar(nexttile(tlSum, 3));
cb.Label.String = 'TSNR';
% Export summary figure as 600 dpi PNG
outPngSum = fullfile(pwd, sprintf('Fig_Summary_Tvals_vs_Age_tSNR_motion_TRs_%s.png', datestr(now,'yyyymmdd')));
exportgraphics(fSum, outPngSum, 'Resolution', 600);
fprintf('Saved summary figure: %s\n', outPngSum);

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

