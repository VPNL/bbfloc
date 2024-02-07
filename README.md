# bbfloc
We have three working experiment versions: short, mid, and long. 

**We now also have a combined length experiment version: which includes 4 short runs followed by 4 long runs. Which is the version we plan to use going foward.**

The runs for each experiment version are generated on Matlab. The experiment versions run on PsychoPy.

# How to store the files
All experiment stuff will be kept in a folder called **'alternating_bb'** on your DESKTOP. 

- Three subfolders to be kept within **['alternating_bb'](https://www.dropbox.com/scl/fo/3hakolem37bef9sax1pkx/h?rlkey=obpg68j8q4nxnyey07c7pxlpb&dl=0)**: 
    - **'alternating_matlab'**: where the matlab scripts (used to generate runs) for each experiment version will be kept
        - All the matlab scripts for the combined exp version are under a subfolder called 'combined'
    - **'alternating_psychopy'**: where the PsychoPy scripts for each experiment version will be kept
      - contains a folder called 'countdown_imgs' where the countdown_imgs are kept
        - also contains a subfolder called 'data' where the participant exp data is kept 
            - within this subfolder is a folder for each participant (i.e. 'bb01', 'bb02')
                  - each participant folder contains another four subfolders: 'short', 'mid', 'long', and 'combined' (for the new combined exp)
    - **'alternating_stimuli'**: contains 2 subfolders
        - 'dynamic_stimuli': contains the dynamic stimuli - updated to be phase scrambled
        - 'static_sitmuli': contains the static stimuli

# COMBINED VERSION OF EXPERIMENT: 4 runs with 4 repeats per category (short); 4 runs with 12 repeats per category (long)
Short run: 94 second duration, 20 blocks, 2 blank padding blocks
Long run: 4 min and 14 second duration, 60 blocks, 2 blank padding blocks 
Must run all the functions under the **'combined'** folder in alternating matlab; will generate 8 runs total, 2 dynamic short, 2 static short, 2 dynamic long, 2 static long before running the PsychoPy script **runalternatingStim_withCountdown_combined_lengths**

**Experiment Breakdown: run1: dynamic short, run2: static short, run3: dynamic short, run4: static short, run5: dynamic short, run6: static short, run7: dynamic short, run8: static short**

# SHORT VERSION OF EXPERIMENT: 8 runs with 4 repeats per category
Single run: 94 second duration, 20 blocks, 2 blank padding blocks
- Make_order_babyloc_dyna_short generates **8 dynamic runs/CSVs** in the participant's 'short' subfolder, with **4 repeats per category**, and no repeats in actors within a run. Its generated CSVs will be used for running the 'short' experiment on PsychoPy.
    - Each block contains a unique 4s video.
- Make_order_babyloc_static_short generates **8 static runs/CSVs** in the participant's 'short' subfolder, with **4 repeats per category**, and no repeats in images within a run. Its generated CSVs will be used for running the 'short' experiment on PsychoPy.
    - Each block contains 8 images presented at .5 sec each.
- runalternatingStim_withCountdown_SHORT is the PsychoPy script to run. Generates par, log, csv, and psydat files for each run.

**Experiment Breakdown: run1: static, run2: static, run3: dynamic, run 4: dynamic, run5: static, run6: static, run7: dynamic, run 8: dynamic**

# MID VERSION OF EXPERIMENT: 4 runs with 8 repeats per category
Single run: 2 min and 54s duration, 40 blocks, 2 blank padding blocks 
- Make_order_babyloc_dyna_mid generates **4 dynamic runs/CSVs** in the participant's 'mid' subfolder, with **8 repeats per category**, and no repeats in actors within a run. Its generated CSVs will be used for running the 'mid' experiment on PsychoPy.
    - Each block contains a unique 4s video.
- Make_order_babyloc_static_mid generates **4 static runs/CSVs** in the participant's 'mid' subfolder, with **8 repeats per category**, and no repeats in images within a run. Its generated CSVs will be used for running the 'mid' experiment on PsychoPy.
    - Each block contains 8 unique images presented at .5 seconds each.
- runalternatingStim_withCountdown_MID is the PsychoPy script to run. Generates par, log, csv, and psydat files for each run.

**Experiment Breakdown: run1: static, run2: static, run3: dynamic, run 4: dynamic**

# LONG VERSION OF EXPERIMENT: 4 runs with 12 repeats per category
Single run: 4 min and 14 second duration, 60 blocks, 2 blank padding blocks 
- Make_order_babyloc_dyna_long generates **4 dynamic runs/CSVs** in the participant's 'long' subfolder, with **12 repeats** per category, and no repeats in actors within a run. Its generated CSVs will be used for running the 'long' experiment on PsychoPy.
     - Each block contains a unique 4s video.
- Make_order_babyloc_static_long generates **4 static runs/CSVs** in the participant's 'long' subfolder, with **12 repeats** per category, and no repeats in images within a run. Its generated CSVs will be used for running the 'long' experiment on PsychoPy.
    - Each block contains 8 unique images presented at .5 seconds each.
- runalternatingStim_withCountdown_LONG is the PsychoPy script to run. Generates par, log, csv, and psydat files for each run.

**Experiment Breakdown: run1: static, run2: static, run3: dynamic, run 4: dynamic**
