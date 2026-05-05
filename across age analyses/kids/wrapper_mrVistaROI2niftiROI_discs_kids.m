function []=wrapper_mrVistaROI2niftiROI_discs_kids()
%% this code converts the mrvista disc rois in to the freeSurfer nifti
addpath('/share/kalanit/biac2/kgs/projects/CBA/Code/niftiCode/')
Vistasessions ={'AG10_07192014'
'AlS07_08152015'
'AM10_04172016'
'AyS10_08152015'
'CGSA11_09072014'
'CLC06_03232015'
'CS11_11052015'
'DAPA10_10042014'
'DJM06_06282015'
'GEJA11_09202015'
'INW06_09212014'
'JDB11_04012015'
'KW10_03152015'
'LL11_07192015'
'MDT09_07262014'
'MEC05_09282014'
'MFC11_08172014'
'NW10_04122015'
'OS12_07292014'
'RHSA06_06292014'
'RJ09_08172015'
'RJM10_04252015'
'SDS07_05112014'
'SERA10_06292014'
'SM08_04172016'
'STM10_05112014'
'ZCM05_07132014'}

  
FSsession_anat={'AG10_T1w1_final_edited'  
    'AlS07_edited'
     'AM10_edited'
    'AyS10'                 
    'CGSA11_final'            
    'CLC06'                   
    'CS11'                    
    'DAPA10_final_edited'     
    'DJM06_edited'            
    'GEJA09_T1w1_final_edited'
    'INW06_final_edited'      
    'JDB11_edited'            
    'KW10_edited'             
    'LL11'                    
    'MDT09_T1w1_final_edited' 
    'MEC05_T1w1_Final2_edited'
    'MFC11_final_edited'      
    'NW10_edited'             
    'OS12_fixed'              
    'RHSA06_T1w1_final_edited'
    'RJ09'                    
    'RJM10_edited'            
    'SDS07_T1w1_final_edited' 
    'SERA10_T1w1_final_edited'
    'SM08_edited'             
    'STM10_T1w1_final_edited' 
    'ZCM05_T1w1_final_edited' }

roiList={'rh_mFus_4mm_disk_CT.mat' 'rh_pFus_4mm_disk_CT.mat', 'rh_V1_4mm_disk_CT.mat','rh_PPA_4mm_disk_CT.mat'};
anatomies = {'T1_QMR_1mm.nii.gz'}
mrVistaDir='/share/kalanit/biac2/kgs/projects/bb2adult/data/kids/'
%% for the kids

for i=1:length(Vistasessions)
    % usung subjects from face morph expt
    for r = 1:length(roiList)
        if isfile([mrVistaDir,Vistasessions{i},'/3DAnatomy/ROIs/',roiList{r}])
            a=roiList(r);
            mrVistaROI2niftiROI([mrVistaDir,Vistasessions{i}], a, anatomies{1}, '3DAnatomy',[mrVistaDir,Vistasessions{i},'/3DAnatomy/ROIs']);
        end
    end
end

