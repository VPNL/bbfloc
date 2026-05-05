function []=wrapper_mrVistaROI2niftiROI_discs_babies()
%% this code converts the mrvista disc rois in to the freeSurfer nifti
addpath('/share/kalanit/biac2/kgs/projects/CBA/Code/niftiCode/')
Vistasessions ={'bb98_mri4', 'bb108_mri5', 'bb110_mri6', 'bb119_mri6', 'bb125_mri6', 'bb130_mri5', 'bb124_mri4'}


baby ={'bb98', 'bb108', 'bb110', 'bb119', 'bb125', 'bb130', 'bb124'};
sess = {'mri4', 'mri5', 'mri6', 'mri5', 'mri4', 'mri5', 'mri4'};
anatomies = {'T1.nii.gz', 'T2.nii.gz', 'T1.nii.gz', 'T1.nii.gz', 'T1.nii.gz','T1.nii.gz', 'T1.nii.gz'}; %{} %fix
mrVistaDir='/share/kalanit/biac2/kgs/projects/bb2adult/data/babies/';
anatdir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/babybrains/mri';
%% for the babies

for i = 3%:length(Vistasessions)
    roiDir = [mrVistaDir, Vistasessions{i}, '/3DAnatomy/ROIs/'];
    matFiles = dir(fullfile(roiDir, '*mat'));

    if isempty(matFiles) 
	    fprintf('No .mat files found for %s, skipping.\n', Vistasessions{i}); 
	    continue 
    end 

    for r=1:length(matFiles) roiName = {matFiles(r).name};
	     fprintf('Converting %s for subject %s\n', roiName{1},Vistasessions{i}); 
	     mrVistaROI2niftiROI([mrVistaDir, Vistasessions{i}], roiName, anatomies{i}, '3DAnatomy', roiDir);
    end 
end

for i = 3%1:length(Vistasessions) 
	roiDir = [mrVistaDir, Vistasessions{i},'/3DAnatomy/ROIs/']; 
	% Find all .nii.gz ROI files 
	niiFiles = dir(fullfile(roiDir, '*.nii.gz'));
	if isempty(niiFiles) 
		fprintf('No .nii.gz files found for %s, skipping.\n', Vistasessions{i}); 
		continue 
	end 
	cd(roiDir); 
	for r = 1:length(niiFiles) 
		niiName =niiFiles(r).name;
		refVol  = [anatdir, '/', baby{i}, '/', sess{i}, '/preprocessed_aligned/MRF/T1map_aligned_1mm.nii.gz']; 
		if isfile(niiName) && isfile(refVol) 
            command = ['mri_convert ', niiName, ' ', niiName, ' -rl ', refVol]; 
		    fprintf('Running: %s\n',command);
		    unix(command); 
        else 
            fprintf('Skipping %s — file or reference volume not found.\n', niiName); 
		end
 	end
end 


 


% %% you might need to add the CBA/freesurfer in bashrc to get vol2label which is needed for converting vol to labels
% %gedit .bashrc
% % source .bashrc
% 
% cd /sni-storage/kalanit/biac2/kgs/projects/Sulcalpits/code
% addpath(pwd)
% subj = {'ZCM05_T1w1_final_edited' 'MEC05_T1w1_Final2_edited' 'DJM06_edited' 'RHSA06_T1w1_final_edited' 'INW06_final_edited' 'AlS07_edited' 'SDS07_T1w1_final_edited' 'SM08_edited' 'MDT09_T1w1_final_edited' 'LEE09_T1w1_final_edited' 'GEJA09_T1w1_final_edited' 'DAPA10_final_edited' 'AG10_T1w1_final_edited' 'STM10_T1w1_final_edited' 'SERA10_T1w1_final_edited' 'KW10_edited' 'NW10_edited' 'RJM10_edited' 'AyS10' 'CGSA11_final' 'MFC11_final_edited' 'JTE11_T1w1_final_edited' 'JDB11_edited' 'LL11' 'CS11' 'OS12_fixed'} 
% roiList ={'rh_PPA_Placeshouses.nii.gz' , 'rh_PPA_Placeshouses.nii.gz'}
% convert_mrvistavol_label(subj, roiList){'AG10_T1w1_final_edited'  }
 
