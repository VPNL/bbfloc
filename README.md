# bbfloc
This repo houses the scripts developed for the baby fLoc. File paths in the scripts are defaulted to the VPNL laptop, modify if necessary. 

The make_order_babyloc scripts are matlab scripts that generate unique CSVs for either the dynamic condition or the static condition. You will see different versions of these scripts. They vary in how many repeats and runs they have, since different versions of the experiments require different parameters.

The experiment itself is run in PsychoPy, and requires the CSVs generated on Matlab.

TO RUN SHORT VERSION OF EXPERIMENT: 
- Make_order_babyloc_dyna_short generates 8 dynamic runs with no repeats in actors within a run. Its generated CSVs will be used for running the 'short' experiment on PsychoPy. 
- Make_order_babyloc_static_short generates 8 static runs with no repeats in images within a run. Its generated CSVs will be used for running the 'short' experiment on PsychoPy.
- runalternatingStim_withCountdown_SHORT is the PsychoPy script to run. 

