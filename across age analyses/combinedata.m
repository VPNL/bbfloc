%% bihemisphere FIGURE GEN (plot tval for each ROI within a contrast)

load('/share/kalanit/biac2/kgs/projects/bb2adult/results/kid_mean_tvals_amps_and_motion_wTRs.mat')
load('kid_mean_amps_tvals_TSNR_motion_TRs_R1.mat')
kid_roi_data = roi_data;

load('/share/kalanit/biac2/kgs/projects/bb2adult/results/baby_mean_tvals_amps_and_motion_wTRs.mat')
load('baby_mean_amps_tvals_TSNR_motion_TRs_R1.mat')
baby_roi_data = roi_data;

childcolor = [143/255 197/255 223/255;  0.11 0.56 1];
babycolor = [170/255 215/255 170/255; 0.67 0.84 0.67];

roi_data = vertcat(baby_roi_data, kid_roi_data)
saveDir = ('/share/kalanit/biac2/kgs/projects/bb2adult/results/')
save(fullfile(saveDir, 'combined_subj_mean_tvals_TSNR_motion_wTRs_R1.mat'), "roi_data")
savefile = (fullfile(saveDir, 'combined_subj_mean_tvals_TSNR_motion_wTRs_R1.csv'))

writetable(roi_data,savefile)
