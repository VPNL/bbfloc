function [meanMapval, voxelSigStd,voxeltSNR, meanMapvalBlank,voxelSigStdBlank,voxeltSNRvsBlank,tSNR]= calc_tSNR_roi(expDir, sessions,roi,dt,scan,sfx, view, blankOffsetTR,blankWindowTR)
%%e.g. for kids: [KmeanMapval, KvoxelSigStd,KvoxeltSNR, KmeanMapvalBlank,KvoxelSigStdBlank,KvoxeltSNRvsBlank,KtSNR]= calc_tSNR_roi(expDir, kid.sessions,roi,kid.dt,kid.scan,['Kid_' prefix]);

% [tSNR,voxeltSNR,meanMapval, voxeltSNRvsBlank]= tSNR_roi(sessions,roi,dt,scan,[sfx], [view], [blankOffsetTR],[blankWindowTR])
% calculates the tSNR across an ROI
% Outputs:
% tSNR first computes ROI mean time course (meantc), then tSNR=mean(meantc)/std(meantc)
%   
% meanMapval is the ROI average meanMap value
%
% Inputs:
% Expdir
% sessions: cell array
% roi: cell array of roi names
% dt data type; default=1; original data type
% scan number in dt; defaut=1;
% [sfx] suffix for log fiLe, e.g. group indicator;  default=[];
% [view] 'i' inplane otherwise gray; Default = inplane
% [blankOffsetTR] offset in units of TR from the beginning of each blank to allow hemodynamic signal to settle ; default: 2TR
% [blankWindowTR] time window for blank block in units of TR
% kgs 5/10
% vsn 02/26

% setting defaults & readining inputs
if notDefined('expDir')
    fprintf(1,'ERROR: Expdir not specified');
    return
end
if notDefined('roi')
    fprintf(1,'ERROR:No ROI name specified');
    return
end
if notDefined('sessions')
    fprintf(1,'ERROR:No Session specified (subjInit_date');
    return
end
if notDefined('dt')
    fprintf(1,'Warning :No Datatype specified setting dt=1');
    dt=1;
end
if notDefined ('scan')
    fprintf(1,'Warning, setting scan to 1\n');
    scan = [1];
end
if notDefined('sfx')
    sfx=[];
end

if notDefined('view')
    fprintf(1,'Warning, setting view to inplane\n');
    view='i'
end

if notDefined ('blankOffsetTR')
    fprintf(1,'Warning, setting blankOffsetTR = 3 \n');
    blankOffsetTR=2;
end
if notDefined ('blankWindowTR')
    fprintf(1,'Warning, setting blankWindowTR = 3 \n');
    blankWindowTR=4;
end
dateAndTime=datestr(now,'mmddyy');
logfile=fullfile(expDir, 'Results', 'tSNR', [ sfx, '_tSNR_' dateAndTime  '.txt']);
outfile=fullfile(expDir, 'Results', 'tSNR', [ sfx, '_tSNR_' dateAndTime  '.mat']);

%[fid, err]=fopen(logfile, 'w');

%if fid <0
%    error('error cannot open file: %s....\n', err);
%end

nsbj=length(sessions);
% params is a struct in which i set the following fields; we want the
% raw tc signal, so we are taking out the detrending and the normalization;
% if you plot(subjectTcs.wholeTc), then the resulting plot should contain
% numbers in the thousands (i.e. raw scanner units); if it doesn't, then
% reset params to include raw scanner units:
%
% params.dataType=dt;
% params.scan=scan;
% params.studyDir=expDir;
tSNR=NaN(nsbj,length(roi)); voxeltSNR=NaN(nsbj,length(roi));
meanMapval=NaN(nsbj,length(roi)); voxeltSNRvsBlank=NaN(nsbj,length(roi));
gender=NaN(nsbj,1); background=NaN(nsbj,1);


