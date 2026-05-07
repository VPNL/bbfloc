# bbfloc


the **"bbfloc_5.0"** folder contains the scripts and stimuli to run the bbfloc experiment in psychopy. 
- to generate the runs: ``bbfloc_5.0/matlab/runme_v5.m``
- to run the experiment: ``bbfloc_5.0/psychopy/runME_v5.py``

the **"code"** folder contains the scripts necessary for processing the infant data thru mrVista.

the **"across ages"** folder contains the scripts necessary for analyses by age groups (infants and children)
- get stats for infants and save in unique data structure: ``bbfloc/across age analyses/babies/stats(avgd. across rois)`` 
- get stats for children and save in unique data structure: ``bbfloc_5.0/across_age_analyses/kids/stats(avgd. across rois)``
- vertcat to append the data structures
- to generate fig 1c+fig 2b:
      - ``bbfloc_5.0/across_age_analyses/kids/get_amps_per_roi_kids.m``
- 
