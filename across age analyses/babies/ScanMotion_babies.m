function [QA]= ScanMotion_babies(sub, ref_scan, motioncomp, exclude_scans)
% function [QA]= ScanMotion('AR06_101013', 1, 'MotionComp_RefScan1', [2,5])
% sub= subj name e.g., 'AR06_101013'
% ref_scan = the scan number that was run first, use as reference scan
% motioncomp = name of the directory that holds the between motion corrected data
% exclude_scans = array of scan numbers to exclude from QA (e.g., [2, 5])
%
% VN 06/14
% 
if nargin < 4
    exclude_scans = [];
end

fmriDir='/share/kalanit/biac2/kgs/projects/Longitudinal/FMRI/FaceMorph/code/MotionChecks';
addpath(fmriDir);

subjDir= strcat('/share/kalanit/biac2/kgs/projects/bb2adult/data/babies/',sub);
QA.dateAndTime=datestr(now,'mmddyy');
cd(subjDir);
clear dataTYPES mrSESSION vANATOMYPATH HOMEDIR hI newDt newScan
if exist('mrSESSION.mat')
     load mrSESSION.mat
end

      theDT=find(strcmp({dataTYPES.name},'MotionComp'));
       cd Images;
       fig= 'Within_Scan_Motion_Est.fig';
       motion= motionCompExtractDataFromFig(fig);
       numscans= size(motion,2);
       cd ../

         % WITHIN SCAN MOTION CHECK
                avgRotation=[];
                avgTranslation=[];
                avgTotal=[];
                
                for i=1:numscans
                  QA.scan(i).scan_name= dataTYPES(theDT).scanParams(i).annotation;
                  QA.scan(i).MotionWithinRotAvg=mean(motion(i).rotation(8:end));
                  QA.scan(i).MotionWithinTransAvg=mean(motion(i).translation(8:end));
                  QA.scan(i).MotionWithinTotalAvg=mean(motion(i).total(8:end));
                  
                  QA.scan(i).MotionWithinRotStd=std(motion(i).rotation(8:end));
                  QA.scan(i).MotionWithinTransStd=std(motion(i).translation(8:end));
                  QA.scan(i).MotionWithinTotalStd=std(motion(i).total(8:end));
                  
                  % Only include in summary stats if not excluded
                  if ~ismember(i, exclude_scans)
                      avgRotation(end+1)=mean(motion(i).rotation(8:end));
                      avgTranslation(end+1)=mean(motion(i).translation(8:end));
                      avgTotal(end+1)=mean(motion(i).total(8:end));
                  end
                end 
                             
                  QA.MotionWithinRotationAvg=mean(avgRotation);
                  QA.MotionWithinTranslationAvg=mean(avgTranslation);
                  QA.MotionWithinTotalAvg=mean(avgTotal);
                              
                  QA.MotionWithinRotationStd=std(avgRotation);
                  QA.MotionWithinTranslationStd=std(avgTranslation);
                  QA.MotionWithinTotalStd=std(avgTotal);
                
        %%% BETWEEN SCAN MOTION CHECK
        % theDT=find(strcmp({dataTYPES.name},motioncomp));
        % btwScanMot=fullfile('Inplane',motioncomp, 'ScanMotionCompParams.mat');
        %     if exist(btwScanMot)
        %         btwScanMot=open(btwScanMot);
        %     end    
        %         view = initHiddenInplane;
        %         rot=[];
        %         trans=[];
        %         total=[];
        %         for iScan=1:numscans
        %             iScan
        %             motMat=btwScanMot.M(:, :, iScan);
        %             dims = sliceDims(view,iScan);
        %             slices = sliceList(view,iScan);
        %             nSlices = length(slices);
        %             midX = [dims/2 nSlices/2]';
        %             midXp = motMat(1:3, 1:3) * midX; 
        %             rotMot = sqrt(sum((midXp - midX).^2));
        %             transMot = sqrt(sum(motMat(1:3, 4).^2));
        %             totalMot = sqrt(rotMot^2 + transMot^2);
        % 
        %              % QA.scan(iScan).MotionBetweenRotation=rotMot;
        %              % QA.scan(iScan).MotionBetweenTranslation=transMot;
        %              % QA.scan(iScan).MotionBetweenTotal=totalMot;
        %              % 
        %              % Only include in summary stats if not excluded or ref scan
        %              if ~ismember(iScan, exclude_scans) && iScan ~= ref_scan
        %                 rot(end+1)=rotMot;
        %                 trans(end+1)=transMot;
        %                 total(end+1)=totalMot;
        %              end
        %         end
        % 
        %         % Clear fields for ref_scan and excluded scans
        %         QA.scan(ref_scan).MotionBetweenRotation=[];
        %         QA.scan(ref_scan).MotionBetweenTranslation=[];
        %         QA.scan(ref_scan).MotionBetweenTotal=[];
        % 
        %         for i=1:length(exclude_scans)
        %             if exclude_scans(i) ~= ref_scan
        %                 QA.scan(exclude_scans(i)).MotionBetweenRotation=[];
        %                 QA.scan(exclude_scans(i)).MotionBetweenTranslation=[];
        %                 QA.scan(exclude_scans(i)).MotionBetweenTotal=[];
        %             end
        %         end
        % 
        %         QA.MotionBetweenRotationAvg=mean(rot);
        %         QA.MotionBetweenTraslationAvg=mean(trans);
        %         QA.MotionBetweenTotalAvg=mean(total);
        % 
        %         QA.MotionBetweenRotationStd=std(rot);
        %         QA.MotionBetweenTraslationStd=std(trans);
        %         QA.MotionBetweenTotalStd=std(total);
                
              save QA QA; cd ..;