for sbj=1:nsbj

    fprintf('*** Session 1 *** \n', sessions{sbj});
    sbj
    cd( fullfile(expDir, sessions{sbj}));
    %load behav.mat
    %if exist (behav.info.gender)
    %    gender(sbj)=behav.info.gender;
    %end

    % initialize hidden inplane & gray

    if view=='i'
        % intialize inplane
        hI=initHiddenInplane(dt(sbj),scan(sbj));
    else
        hI=initHiddenGray(dt(sbj),scan(sbj));
    end

    % get params
    params = er_getParams(hI);
    % we need to set the following params to zeros to get the raw time
    % course instead of % signal change
    params.normBsl=0;
    params.inhomoCorrect=0;
    params.detrend=0;
    er_setParams(hI,params,scan(sbj),dt(sbj));
    params=er_getParams(hI);
    % get tSNR if roi is found

    %     % calculate the mean response of background ROI if exists
    %     [hI, okbackground] = loadROI(hI, 'background')
    %     if okbackground
    %         [data,saveFile]= er_voxelData(hI,'background',scan(sbj),1);
    %         meanbackground=mean(mean(data.tSeries,2));
    %         background(sbj)=meanbackground;
    %     end
   
    for j=1:length(roi)
        j
        roi{j}
      %  keyboard
        [hI, ok] = loadROI(hI, roi{j})
        if ok
            recomputeFlag=1;
            [data,saveFile]= er_voxelData(hI,roi{j},scan(sbj),recomputeFlag);
            %figure; plot(data.tSeries)

            % mean ROI TC tSNR
            meantc=mean(data.tSeries,2);
            tSNR(sbj,j)=mean(meantc)/std(meantc);
            meanMapval(sbj,j)=mean(meantc);

            % calculate stDev on each voxel
            %estimate fluction of time series per voxel & average across the roi
            voxelSigStd(sbj,j) = mean(std(data.tSeries));

            % calculate tSNR on each voxel and then average across voxels
            % in the roi
            voxeltSNR(sbj,j)=mean(mean(data.tSeries)./std(data.tSeries));

            % calculate the voxel tSNR relative to the blank intervals
            blanks=find(data.trials.cond==0);
            onsetblanks=data.trials.onsetSecs(blanks)/data.trials.TR;
            blankindex=[];
            for b=1:length(blanks)-1 % exclude last blank in case time window will extend beyond parfile
                blankindex=[blankindex  onsetblanks(b)+blankOffsetTR:onsetblanks(b)+blankWindowTR];
            end
            
            blanksdata=data.tSeries(blankindex,:);
            meanMapvalBlank(sbj,j)= mean(mean(blanksdata));
            voxelSigStdBlank(sbj,j)= mean(std(blanksdata));
            voxeltSNRvsBlank(sbj,j)=mean(mean(blanksdata)./std(blanksdata));
          

            msg= sprintf('%s mean Map = %6.0f  tSNR = %5.2f  voxel tSNR = %5.2f', roi{j}, meanMapval(sbj,j), tSNR(sbj,j),voxeltSNR(sbj,j));
            disp(msg)

        end
    end
    % return params to defaults (%signal);
    params.normBsl=1;
    params.inhomoCorrect=1;
    params.detrend=1;
    er_setParams(hI,params,scan(sbj),dt(sbj));
    % params=er_getParams(hI);



end

% write to file
%fprintf(fid, '\n ROI \t session \t  \t  MeanMap    ROI tSNR  voxel tSNR   voxel tSNR vs blank  \n \n');

%for j=1:length(roi)
%    for sbj=1:nsbj
%        fprintf(fid, '%s  %s  %6d  %5.2f  %5.2f  %5.2f \n', roi{j}, sessions{sbj}, round(meanMapval(sbj,j)), voxelSigStd(sbj,j), voxeltSNR(sbj,j), meanMapvalBlank(sbj,j), voxelSigStdBlank(sbj,j), voxeltSNRvsBlank(sbj,j));
%    end
%    fprintf(fid, '\n \n');
%end
%fclose(fid)

% command=['save ' outfile ' tSNR'];
% eval(command)
