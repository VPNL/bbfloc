# bbfloc
This repo houses the scripts developed for the baby fLoc. File paths in all the scripts are defaulted to the VPNL laptop, modify if not running on VPNL. 

We currently have three working experiment versions: short, mid, and long.

The make_order_babyloc scripts are matlab scripts that generate a unique CSV for every run in an experiment version. 

The experiment itself is run in PsychoPy, and requires the CSVs generated on Matlab.

# SHORT VERSION OF EXPERIMENT: 8 runs with 4 repeats per category
- Single run: 96 second duration, 20 blocks, 2 blank padding blocks
- Make_order_babyloc_dyna_short generates **8 dynamic runs/CSVs** in the participant's folder, with **4 repeats per category**, and no repeats in actors within a run. Its generated CSVs will be used for running the 'short' experiment on PsychoPy.
    - Each block contains a unique 4s video.
- Make_order_babyloc_static_short generates **8 static runs/CSVs** in the participant's folder, with **4 repeats per category**, and no repeats in images within a run. Its generated CSVs will be used for running the 'short' experiment on PsychoPy.
    - Each block contains 8 images presented at .5 sec each.
- runalternatingStim_withCountdown_SHORT is the PsychoPy script to run. Generates par, log, csv, and psydat files for each run.
      **Experiment Breakdown: run1: static, run2: static, run3: dynamic, run 4: dynamic, run5: static, run6: static, run7: dynamic, run 8: dynamic**

# MID VERSION OF EXPERIMENT: 4 runs with 8 repeats per category
Single run: 2 min and 54s duration, 40 blocks, 2 blank padding blocks 
- Make_order_babyloc_dyna_mid generates **4 dynamic runs/CSVs** in the participant's folder, with **8 repeats per category**, and no repeats in actors within a run. Its generated CSVs will be used for running the 'short' experiment on PsychoPy.
    - Each block contains a unique 4s video.
- Make_order_babyloc_static_mid generates **4 static runs/CSVs** in the participant's folder, with **8 repeats per category**, and no repeats in images within a run. Its generated CSVs will be used for running the 'short' experiment on PsychoPy.
    - Each block contains 8 unique images presented at .5 seconds each.
- runalternatingStim_withCountdown_MID is the PsychoPy script to run. Generates par, log, csv, and psydat files for each run.
      **Experiment Breakdown: run1: static, run2: static, run3: dynamic, run 4: dynamic**

# LONG VERSION OF EXPERIMENT: 4 runs with 12 repeats per category
- Single run: 4 min and 14 second duration, 60 blocks, 2 blank padding blocks 
- Make_order_babyloc_dyna_long generates **4 dynamic runs/CSVs** in the participant's folder, with **12 repeats** per category, and no repeats in actors within a run. Its generated CSVs will be used for running the 'short' experiment on PsychoPy.
     - Each block contains a unique 4s video.
- Make_order_babyloc_static_long generates **4 static runs/CSVs** in the participant's folder, with **12 repeats** per category, and no repeats in images within a run. Its generated CSVs will be used for running the 'short' experiment on PsychoPy.
    - Each block contains 8 unique images presented at .5 seconds each.
- runalternatingStim_withCountdown_LONG is the PsychoPy script to run. Generates par, log, csv, and psydat files for each run.
      **Experiment Breakdown: run1: static, run2: static, run3: dynamic, run 4: dynamic**
