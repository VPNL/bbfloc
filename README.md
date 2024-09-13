# bbfloc

## a rundown:

Static condition stimuli for faces, hands, cars, and scenes categories were adapted from Anthony Stigliani's fLoc package ([Stigliani et al](http://vpnl.stanford.edu/papers/StiglianiJNS2015.pdf)., 2015).
Static condition stimuli for the food category were adapted from Nidhi Jain's food stimuli ([Jain et al](https://www.nature.com/articles/s42003-023-04546-2)., 2023). 
Dynamic condition stimuli were generated by Beth Rispoli.
Heather Kosakowski's video stimuli ([Kosakowski et al](https://doi.org/10.17605/OSF.IO/JNX5A)., 2023) were adapted to be introduced as their own condition to test for replicability. 

Run CSVs are always generated in MATLAB, with each CSV being unique to a specific subject. These CSVs are then used by PsychoPy to execute the experiment. There are three versions of the PsychoPy exp_runME.py script (v1, v2, v3), each designed with a different order of condition presentation to prevent order bias.

## setting up the experiment for a subject

**First** use the RUNME_newexp.m script to generate the run CSVs and data folders for the subject! Just input the subject's name, your laptop's user (whoami), and the integer corresponding to the PsychoPy runME script version (1, 2, or 3) that you want to generate runs for.
**Second** load the Psychopy runME script version that you want to use for this subject (either v1, v2, or v3). Input their name, the laptop user, and the run number when prompted.

## set-up instructions 

Clone this repository onto the computer you will use to present stimuli. Add it to your desktop.

Software requirements: Matlab and PsychoPy 

## folder organization

- Three subfolders to be kept within **`bbfloc`**:
    - **`matlab`**: where the Matlab functions used to generate experiment runs will be kept.
        -  **`RUNME_newexp`**: is the main matlab script used to generate unique run CSVs each subject. 
    - **`psychopy`**: where the PsychoPy scripts for each experiment version will be kept.
        - Contains a folder called `countdown_imgs` where the countdown images for the experiment are kept.
        - Also contains a subfolder called `data` where the participant experiment data is kept.
            - Within this subfolder will be where folders for each participant are kept (e.g., `bb01`, `bb02`).
                  - Within each participant folder should be subfolder(s) for each experiment version (v1, v2, v3) containing unique run CSVs for that version. Parfiles and log files will be                      automatically saved in the subject's data folder. 
    - **`stimuli`**: contains two subfolders:
        - `dynamic_stimuli`: contains the dynamic stimuli, edited to have emoji fixations affixed onto them. Stimuli and blank baseline videos have a duration of 4s. 
        - `updated_static_stimuli`: contains the static stimuli (1080x1080p), edited to have emoji fixations affixed onto them. 
        - `saxestim_wfixation`: contains Heather Kosakowski's stimuli, edited to have emoji fixations affixed onto them. Stimuli have a duration of 2.6667s, blank baseline videos have 4s                   durations.  
