# MID VERSION OF EXPERIMENT: 4 runs with 8 repeats per category
Single run: 2 min and 54s duration, 40 blocks, 2 blank padding blocks 
- Make_order_babyloc_dyna_mid generates **4 dynamic runs/CSVs** in the participant's 'mid' subfolder, with **8 repeats per category**, and no repeats in actors within a run. Its generated CSVs will be used for running the 'mid' experiment on PsychoPy.
    - Each block contains a unique 4s video.
- Make_order_babyloc_static_mid generates **4 static runs/CSVs** in the participant's 'mid' subfolder, with **8 repeats per category**, and no repeats in images within a run. Its generated CSVs will be used for running the 'mid' experiment on PsychoPy.
    - Each block contains 8 unique images presented at .5 seconds each.
- runalternatingStim_withCountdown_MID is the PsychoPy script to run. Generates par, log, csv, and psydat files for each run.

**Experiment Breakdown: run1: static, run2: static, run3: dynamic, run 4: dynamic**