% 
% %% original code
% ScanMotion_babies(sub, ref_scan, motioncomp)
% fmriDir='/share/kalanit/biac2/kgs/projects/Longitudinal/FMRI/FaceMorph/code/MotionChecks';
% addpath(fmriDir);
% 
% subjDir= strcat('/share/kalanit/biac2/kgs/projects/bb2adult/data/babies/',sub);
% %Create and open a text file for iling subject results
% QA.dateAndTime=datestr(now,'mmddyy');
% cd(subjDir);
% %if ~isdir('QA_motion'), mkdir('QA_motion'), end;
% clear dataTYPES mrSESSION vANATOMYPATH HOMEDIR hI newDt newScan
% if exist('mrSESSION.mat')
%      load mrSESSION.mat
% end
% 
%       theDT=find(strcmp({dataTYPES.name},'MotionComp'));
%        cd Images;
%        fig= 'Within_Scan_Motion_Est.fig';
%        motion= motionCompExtractDataFromFig(fig);
%        numscans= size(motion,2);
%        cd ../
%          % WITHIN SCAN MOTION CHECK : calculate the rotation translation per scan. and average across all scans. 
%                 for i=1:numscans
%                   QA.scan(i).scan_name= dataTYPES(theDT).scanParams(i).annotation;
%                   QA.scan(i).MotionWithinRotAvg=mean(motion(i).rotation(8:end));
%                   QA.scan(i).MotionWithinTransAvg=mean(motion(i).translation(8:end));
%                   QA.scan(i).MotionWithinTotalAvg=mean(motion(i).total(8:end));
% 
%                   QA.scan(i).MotionWithinRotStd=std(motion(i).rotation(8:end));
%                   QA.scan(i).MotionWithinTransStd=std(motion(i).translation(8:end));
%                   QA.scan(i).MotionWithinTotalStd=std(motion(i).total(8:end));
% 
%                   avgRotation(i)=mean(motion(i).rotation(8:end));
%                   avgTranslation(i)=mean(motion(i).translation(8:end));
%                   avgTotal(i)=mean(motion(i).total(8:end));         
%                 end 
% 
%                   QA.MotionWithinRotationAvg=mean(avgRotation);
%                   QA.MotionWithinTranslationAvg=mean(avgTranslation);
%                   QA.MotionWithinTotalAvg=mean(avgTotal);
% 
%                   QA.MotionWithinRotationStd=std(avgRotation);
%                   QA.MotionWithinTranslationStd=std(avgTranslation);
%                   QA.MotionWithinTotalStd=std(avgTotal);
%                 %%%if QA.Total =;;;
% 
% 
% 
%         %%% BETWEEN SCAN MOTION CHECK
% 
%             % Find the correct DT
%         theDT=find(strcmp({dataTYPES.name},motioncomp));
%         btwScanMot=fullfile('Inplane',motioncomp, 'ScanMotionCompParams.mat');
%             % Calculate the motion
%             if exist(btwScanMot)
%                 btwScanMot=open(btwScanMot);
%             end    
%                 % Get or compute Mean Maps.
%                 view = initHiddenInplane;
%                 rot=[];
%                 trans=[];
%                 total=[];
%                 for iScan=1:numscans%length(scanNames)
%                     iScan
% 
%                     motMat=btwScanMot.M(:, :, iScan);
%                     dims = sliceDims(view,iScan);
%                     slices = sliceList(view,iScan);
%                     nSlices = length(slices);
%                     midX = [dims/2 nSlices/2]';
%                     midXp = motMat(1:3, 1:3) * midX; 
%                     rotMot = sqrt(sum((midXp - midX).^2));% Rotational motion
%                     transMot = sqrt(sum(motMat(1:3, 4).^2)); % Translational motion
%                     totalMot = sqrt(rotMot^2 + transMot^2); % Total Motion
%                      QA.scan(iScan).MotionBetweenRotation=rotMot;
%                      QA.scan(iScan).MotionBetweenTranslation=transMot;
%                      QA.scan(iScan).MotionBetweenTotal=totalMot;
% 
%                         rot=[rot rotMot];
%                         trans=[trans transMot]
%                         total=[total totalMot]
%                     end
%                      QA.scan(ref_scan).MotionBetweenRotation=[];
%                      QA.scan(ref_scan).MotionBetweenTranslation=[];
%                      QA.scan(ref_scan).MotionBetweenTotal=[];
%                         rot(ref_scan)=[];
%                         trans(ref_scan)=[];
%                         total(ref_scan)=[];
% 
% 
%                 QA.MotionBetweenRotationAvg=mean(rot);
%                 QA.MotionBetweenTraslationAvg=mean(trans);
%                 QA.MotionBetweenTotalAvg=mean(total);
% 
%                QA.MotionBetweenRotationStd=std(rot);
%                 QA.MotionBetweenTraslationStd=std(trans);
%                 QA.MotionBetweenTotalStd=std(total);
% 
% 
% 
%  %             cd QA_motion;
%               save QA QA; cd ..; 
% 
                
             