% 
% %% tksurfer anthony_avg_1mm rh inflated -curv rh.curv
% %% load curvature%
% %% configure curvature display
% 
% 
% % Notes:
% % 
% % 1. first convert every subjects ROIs.mat files into niftis using wrapper_mrvistarois2niftiroi function in this directory.
% % 2. then create the label files using convert_mrvistavol_labelbkpf
% % 3. then open tksurfer a see the label. you will have to fill and dilate a label a little to mget rid of the holes and kinks.
% % 
% % what i did:
% % fill holes
% % dilate-2 times
% % erode-2 times
% % fill holes
% % 
% % 4. save the label as a new label. 
% 
% %%% labeltolabel
% %%% subject label to fsaverage label
% % %% go to individual sujbect label folder to do this
% count_l =1;
% count_r=1;
% sessions = {'ZCM05_T1w1_final_edited' 'MEC05_T1w1_Final2_edited' 'DJM06_edited' 'RHSA06_T1w1_final_edited' 'INW06_final_edited' 'AlS07_edited' 'SDS07_T1w1_final_edited' 'SM08_edited' 'MDT09_T1w1_final_edited' 'LEE09_T1w1_final_edited' 'GEJA09_T1w1_final_edited' 'DAPA10_final_edited' 'AG10_T1w1_final_edited' 'STM10_T1w1_final_edited' 'SERA10_T1w1_final_edited' 'KW10_edited' 'NW10_edited' 'RJM10_edited' 'AyS10' 'CGSA11_final' 'MFC11_final_edited' 'JTE11_T1w1_final_edited' 'JDB11_edited' 'LL11' 'CS11' 'OS12_fixed'} 
% for i=1:length(sessions)
%   cd(['/sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/', sessions{i}, '/label'])
%   if exist('rh_PPA_Placeshouses_new.label','file')
%   command =['mri_label2label --srclabel rh_PPA_Placeshouses_new.label --srcsubject ', sessions{i} ,' --trglabel ',sessions{i},'_rh_PPA_Placeshouses_vn.label --trgsubject fsaverage-bkup --regmethod surface --hemi rh']
%   unix(command);
%   end
%   if exist('rh_PPA_Placeshouses_new.label','file')
%   command =['mri_label2label --srclabel rh_PPA_Placeshouses_new.label --srcsubject ', sessions{i} ,' --trglabel ',sessions{i},'_rh_PPA_Placeshouses_vn.label --trgsubject fsaverage-bkup --regmethod surface --hemi rh']
%   unix(command);
%   end
% end 
% 
% 
% %% labe to vol
% sessions = {'ZCM05_T1w1_final_edited' 'MEC05_T1w1_Final2_edited' 'DJM06_edited' 'RHSA06_T1w1_final_edited' 'INW06_final_edited' 'AlS07_edited' 'SDS07_T1w1_final_edited' 'SM08_edited' 'MDT09_T1w1_final_edited' 'LEE09_T1w1_final_edited' 'GEJA09_T1w1_final_edited' 'DAPA10_final_edited' 'AG10_T1w1_final_edited' 'STM10_T1w1_final_edited' 'SERA10_T1w1_final_edited' 'KW10_edited' 'NW10_edited' 'RJM10_edited' 'AyS10' 'CGSA11_final' 'MFC11_final_edited' 'JTE11_T1w1_final_edited' 'JDB11_edited' 'LL11' 'CS11' 'OS12_fixed'} 
% for i=1:length(sessions)
%       cd(['/sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/', sessions{i}, '/label'])
% 
%   if exist('rh_PPA_Placeshouses_new.label','file')
%   command =['mri_label2vol --label /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/', sessions{i},'_rh_PPA_Placeshouses_vn.label --temp /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri/orig.mgz --subject fsaverage-bkup --hemi rh --o  /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri/subj', num2str(count_l),'_rh_PPA_Placeshouses_label_vn.nii.gz  --fillthresh .5 --reg /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/register.dat']
%   unix(command); 
%   count_l=count_l+1
%   end
%  if exist('rh_PPA_Placeshouses_new.label','file')
%   command =['mri_label2vol --label /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/', sessions{i},'_rh_PPA_Placeshouses_vn.label --temp /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri/orig.mgz --subject fsaverage-bkup --hemi rh --o  /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri/subj', num2str(count_r),'_rh_PPA_Placeshouses_label_vn.nii.gz  --fillthresh .5 --reg /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/register.dat']
%   unix(command);
%   count_r=count_r+1
% end
% end
%   cd /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri;
% 
% %% add all files 
% tempdata = int32(zeros(1, 256* 256* 256));
% for i=1:26 %% changes with number of subjects
%     i
%     file = ['subj', num2str(i), '_rh_PPA_Placeshouses_label_vn.nii.gz']
%     tempfile = readFileNifti(file);
%     size(tempfile.data)
%     data = reshape(tempfile.data ,1 , 256*256*256);
%     tempdata = tempdata+data;
% end
% %% number of subject  (26 currently)
% tempdata = reshape(tempdata, 256, 256, 256); %/12; %% number of subjecct
% tempfile.data = double(tempdata)/26;
% tempfile.data(tempfile.data<=.3)=0;
% tempfile.fname = 'rh.Prob_PPA_Placeshouses_roi_forCT_vn.nii.gz';
% writeFileNifti(tempfile)
% 
% %% add all files 
% tempdata = int32(zeros(1, 256* 256* 256));
% for i=1:26 %% changes with number of subjects
%     i
%     file = ['subj', num2str(i), '_rh_PPA_Placeshouses_label_vn.nii.gz']
%     tempfile = readFileNifti(file);
%     size(tempfile.data)
%     data = reshape(tempfile.data ,1 , 256*256*256);
%     tempdata = tempdata+data;
% end
% %% number of subject  (26 currently)
% tempdata = reshape(tempdata, 256, 256, 256); %/12; %% number of subjecct
% tempfile.data = double(tempdata)/26;
% tempfile.data(tempfile.data<=.3)=0;
% tempfile.fname = 'rh.Prob_PPA_Placeshouses_roi_forCT_vn.nii.gz';
% writeFileNifti(tempfile)
% 
% %% convert nifti to surf % rh
% !mri_vol2surf --src rh.Prob_PPA_Placeshouses_roi_forCT_vn.nii.gz --out rh.Prob_PPA_Placeshouses_roi_forCT_vn.mgz  --srcreg ../label/register.dat --hemi rh
% !cp rh.Prob_PPA_Placeshouses_roi_forCT_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/label/.
% !cp rh.Prob_PPA_Placeshouses_roi_forCT_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/mgz/.
% 
% %% convert nifti to surf % rh
% !mri_vol2surf --src rh.Prob_PPA_Placeshouses_roi_forCT_vn.nii.gz --out rh.Prob_PPA_Placeshouses_roi_forCT_vn.mgz  --srcreg ../label/register.dat --hemi rh
% !cp rh.Prob_PPA_Placeshouses_roi_forCT_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/label/.
% !cp rh.Prob_PPA_Placeshouses_roi_forCT_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/mgz/.
% 
% %%% now creating a label
% cd /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri;
% %%% for creating a label RIGHT
% tempdata = []
% 
% for i=1:26 %% changes with number of subjects
%     i
%     file = ['subj', num2str(i), '_rh_PPA_Placeshouses_label_vn.nii.gz']
%     tempfile = readFileNifti(file);
%     size(tempfile.data)
%     
%     data = reshape(tempfile.data ,1 , 256*256*256);
%    
%     tempdata = [tempdata; data];
% 
% end
% 
% %% number of subject  (26 currently)
% newtempdata= sum(tempdata);
% newtempdata(newtempdata<8)=0;
% newtempdata(newtempdata>=8)=1;
% newtempdata = reshape(uint8(newtempdata), 256, 256, 256); %/12; %% number of subjecct
% 
% %%%%%%%
% tempfile.data = newtempdata;
% tempfile.fname = 'rh.Prob_forlabel_PPA_Placeshouses_vn.nii.gz';
% writeFileNifti(tempfile)
% !mri_vol2surf --src rh.Prob_forlabel_PPA_Placeshouses_vn.nii.gz --out rh.Prob_forlabel_PPA_Placeshouses_vn.mgz  --srcreg ../label/register.dat --hemi rh
% !cp rh.Prob_forlabel_PPA_Placeshouses_vn.mgz ../label/.
% %% convert prpb  into label
% addpath('/sni-storage/kalanit/biac2/kgs/projects/CBA/Code/labelCode')
% outputdir = ' /biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/';
% inputdir = '/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/';
% areanames = {'Prob_PPA_Placeshouses_kids_vn'}
% areaID = [1];
% mgzfiles = {'rh.Prob_forlabel_PPA_Placeshouses_vn.mgz'};
% hemisphere = {'rh' }
% subjectname = 'fsaverage-bkup';
% surfacetype = 'inflated';
% mgz2label(mgzfiles{1},hemisphere{1},areaID,areanames,inputdir,outputdir,subjectname,surfacetype)
% 
% cd ../label/.
% !freeview -f ../surf/rh.inflated
% !cp rh.Prob_PPA_Placeshouses_kids_vn.label CBA//fROIs/averages/label/.
% %%%% LEFT
% cd /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri;
% tempdata = []
% 
% for i=1:26 %% changes with number of subjects
%     i
%     file = ['subj', num2str(i), '_rh_PPA_Placeshouses_label_vn.nii.gz']
%     tempfile = readFileNifti(file);
%     size(tempfile.data)
%     
%     data = reshape(tempfile.data ,1 , 256*256*256);
%    
%     tempdata = [tempdata; data];
% 
% end
% 
% 
% %% number of subject  (17 currently)
% newtempdata= sum(tempdata);
% newtempdata(newtempdata<8)=0;
% newtempdata(newtempdata>=8)=1;
% newtempdata = reshape(uint8(newtempdata), 256, 256, 256); %/12; %% number of subjecct
% 
% %%%%%%%
% tempfile.data = newtempdata;
% tempfile.fname = 'rh.Prob_forlabel_PPA_Placeshouses_vn.nii.gz';
% writeFileNifti(tempfile)
% !mri_vol2surf --src rh.Prob_forlabel_PPA_Placeshouses_vn.nii.gz --out rh.Prob_forlabel_PPA_Placeshouses_vn.mgz  --srcreg ../label/register.dat --hemi rh
% !cp rh.Prob_forlabel_PPA_Placeshouses_vn.mgz ../label/.
% %% convert prpb  into label
% addpath('/sni-storage/kalanit/biac2/kgs/projects/CBA/Code/labelCode')
% outputdir = ' /biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/';
% inputdir = '/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/';
% areanames = {'Prob_PPA_Placeshouses_kids_vn'}
% areaID = [1];
% mgzfiles = {'rh.Prob_forlabel_PPA_Placeshouses_vn.mgz'};
% hemisphere = {'rh' }
% subjectname = 'fsaverage-bkup';
% surfacetype = 'inflated';
% mgz2label(mgzfiles{1},hemisphere{1},areaID,areanames,inputdir,outputdir,subjectname,surfacetype)
% 
% cd ../label/.
% !freeview -f ../surf/rh.inflated
% !cp rh.Prob_OWFA_WordsNumbers_vn.label CBA//fROIs/averages/label/.
% 
% 
% %!cp rh.Prob_pfs_roi_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/mgz/.
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% sessions ={'AD25'} 
% 
% %% this step assumes you are done making all the rh_PPA_Placeshouses_new.label files.
% count_l =1;
% count_r=1;
% for i=1:length(sessions)
%   cd(['/sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/', sessions{i}, '/label'])
%   if exist('rh_PPA_Placeshouses_new.label','file')
%   command =['mri_label2label --srclabel rh_PPA_Placeshouses_new.label --srcsubject ', sessions{i} ,' --trglabel ',sessions{i},'_rh_PPA_Placeshouses_vn.label --trgsubject fsaverage-bkup --regmethod surface --hemi rh']
%   unix(command);
%   end
%   if exist('rh_PPA_Placeshouses_new.label','file')
%   command =['mri_label2label --srclabel rh_PPA_Placeshouses_new.label --srcsubject ', sessions{i} ,' --trglabel ',sessions{i},'_rh_PPA_Placeshouses_vn.label --trgsubject fsaverage-bkup --regmethod surface --hemi rh']
%   unix(command);
%   end
% end 
% 
% 
% %% labe to vol
% for i=1:length(sessions)
%       cd(['/sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/', sessions{i}, '/label'])
% 
%   if exist('rh_PPA_Placeshouses_new.label','file')
%   command =['mri_label2vol --label /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/', sessions{i},'_rh_PPA_Placeshouses_vn.label --temp /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri/orig.mgz --subject fsaverage-bkup --hemi rh --o  /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri/Adult_subj', num2str(count_l),'_rh_PPA_Placeshouses_label_vn.nii.gz  --fillthresh .5 --reg /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/register.dat']
%   unix(command); 
%   count_l=count_l+1
%   end
%  if exist('rh_PPA_Placeshouses_new.label','file')
%   command =['mri_label2vol --label /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/', sessions{i},'_rh_PPA_Placeshouses_vn.label --temp /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri/orig.mgz --subject fsaverage-bkup --hemi rh --o  /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri/Adult_subj', num2str(count_r),'_rh_PPA_Placeshouses_label_vn.nii.gz  --fillthresh .5 --reg /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/register.dat']
%   unix(command);
%   count_r=count_r+1
% end
% end
%   cd /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri;
% 
% %% add all files 
% tempdata = int32(zeros(1, 256* 256* 256));
% for i=1:27 %% changes with number of subjects
%     i
%     file = ['Adult_subj', num2str(i), '_rh_PPA_Placeshouses_label_vn.nii.gz']
%     tempfile = readFileNifti(file);
%     size(tempfile.data)
%     data = reshape(tempfile.data ,1 , 256*256*256);
%     tempdata = tempdata+data;
% end
% %% number of subject  (27 currently)
% tempdata = reshape(tempdata, 256, 256, 256); %/12; %% number of subjecct
% tempfile.data = double(tempdata)/27;
% tempfile.data(tempfile.data<=.3)=0;
% tempfile.fname = 'rh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.nii.gz';
% writeFileNifti(tempfile)
% 
% %% add all files 
% tempdata = int32(zeros(1, 256* 256* 256));
% for i=1:27 %% changes with number of subjects
%     i
%     file = ['Adult_subj', num2str(i), '_rh_PPA_Placeshouses_label_vn.nii.gz']
%     tempfile = readFileNifti(file);
%     size(tempfile.data)
%     data = reshape(tempfile.data ,1 , 256*256*256);
%     tempdata = tempdata+data;
% end
% %% number of subject  (27 currently)
% tempdata = reshape(tempdata, 256, 256, 256); %/12; %% number of subjecct
% tempfile.data = double(tempdata)/26;
% tempfile.data(tempfile.data<=.3)=0;
% tempfile.fname = 'rh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.nii.gz';
% writeFileNifti(tempfile)
% 
% %% convert nifti to surf % rh
% !mri_vol2surf --src rh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.nii.gz --out rh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.mgz  --srcreg ../label/register.dat --hemi rh
% !cp rh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/label/.
% !cp rh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/mgz/.
% 
% %% convert nifti to surf % rh
% !mri_vol2surf --src rh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.nii.gz --out rh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.mgz  --srcreg ../label/register.dat --hemi rh
% !cp rh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/label/.
% !cp rh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/mgz/.
% 
% %%% now creating a label
% cd /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri;
% %%% for creating a label RIGHT
% tempdata = []
% 
% for i=1:26 %% changes with number of subjects
%     i
%     file = ['subj', num2str(i), '_rh_PPA_Placeshouses_label_vn.nii.gz']
%     tempfile = readFileNifti(file);
%     size(tempfile.data)
%     
%     data = reshape(tempfile.data ,1 , 256*256*256);
%    
%     tempdata = [tempdata; data];
% 
% end
% 
% %% number of subject  (26 currently)
% newtempdata= sum(tempdata);
% newtempdata(newtempdata<8)=0;
% newtempdata(newtempdata>=8)=1;
% newtempdata = reshape(uint8(newtempdata), 256, 256, 256); %/12; %% number of subjecct
% 
% %%%%%%%
% tempfile.data = newtempdata;
% tempfile.fname = 'rh.Prob_forlabel_PPA_Placeshouses_vn.nii.gz';
% writeFileNifti(tempfile)
% !mri_vol2surf --src rh.Prob_forlabel_PPA_Placeshouses_vn.nii.gz --out rh.Prob_forlabel_PPA_Placeshouses_vn.mgz  --srcreg ../label/register.dat --hemi rh
% !cp rh.Prob_forlabel_PPA_Placeshouses_vn.mgz ../label/.
% %% convert prpb  into label
% addpath('/sni-storage/kalanit/biac2/kgs/projects/CBA/Code/labelCode')
% outputdir = ' /biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/';
% inputdir = '/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/';
% areanames = {'Prob_PPA_Placeshouses_kids_vn'}
% areaID = [1];
% mgzfiles = {'rh.Prob_forlabel_PPA_Placeshouses_vn.mgz'};
% hemisphere = {'rh' }
% subjectname = 'fsaverage-bkup';
% surfacetype = 'inflated';
% mgz2label(mgzfiles{1},hemisphere{1},areaID,areanames,inputdir,outputdir,subjectname,surfacetype)
% 
% cd ../label/.
% !freeview -f ../surf/rh.inflated
% !cp rh.Prob_PPA_Placeshouses_kids_vn.label CBA//fROIs/averages/label/.
% %%%% LEFT
% cd /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri;
% tempdata = []
% 
% for i=1:26 %% changes with number of subjects
%     i
%     file = ['subj', num2str(i), '_rh_PPA_Placeshouses_label_vn.nii.gz']
%     tempfile = readFileNifti(file);
%     size(tempfile.data)
%     
%     data = reshape(tempfile.data ,1 , 256*256*256);
%    
%     tempdata = [tempdata; data];
% 
% end
% 
% 
% %% number of subject  (17 currently)
% newtempdata= sum(tempdata);
% newtempdata(newtempdata<8)=0;
% newtempdata(newtempdata>=8)=1;
% newtempdata = reshape(uint8(newtempdata), 256, 256, 256); %/12; %% number of subjecct
% 
% %%%%%%%
% tempfile.data = newtempdata;
% tempfile.fname = 'rh.Prob_forlabel_PPA_Placeshouses_vn.nii.gz';
% writeFileNifti(tempfile)
% !mri_vol2surf --src rh.Prob_forlabel_PPA_Placeshouses_vn.nii.gz --out rh.Prob_forlabel_PPA_Placeshouses_vn.mgz  --srcreg ../label/register.dat --hemi rh
% !cp rh.Prob_forlabel_PPA_Placeshouses_vn.mgz ../label/.
% %% convert prpb  into label
% addpath('/sni-storage/kalanit/biac2/kgs/projects/CBA/Code/labelCode')
% outputdir = ' /biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/';
% inputdir = '/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/';
% areanames = {'Prob_PPA_Placeshouses_kids_vn'}
% areaID = [1];
% mgzfiles = {'rh.Prob_forlabel_PPA_Placeshouses_vn.mgz'};
% hemisphere = {'rh' }
% subjectname = 'fsaverage-bkup';
% surfacetype = 'inflated';
% mgz2label(mgzfiles{1},hemisphere{1},areaID,areanames,inputdir,outputdir,subjectname,surfacetype)
% 
% cd ../label/.
% !freeview -f ../surf/rh.inflated
% !cp rh.Prob_OWFA_WordsNumbers_vn.label CBA//fROIs/averages/label/.
% 
% 
% %!cp rh.Prob_pfs_roi_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/mgz/.
