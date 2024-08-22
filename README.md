# bbfloc

Static condition stimuli for faces, hands, cars, and scenes categories were adapted from Anthony Stigliani's fLoc functional localizer package ([Stigliani et al](http://vpnl.stanford.edu/papers/StiglianiJNS2015.pdf)., 2015).
Static condition stimuli for the food category were adapted from Nidhi Jain's food stimuli ([Jain et al](https://www.nature.com/articles/s42003-023-04546-2)., 2023). 
Dynamic condition stimuli were generated by Beth Rispoli.
Heather Kosakowski's video stimuli ([Kosakowski et al](https://doi.org/10.17605/OSF.IO/JNX5A)., 2023) were adapted to be introduced as their own condition to test for replicability. 

Experiment runs are always generated in Matlab and are unique to each subject. Experiments run on PsychoPy.

# set-up instructions 

Clone this repository onto the computer you will use to present stimuli.

Software requirements: Matlab and PsychoPy 

## folder organization

- Three subfolders to be kept within **`bbfloc`**:
    - **`matlab`**: where the Matlab functions used to generate experiment runs will be kept.
          - RUNME_newexp: is the main matlab script used to generate unique runs across conditions for each subject 
    - **`psychopy`**: where the PsychoPy scripts for each experiment version will be kept.
        - Contains a folder called `countdown_imgs` where the countdown images are kept.
        - Also contains a subfolder called `data` where the participant experiment data is kept.
            - Within this subfolder will be where folders for each participant are kept (e.g., `bb01`, `bb02`).
                  - Within each participant folder should be subfolder(s) for each experiment version containing runs for that version.
    - **`stimuli`**: contains two subfolders:
        - `dynamic_stimuli`: contains the dynamic stimuli, edited to have emoji fixations affixed onto them.
        - `static_stimuli`: contains the static stimuli, edited to have emoji fixations affixed onto them..
        - `saxestim_wfixation`: contains Heather Kosakowski's stimuli, edited to have emoji fixations affixed onto them. 
