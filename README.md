# bbfloc


the **"bbfloc_5.0"** folder contains the scripts and stimuli to run the bbfloc experiment in psychopy. 
* to generate the runs: ``bbfloc_5.0/matlab/runme_v5.m``
* to run the experiment: ``bbfloc_5.0/psychopy/runME_v5.py``

the **"code"** folder contains the scripts necessary for processing the infant data thru mrVista.

the **"across ages"** folder contains the scripts necessary for analyses by age groups (infants and children)
* to generate Fig 2c:
    * get stats for infants and save in unique data structure: ``bbfloc/across age analyses/babies/stats(avgd. across rois)``
    * get stats for children and save in unique data structure: ``bbfloc/across_age_analyses/kids/stats(avgd. across rois)``
    * vertcat to append the data structures
    * ``bbfloc/Fig_2c.m``
 
* to generate Fig 3:
    * get stats for infants and save in unique data structure: ``bbfloc/across age analyses/babies/stats(avgd. across rois)``
    * get stats for children and save in unique data structure: ``bbfloc/across_age_analyses/kids/stats(avgd. across rois)``
    * vertcat to append the data structures
    * ``bbfloc/Fig_3.m``


* to generate Figures 1c and Figures 2b:
     * ``bbfloc/across_age_analyses/kids/amps_per_roi_kid.m``
     * ``bbfloc/across_age_analyses/babies/amps_per_roi_baby.m``
     *  ``bbfloc/Fig_1c_Fig_2b.m``
        
  