roiList={'rh_mFus_4mm_disk_CT' 'rh_pFus_4mm_disk_CT', 'rh_V1_4mm_disk_CT','rh_PPA_4mm_disk_CT'};
FSdir= '/share/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/';
for i=1:length(FSsession_anat)
  for r = 1:length(roiList)
      
        cd([mrVistaDir,Vistasessions{i},'/3DAnatomy/ROIs']);
         if isfile([roiList{r}, '.nii.gz'])
        command =['mri_convert ', roiList{r},'.nii.gz ' , roiList{r},'.nii.gz -rl ' , FSdir, FSsession_anat{i}, '/mri/aseg.mgz -nc'];
        unix(command)
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
% roiList ={'rh_PPA_Placeshouses.nii.gz' , 'lh_PPA_Placeshouses.nii.gz'}
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
%   if exist('lh_PPA_Placeshouses_new.label','file')
%   command =['mri_label2label --srclabel lh_PPA_Placeshouses_new.label --srcsubject ', sessions{i} ,' --trglabel ',sessions{i},'_lh_PPA_Placeshouses_vn.label --trgsubject fsaverage-bkup --regmethod surface --hemi lh']
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
%   if exist('lh_PPA_Placeshouses_new.label','file')
%   command =['mri_label2vol --label /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/', sessions{i},'_lh_PPA_Placeshouses_vn.label --temp /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri/orig.mgz --subject fsaverage-bkup --hemi lh --o  /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri/subj', num2str(count_l),'_lh_PPA_Placeshouses_label_vn.nii.gz  --fillthresh .5 --reg /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/register.dat']
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
%     file = ['subj', num2str(i), '_lh_PPA_Placeshouses_label_vn.nii.gz']
%     tempfile = readFileNifti(file);
%     size(tempfile.data)
%     data = reshape(tempfile.data ,1 , 256*256*256);
%     tempdata = tempdata+data;
% end
% %% number of subject  (26 currently)
% tempdata = reshape(tempdata, 256, 256, 256); %/12; %% number of subjecct
% tempfile.data = double(tempdata)/26;
% tempfile.data(tempfile.data<=.3)=0;
% tempfile.fname = 'lh.Prob_PPA_Placeshouses_roi_forCT_vn.nii.gz';
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
% %% convert nifti to surf % lh
% !mri_vol2surf --src lh.Prob_PPA_Placeshouses_roi_forCT_vn.nii.gz --out lh.Prob_PPA_Placeshouses_roi_forCT_vn.mgz  --srcreg ../label/register.dat --hemi lh
% !cp lh.Prob_PPA_Placeshouses_roi_forCT_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/label/.
% !cp lh.Prob_PPA_Placeshouses_roi_forCT_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/mgz/.
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
%     file = ['subj', num2str(i), '_lh_PPA_Placeshouses_label_vn.nii.gz']
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
% tempfile.fname = 'lh.Prob_forlabel_PPA_Placeshouses_vn.nii.gz';
% writeFileNifti(tempfile)
% !mri_vol2surf --src lh.Prob_forlabel_PPA_Placeshouses_vn.nii.gz --out lh.Prob_forlabel_PPA_Placeshouses_vn.mgz  --srcreg ../label/register.dat --hemi lh
% !cp lh.Prob_forlabel_PPA_Placeshouses_vn.mgz ../label/.
% %% convert prpb  into label
% addpath('/sni-storage/kalanit/biac2/kgs/projects/CBA/Code/labelCode')
% outputdir = ' /biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/';
% inputdir = '/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/';
% areanames = {'Prob_PPA_Placeshouses_kids_vn'}
% areaID = [1];
% mgzfiles = {'lh.Prob_forlabel_PPA_Placeshouses_vn.mgz'};
% hemisphere = {'lh' }
% subjectname = 'fsaverage-bkup';
% surfacetype = 'inflated';
% mgz2label(mgzfiles{1},hemisphere{1},areaID,areanames,inputdir,outputdir,subjectname,surfacetype)
% 
% cd ../label/.
% !freeview -f ../surf/lh.inflated
% !cp lh.Prob_OWFA_WordsNumbers_vn.label CBA//fROIs/averages/label/.
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
% %% this step assumes you are done making all the lh_PPA_Placeshouses_new.label files.
% count_l =1;
% count_r=1;
% for i=1:length(sessions)
%   cd(['/sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/', sessions{i}, '/label'])
%   if exist('lh_PPA_Placeshouses_new.label','file')
%   command =['mri_label2label --srclabel lh_PPA_Placeshouses_new.label --srcsubject ', sessions{i} ,' --trglabel ',sessions{i},'_lh_PPA_Placeshouses_vn.label --trgsubject fsaverage-bkup --regmethod surface --hemi lh']
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
%   if exist('lh_PPA_Placeshouses_new.label','file')
%   command =['mri_label2vol --label /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/', sessions{i},'_lh_PPA_Placeshouses_vn.label --temp /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri/orig.mgz --subject fsaverage-bkup --hemi lh --o  /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/mri/Adult_subj', num2str(count_l),'_lh_PPA_Placeshouses_label_vn.nii.gz  --fillthresh .5 --reg /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/register.dat']
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
%     file = ['Adult_subj', num2str(i), '_lh_PPA_Placeshouses_label_vn.nii.gz']
%     tempfile = readFileNifti(file);
%     size(tempfile.data)
%     data = reshape(tempfile.data ,1 , 256*256*256);
%     tempdata = tempdata+data;
% end
% %% number of subject  (27 currently)
% tempdata = reshape(tempdata, 256, 256, 256); %/12; %% number of subjecct
% tempfile.data = double(tempdata)/27;
% tempfile.data(tempfile.data<=.3)=0;
% tempfile.fname = 'lh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.nii.gz';
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
% %% convert nifti to surf % lh
% !mri_vol2surf --src lh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.nii.gz --out lh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.mgz  --srcreg ../label/register.dat --hemi lh
% !cp lh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/label/.
% !cp lh.Prob_PPA_Placeshouses_roi_forCT_adult_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/mgz/.
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
%     file = ['subj', num2str(i), '_lh_PPA_Placeshouses_label_vn.nii.gz']
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
% tempfile.fname = 'lh.Prob_forlabel_PPA_Placeshouses_vn.nii.gz';
% writeFileNifti(tempfile)
% !mri_vol2surf --src lh.Prob_forlabel_PPA_Placeshouses_vn.nii.gz --out lh.Prob_forlabel_PPA_Placeshouses_vn.mgz  --srcreg ../label/register.dat --hemi lh
% !cp lh.Prob_forlabel_PPA_Placeshouses_vn.mgz ../label/.
% %% convert prpb  into label
% addpath('/sni-storage/kalanit/biac2/kgs/projects/CBA/Code/labelCode')
% outputdir = ' /biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/';
% inputdir = '/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/';
% areanames = {'Prob_PPA_Placeshouses_kids_vn'}
% areaID = [1];
% mgzfiles = {'lh.Prob_forlabel_PPA_Placeshouses_vn.mgz'};
% hemisphere = {'lh' }
% subjectname = 'fsaverage-bkup';
% surfacetype = 'inflated';
% mgz2label(mgzfiles{1},hemisphere{1},areaID,areanames,inputdir,outputdir,subjectname,surfacetype)
% 
% cd ../label/.
% !freeview -f ../surf/lh.inflated
% !cp lh.Prob_OWFA_WordsNumbers_vn.label CBA//fROIs/averages/label/.
% 
% 
% %!cp rh.Prob_pfs_roi_vn.mgz /sni-storage/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/fsaverage-bkup/label/CBA/fROIs/averages/mgz/.
