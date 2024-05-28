# bbfloc

We originally had four working experiment versions that varied in run length: combined, short, mid, and long. However, we realized we needed longer run lengths and a more recurring visual baseline condition. So we went back and iterated to create new experiment versions. These versions have the same run length (4 minutes and 24 seconds) and only vary in their block duration.

Regardless of the experiment version, the runs for each experiment are always generated in Matlab and are unique to each subject. The experiments themselves run on PsychoPy.

## Instructions

Clone this repository onto the computer you will use to present stimuli.

## Folder Organization

- Three subfolders to be kept within **`bbfloc`**:
    - **`matlab`**: where the Matlab functions (used to generate runs) for each experiment version will be kept.
        - All the Matlab functions for the combined experiment version are under a subfolder called `combined`.
    - **`psychopy`**: where the PsychoPy scripts for each experiment version will be kept.
        - Contains a folder called `countdown_imgs` where the countdown images are kept.
        - Also contains a subfolder called `data` where the participant experiment data is kept.
            - Within this subfolder is a folder for each participant (e.g., `bb01`, `bb02`).
                - Each participant folder contains another four subfolders: `short`, `mid`, `long`, and `combined`.
    - **`stimuli`**: contains two subfolders:
        - `dynamic_stimuli`: contains the dynamic stimuli, updated to have phase-scrambled backgrounds and enlarged stimuli.
        - `static_stimuli`: contains the static stimuli.

# Updated Experiment Versions (to use)

## Visual Baseline Experiment
To get started: Run the matlab script **`bbfloc/matlab/runme/RUNME_makenewexp_bbfloc.m`** (it generates 5 runs total: 2 dyna long block runs, 2 static short, 2 dynamic long, 2 static long, 2 grayscale runs in the subject's data folder). Then run the PsychoPy script **`bbfloc/psychopy/runalternatingStim_withCountdown_combined_lengths.py`**

# Old Experiment Versions 

## Combined Version of Experiment

To get started: Run the matlab script **`bbfloc/matlab/combined/RUNME_makeorderbabyloc_COMBINED.m`** (it generates 10 runs total: 2 dynamic short, 2 static short, 2 dynamic long, 2 static long, 2 grayscale runs in the subject's data folder). Then run the PsychoPy script **`bbfloc/psychopy/runalternatingStim_withCountdown_combined_lengths.py`**
  
**Experiment Breakdown**: 

- Includes static, dynamic, and grayscale stimuli

- **Short alternating runs**: each have a 94-second duration (88 seconds of blocks + 6 seconds countdown), 20 blocks, and 2 blank padding blocks.
- **Long alternating runs**: each have a 254-second duration (248 seconds of blocks + 6 seconds countdown), 60 blocks, and 2 blank padding blocks.
- 6-second countdown before each run regardless of run length.

1. run1: dynamic short
2. run2: static short
3. run3: dynamic short
4. run4: static short
5. run5: dynamic long
6. run6: static long
7. run7: dynamic long
8. run8: static long
9. run9: grayscale long
10. run10: grayscale long


## Short Version of Experiment

To get started: Run the matlab script **`bbfloc/matlab/short_updated/RUNME_makeorderbabyloc_short.m`** (it generates 16 short runs total: 8 dynamic, 8 static in the subject's data folder). Then in PsychoPy run the script **`bbfloc/psychopy/runalternatingStim_withCountdown_SHORT.py`**

**Experiment Breakdown**: 

- 16 short runs total 
- Single run: 94-second duration; 4 repeats per category; 20 blocks, and 2 blank padding blocks; 6-second image countdown before each run.

1. run1: static
2. run2: static
3. run3: dynamic
4. run4: dynamic
5. run5: static
6. run6: static
7. run7: dynamic
8. run8: dynamic
9. run9: static
2. run10: static
3. run11: dynamic
4. run12: dynamic
5. run13: static
6. run14: static
7. run15: dynamic
8. run16: dynamic


## Mid Version of Experiment

To get started: Run the matlab script **`bbfloc/matlab/mid/RUNME_makeorderbabyloc_MID.m`** (it generates 4 mid runs total: 2 dynamic, 2 static in the subject's data folder). Then in PsychoPy run the script **`bbfloc/psychopy/runalternatingStim_withCountdown_MID.py`**

**Experiment Breakdown**: 

- 8 runs total
- Single run: 2 minutes and 54 seconds duration; 8 repeats per category; 40 blocks, and 2 blank padding blocks; 6-second image countdown before each run.

1. run1: static
2. run2: static
3. run3: dynamic
4. run4: dynamic
5. run5: static
6. run6: static
7. run7: dynamic
8. run8: dynamic
   
## Long Version of Experiment

To get started: Run the matlab script **`bbfloc/matlab/long/RUNME_makeorderbabyloc_LONG.m`** (it generates 8 long runs total: 4 dynamic, 4 static in the subject's data folder). Then in PsychoPy run the script **`bbfloc/psychopy/runalternatingStim_withCountdown_LONG.py`**

**Experiment Breakdown**: 

- 8 runs total
- Single run: 4 minutes and 14 seconds duration; 12 repeats per category; 60 blocks, and 2 blank padding blocks; 6-second image countdown before each run.

1. run1: static
2. run2: static
3. run3: dynamic
4. run4: dynamic
5. run5: static
6. run6: static
7. run7: dynamic
8. run8: dynamic 



