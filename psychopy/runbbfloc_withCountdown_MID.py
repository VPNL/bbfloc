# --- For running 8 mid length runs  --- need to have these runs stored in psychopy/data/participant/mid
# --- Import packages ---
from psychopy import locale_setup
from psychopy import prefs
from psychopy import plugins
plugins.activatePlugins()
prefs.hardware['audioLib'] = 'ptb'
prefs.hardware['audioLatencyMode'] = '3'
from psychopy import sound, gui, visual, core, data, event, logging, clock, colors, layout
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)

import numpy as np  # whole numpy lib is available, prepend 'np.'
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from numpy.random import random, randint, normal, shuffle, choice as randchoice
import os  # handy system and path functions
import sys  # to get file system encoding
import cv2

import psychopy.iohub as io
from psychopy.hardware import keyboard

import pandas as pd
import random

current_directory = os.getcwd()
print("Current Working Directory:", current_directory)
# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__))
os.chdir(_thisDir)

# ======================== get gui inputs ============================ 
# Store info about the experiment session
psychopyVersion = '2023.2.2'
expName = 'midbabyloc'  # from the Builder filename that created this script
expInfo = {
    'participant': f"practice1",
    'run': '1',
    'user': 'vpnl',
}
# --- Show participant info dialog --
dlg = gui.DlgFromDict(dictionary=expInfo, sortKeys=False, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName
expInfo['psychopyVersion'] = psychopyVersion
#save gui inputs 
participant = expInfo['participant']
usr = expInfo['user']
run_num = int(expInfo['run'])

 # ======================== screen/keyboard set-up ============================ 
# --- Setup the Window ---
win = visual.Window(
    size=(1920, 1080), checkTiming=False, fullscr=1, screen=1, #change screen stuff here; size=(960, 540), screen=0 is default--- trying to get the stimuli to play only on the scanner screen
    winType='pyglet', allowStencil=False, 
    monitor='testMonitor', color=[0, 0, 0], colorSpace='rgb',
    backgroundImage = f'/Users/{usr}/Desktop/bbfloc/stimuli/background_color.png', backgroundFit='contain', 
    blendMode='avg', useFBO=True, 
    units='pix')
win.mouseVisible = False

# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur = 1.0 / round(expInfo['frameRate'])
else:
    frameDur = 1.0 / 60.0  # could not measure, so guess

# --- Setup input devices ---
ioConfig = {}

# Setup iohub keyboard
ioConfig['Keyboard'] = dict(use_keymap='psychopy')

ioSession = '1'
if 'session' in expInfo:
    ioSession = str(expInfo['session'])
ioServer = io.launchHubServer(window=win, **ioConfig)

# create a default keyboard (e.g. to check for escape)
defaultKeyboard = keyboard.Keyboard(backend='iohub')

#maybe this shouldnt be here
endExpNow = False  # flag for 'escape' or other condition => quit the exp
frameTolerance = 0.001  # how close to onset before 'same' frame

for run_num in range(run_num, 9):
    # loop thru the following steps if run_num is static <=2 
    if run_num <= 2 or (5 <= run_num <= 6):
        # ======================== experiment set-up ============================ 
        # Dynamically generate the file path based on run number
        csv_file_path = _thisDir + '/data/' + str(participant) + '/' + 'mid' + '/' + 'script_babyloc_static_mid_run' + str(run_num) + '.csv'
        
        columns_to_import = ["Block #", "Category", "Onset-time(s)", "Image Name", "Image Path", "TaskMatch"]
        
        # Read specific columns from the CSV file
        vals = pd.read_csv(csv_file_path,  usecols=columns_to_import)
        
        #load all info for this run only
        stim_names = vals["Image Name"].values
        stim_directories = vals["Image Path"].values
        block_conds_all = vals["Block #"].values
        condition_names = vals["TaskMatch"].values
        category = vals["Category"].values
        onset_nums = vals["Onset-time(s)"].values
        category = category.astype(int)
        
        
        # Assuming expInfo['participant'] and expInfo['date'] are not strings, convert them to strings if necessary
        participant_str = str(expInfo['participant'])
        date_str = str(expInfo['date'])
        
        # Concatenate strings
        experiment_info_header = participant_str + '_run' + str(run_num) + '_' + expName + '_' + date_str
        filename = _thisDir + '/data/' + str(participant) + '/' + 'mid' + '/'+ str(experiment_info_header)
        
        # An ExperimentHandler isn't essential but helps with data saving
        thisExp = data.ExperimentHandler(name=expName, version='',
            extraInfo=expInfo, runtimeInfo=None,
            originPath='/Users/vpnl/Desktop/bbfloc',
            savePickle=True, saveWideText=True,
            dataFileName=filename)
            
        # save a log file for detail verbose info
        logFile = logging.LogFile(filename+'.log', level=logging.EXP)
        logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file
        
        # ======================== screen/keyboard set-up ============================
        # --- Load "wait_for_trigger" screen info ---
        waiting_for_trigger_text = visual.TextStim(win=win, name='waiting_for_trigger_text',
            text='Waiting for trigger (t)...',
            font='Open Sans',
            pos=(0, 0), height=0.1, wrapWidth=None, ori=0.0, 
            color='white', colorSpace='rgb', opacity=None, 
            languageStyle='LTR',
            depth=0.0);
        trigger = keyboard.Keyboard()
        
        if run_num == run_num: 
            # --- load countdown screen ---
            countdown = visual.TextStim(win=win, name='countdown',
                text='',
                font='Open Sans',
                pos=(0, 0), height=0.1, wrapWidth=None, ori=0.0, 
                color='white', colorSpace='rgb', opacity=None, 
                languageStyle='LTR',
                depth=0.0);
            
        # ======================== load image stimuli  ============================
        #get image file paths from stim_directories only for non-baseline stimuli
        image_paths = stim_directories
        
        # create a list of loaded ImageStim3 objects
        images = [visual.ImageStim(win, path, flipVert=False, size=(768, 768)) for path in image_paths] #changed from movie_stim
        
        from pathlib import Path
        #Define the countdown path, use an f-string to include the value of the usr variable in the path
        countdown_path = Path(f"/Users/{usr}/Desktop/bbfloc/psychopy/countdown_imgs")
        
        
        # Create a list of countdown images
        countdown_images = [visual.ImageStim(win, str(path), size=(768, 768), flipVert=True) for path in countdown_path.glob('*.png')]
        
        
        # ======================== run experiment! ============================
        # --- Create some handy timers---
        globalClock = core.Clock()  # to track the time since experiment started
        routineTimer = core.Clock()  # to track time remaining of each (possibly non-slip) routine 
        
        #--- Prepare to start Routine "wait_for_trigger" ---
        continueRoutine = True
        #update component parameters for each repeat
        trigger.keys = []
        trigger.rt = []
        _trigger_allKeys = []
        #keep track of which components have finished
        wait_for_triggerComponents = [waiting_for_trigger_text, trigger]
        for thisComponent in wait_for_triggerComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        #reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1
        
        # --- Run Routine "wait_for_trigger" ---
        routineForceEnded = not continueRoutine
        while continueRoutine:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *waiting_for_trigger_text* updates
            
            # if waiting_for_trigger_text is starting this frame...
            if waiting_for_trigger_text.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                waiting_for_trigger_text.frameNStart = frameN  # exact frame index
                waiting_for_trigger_text.tStart = t  # local t and not account for scr refresh
                waiting_for_trigger_text.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(waiting_for_trigger_text, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'waiting_for_trigger_text.started')
                # update status
                waiting_for_trigger_text.status = STARTED
                waiting_for_trigger_text.setAutoDraw(True)
            
            # if waiting_for_trigger_text is active this frame...
            if waiting_for_trigger_text.status == STARTED:
                # update params
                pass
            
            # *trigger* updates
            waitOnFlip = False
            
            # if trigger is starting this frame...
            if trigger.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                trigger.frameNStart = frameN  # exact frame index
                trigger.tStart = t  # local t and not account for scr refresh
                trigger.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(trigger, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'trigger.started')
                # update status
                trigger.status = STARTED
                # keyboard checking is just starting
                waitOnFlip = True
                win.callOnFlip(trigger.clock.reset)  # t=0 on next screen flip
                win.callOnFlip(trigger.clearEvents, eventType='keyboard')  # clear events on next screen flip
            if trigger.status == STARTED and not waitOnFlip:
                theseKeys = trigger.getKeys(keyList=['g','t'], waitRelease=False)
                _trigger_allKeys.extend(theseKeys)
                if len(_trigger_allKeys):
                    trigger.keys = _trigger_allKeys[-1].name  # just the last key pressed
                    trigger.rt = _trigger_allKeys[-1].rt
                    # a response ends the routine
                    continueRoutine = False
            
            # check for quit (typically the Esc key)
            if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
                core.quit()
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in wait_for_triggerComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "wait_for_trigger" ---
        for thisComponent in wait_for_triggerComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # check responses
        if trigger.keys in ['', [], None]:  # No response was made
            trigger.keys = None
        thisExp.addData('trigger.keys',trigger.keys)
        if trigger.keys != None:  # we had a response
            thisExp.addData('trigger.rt', trigger.rt)
        thisExp.nextEntry()
        # the Routine "wait_for_trigger" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        
        #======COUNTDOWN====================
        #========================== 
        # --- Prepare to start Routine "countdown n-extra TRs" ---
        continueRoutine = True
        # update component parameters for each repeat
        thisExp.addData('countdown.started', globalClock.getTime())
        # keep track of which components have finished
        trialComponents = [countdown]
        for thisComponent in trialComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1
        
        # --- Run Routine "countdown n-extra TRs" ---
        routineForceEnded = not continueRoutine
        while continueRoutine and routineTimer.getTime() < 6.0:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # Calculate the time remaining for the countdown
            time_remaining = 6 - t
            # Check if it's a new second and display the corresponding image
            if int(time_remaining) != int(time_remaining + 1):
                # Calculate the index of the image based on the time remaining
                image_index = int(time_remaining)
                
                # Display the image
                countdown_images[image_index].draw()
                
            # if countdown is starting this frame...
            if countdown.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
                # keep track of start time/frame for later
                countdown.frameNStart = frameN  # exact frame index
                countdown.tStart = t  # local t and not account for scr refresh
                countdown.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(countdown, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'countdown.started')
                # update status
                countdown.status = STARTED
                countdown.setAutoDraw(True)
            
              # if countdown is stopping this frame...
            if countdown.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > countdown.tStartRefresh + 6 - frameTolerance:
                    # keep track of stop time/frame for later
                    countdown.tStop = t  # not accounting for scr refresh
                    countdown.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'countdown.stopped')
                    # update status
                    countdown.status = FINISHED
                    countdown.setAutoDraw(False)
            
            # check for quit (typically the Esc key)
            if defaultKeyboard.getKeys(keyList=["escape"]):
                thisExp.status = FINISHED
            if thisExp.status == FINISHED or endExpNow:
                endExperiment(thisExp, inputs=inputs, win=win)
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in trialComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
                    
                
        # --- Ending Routine "trial" ---
        for thisComponent in trialComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        thisExp.addData('trial.stopped', globalClock.getTime())
        # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
        if routineForceEnded:
            routineTimer.reset()
        else:
            routineTimer.addTime(-6.000000)
            
        #==========================
        # --- Prepare to start Routine "draw_stimuli" ---
        stim_index = 0
        for block_cond in block_conds_all:
            print(block_cond)
            print(stim_names[stim_index])
            stimuli = images[stim_index]
            continueRoutine = True
            # update component parameters for each repeat
            #button_box_resp.keys = []
            #button_box_resp.rt = []
            #_button_box_resp_allKeys = []
            # keep track of which components have finished
            draw_stimuliComponents = [stimuli]
            for thisComponent in draw_stimuliComponents:
                thisComponent.tStart = None
                thisComponent.tStop = None
                thisComponent.tStartRefresh = None
                thisComponent.tStopRefresh = None
                if hasattr(thisComponent, 'status'):
                    thisComponent.status = NOT_STARTED
            
            # reset timers
            t = 0
            _timeToFirstFrame = win.getFutureFlipTime(clock="now")
            frameN = -1
            
            # --- Run Routine "play_stimuli" ---
            routineForceEnded = not continueRoutine
            while continueRoutine and routineTimer.getTime() < 0.5:
                # get current time
                t = routineTimer.getTime()
                tThisFlip = win.getFutureFlipTime(clock=routineTimer)
                tThisFlipGlobal = win.getFutureFlipTime(clock=None)
                frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
                # update/draw components on each frame
                
                # *stimuli* updates
                
                # if stimuli is starting this frame...
                if stimuli.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    stimuli.frameNStart = frameN  # exact frame index
                    stimuli.tStart = t  # local t and not account for scr refresh
                    stimuli.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(stimuli, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'stimuli.started')
                    thisExp.addData('condition',block_conds_all[stim_index])
                    thisExp.addData('stim_name',stim_names[stim_index])
                    # update status
                    stimuli.status = STARTED
                    stimuli.setAutoDraw(True)
                    stimuli.draw()
                
                # if stimuli is stopping this frame...
                if stimuli.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > stimuli.tStartRefresh + 0.5-frameTolerance:
                        # keep track of stop time/frame for later
                        stimuli.tStop = t  # not accounting for scr refresh
                        stimuli.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.timestampOnFlip(win, 'stimuli.stopped')
                        # update status
                        stimuli.status = FINISHED
                        stimuli.setAutoDraw(False)
                        #if stimuli.isFinished:  # force-end the routine; keep getting error imagestim3 has no attribute isFinished but i dont think im using moviestim3
                        #continueRoutine = False
                    
                    
                # check for quit (typically the Esc key)
                if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
                    core.quit()
                
                # check if all components have finished
                if not continueRoutine:  # a component has requested a forced-end of Routine
                    routineForceEnded = True
                    break
                continueRoutine = False  # will revert to True if at least one component still running
                for thisComponent in draw_stimuliComponents:
                    if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                        continueRoutine = True
                        break  # at least one component has not yet finished
                        
                # refresh the screen
                if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                    win.flip()
            
            # --- Ending Routine "draw_stimuli" ---
            for thisComponent in draw_stimuliComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)
            stimuli.setAutoDraw(False)
            
            # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
            if routineForceEnded:
                routineTimer.reset()
            else:
                routineTimer.addTime(-0.500000)
            thisExp.nextEntry() #i think this will make the stimuli save to a new line every iteration
            stim_index = stim_index + 1
            
        #Begin Routine tab
        last_image_directory = f'/Users/{usr}/Desktop/bbfloc/psychopy/countdown_imgs/'
        
        # Get a list of all image files in the directory
        last_image_files = [f for f in os.listdir(last_image_directory) if f.endswith('.png')]

        # Choose a random image
        random_last_image = random.choice(last_image_files)
        last_image_path = os.path.join(last_image_directory, random_last_image)

        # Set up image stimulus
        last_image = visual.ImageStim(win, size=(768,768), image=last_image_path)

        # Set durations
        last_image_duration = 5.0  # adjust as needed
        
        # Start image presentation
        last_image.draw()
        win.flip()
        core.wait(last_image_duration)
        
        # --- Export par files ---
        #set color codes
        blank = '0 0 0' 
    
        faces = '1 0 0'
    
        hands = '0.8 0.8 0'
    
        cars = '0 0 1'
    
        scenes = '0 1 0'
    
        condition_colors = pd.DataFrame({
            'condition_num': [0, 1, 2, 3, 4],
            'color_code': [blank, faces, hands, cars, scenes]
        })
    
        #build dataframe for conditions par file
        dfs = []
        for index, category in enumerate(category):
            onset_time = onset_nums[index]
            
            # Check if there are any matching elements
            matching_rows = condition_colors.loc[condition_colors['condition_num'] == category, 'color_code']
            
            if not matching_rows.empty:
                # Use .iloc[0] to get the first element if there are duplicates
                color_code = matching_rows.iloc[0]
            else:
                # Handle the case where no matching elements are found
                color_code = '0 0 0'  # Default color for baselines
            
            condition_name = condition_names[index]
            block_cond = block_conds_all[index]
            
            new_data = {'onset_time': onset_time, 'cond_num': category, 'cond_name': condition_name, 'color_code': color_code} 
            new_data_df = pd.DataFrame([new_data])
            
            dfs.append(new_data_df)
        par_file_df = pd.concat(dfs, ignore_index=True)
    
        # export conditions par file
        par_file_df.to_csv(_thisDir + os.sep + u'data/' + str(participant) + '/' + 'mid' + '/' + experiment_info_header + 'static_par_file.par', sep='\t', index=False, header=False, lineterminator='\n')
        print("Par file exported successfully!")
        print(f"Finished processing run {run_num}")
        
    # loop thru the following steps if run_num >=2
    else: 
                # ======================== experiment set-up ============================ 
        # Dynamically generate the file path based on run number
        csv_file_path = _thisDir + '/data/' + str(participant) + '/' + 'mid' + '/' + 'script_babyloc_dyna_mid_run' + str(run_num) + '.csv'
    
        columns_to_import = ["Block #", "Category", "Onset-time(s)", "TaskMatch", "Video Name", "Video Path"]
    
        # Read specific columns from the CSV file
        vals = pd.read_csv(csv_file_path,  usecols=columns_to_import)
    
        #load all info for this run only
        stim_names = vals["Video Name"].values
        stim_directories = vals["Video Path"].values
        block_conds_all = vals["Block #"].values
        condition_names = vals["TaskMatch"].values
        category = vals["Category"].values
        onset_nums = vals["Onset-time(s)"].values
        category = category.astype(int)
    
        # Assuming expInfo['participant'] and expInfo['date'] are not strings, convert them to strings if necessary
        participant_str = str(expInfo['participant'])
        date_str = str(expInfo['date'])
    
        # Concatenate strings
        experiment_info_header = participant_str + '_run' + str(run_num) + '_' + expName + '_' + date_str
        filename = _thisDir + '/data/' + str(participant) + '/' + 'mid' + '/' + str(experiment_info_header)
    
        # An ExperimentHandler isn't essential but helps with data saving
        thisExp = data.ExperimentHandler(name=expName, version='',
            extraInfo=expInfo, runtimeInfo=None,
            originPath=f'/Users/vpnl/Desktop/bbfloc',
            savePickle=True, saveWideText=True,
            dataFileName=filename)
            
        # save a log file for detail verbose info
        logFile = logging.LogFile(filename+'.log', level=logging.EXP)
        logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file
    
        # ======================== load initializing screens  for run ============================
        # --- Load "wait_for_trigger" screen info ---
        waiting_for_trigger_text = visual.TextStim(win=win, name='waiting_for_trigger_text',
            text='Waiting for trigger (t)...',
            font='Open Sans',
            pos=(0, 0), height=0.1, wrapWidth=None, ori=0.0, 
            color='white', colorSpace='rgb', opacity=None, 
            languageStyle='LTR',
            depth=0.0);
        trigger = keyboard.Keyboard()
        
        if run_num == run_num: 
            # --- load countdown screen ---
            countdown = visual.TextStim(win=win, name='countdown',
                text='',
                font='Open Sans',
                pos=(0, 0), height=0.1, wrapWidth=None, ori=0.0, 
                color='white', colorSpace='rgb', opacity=None, 
                languageStyle='LTR',
                depth=0.0);
    
    
        # ======================== load video stimuli  ============================
        #get video file paths from stim_directories only for non-baseline stimuli
        video_paths = stim_directories
    
        # create a list of loaded MovieStim3 objects
        videos = [visual.MovieStim(win, path, flipVert=False, size=(1920, 1080)) for path in video_paths] #changed from MoveStim3
    
        from pathlib import Path
        #create path for countdown images
        #Define the countdown path, use an f-string to include the value of the usr variable in the path
        countdown_path = Path(f"/Users/{usr}/Desktop/bbfloc/psychopy/countdown_imgs")
        
    
        # Create a list of countdown images
        countdown_images = [visual.ImageStim(win, str(path), flipVert=True, size=(768,768)) for path in countdown_path.glob('*.png')]
    
        # ======================== run experiment! ============================
        # --- Create some handy timers---
        globalClock = core.Clock()  # to track the time since experiment started
        routineTimer = core.Clock()  # to track time remaining of each (possibly non-slip) routine 
        
        #--- Prepare to start Routine "wait_for_trigger" ---
        continueRoutine = True
        #update component parameters for each repeat
        trigger.keys = []
        trigger.rt = []
        _trigger_allKeys = []
        #keep track of which components have finished
        wait_for_triggerComponents = [waiting_for_trigger_text, trigger]
        for thisComponent in wait_for_triggerComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        #reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1
        
        # --- Run Routine "wait_for_trigger" ---
        routineForceEnded = not continueRoutine
        while continueRoutine:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *waiting_for_trigger_text* updates
            
            # if waiting_for_trigger_text is starting this frame...
            if waiting_for_trigger_text.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                waiting_for_trigger_text.frameNStart = frameN  # exact frame index
                waiting_for_trigger_text.tStart = t  # local t and not account for scr refresh
                waiting_for_trigger_text.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(waiting_for_trigger_text, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'waiting_for_trigger_text.started')
                # update status
                waiting_for_trigger_text.status = STARTED
                waiting_for_trigger_text.setAutoDraw(True)
            
            # if waiting_for_trigger_text is active this frame...
            if waiting_for_trigger_text.status == STARTED:
                # update params
                pass
            
            # *trigger* updates
            waitOnFlip = False
            
            # if trigger is starting this frame...
            if trigger.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                trigger.frameNStart = frameN  # exact frame index
                trigger.tStart = t  # local t and not account for scr refresh
                trigger.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(trigger, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'trigger.started')
                # update status
                trigger.status = STARTED
                # keyboard checking is just starting
                waitOnFlip = True
                win.callOnFlip(trigger.clock.reset)  # t=0 on next screen flip
                win.callOnFlip(trigger.clearEvents, eventType='keyboard')  # clear events on next screen flip
            if trigger.status == STARTED and not waitOnFlip:
                theseKeys = trigger.getKeys(keyList=['g','t'], waitRelease=False)
                _trigger_allKeys.extend(theseKeys)
                if len(_trigger_allKeys):
                    trigger.keys = _trigger_allKeys[-1].name  # just the last key pressed
                    trigger.rt = _trigger_allKeys[-1].rt
                    # a response ends the routine
                    continueRoutine = False
            
            # check for quit (typically the Esc key)
            if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
                core.quit()
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in wait_for_triggerComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "wait_for_trigger" ---
        for thisComponent in wait_for_triggerComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # check responses
        if trigger.keys in ['', [], None]:  # No response was made
            trigger.keys = None
        thisExp.addData('trigger.keys',trigger.keys)
        if trigger.keys != None:  # we had a response
            thisExp.addData('trigger.rt', trigger.rt)
        thisExp.nextEntry()
        # the Routine "wait_for_trigger" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        
        #======COUNTDOWN====================
        #========================== 
        # --- Prepare to start Routine "countdown n-extra TRs" ---
        continueRoutine = True
        # update component parameters for each repeat
        thisExp.addData('countdown.started', globalClock.getTime())
        # keep track of which components have finished
        trialComponents = [countdown]
        for thisComponent in trialComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1
        
        # --- Run Routine "countdown n-extra TRs" ---
        routineForceEnded = not continueRoutine
        while continueRoutine and routineTimer.getTime() < 6.0:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # Calculate the time remaining for the countdown
            time_remaining = 6 - t
            # Check if it's a new second and display the corresponding image
            if int(time_remaining) != int(time_remaining + 1):
                # Calculate the index of the image based on the time remaining
                image_index = int(time_remaining)
                
                # Display the image
                countdown_images[image_index].draw()
                
            # if countdown is starting this frame...
            if countdown.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
                # keep track of start time/frame for later
                countdown.frameNStart = frameN  # exact frame index
                countdown.tStart = t  # local t and not account for scr refresh
                countdown.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(countdown, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'countdown.started')
                # update status
                countdown.status = STARTED
                countdown.setAutoDraw(True)
            
              # if countdown is stopping this frame...
            if countdown.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > countdown.tStartRefresh + 6 - frameTolerance:
                    # keep track of stop time/frame for later
                    countdown.tStop = t  # not accounting for scr refresh
                    countdown.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'countdown.stopped')
                    # update status
                    countdown.status = FINISHED
                    countdown.setAutoDraw(False)
            
            # check for quit (typically the Esc key)
            if defaultKeyboard.getKeys(keyList=["escape"]):
                thisExp.status = FINISHED
            if thisExp.status == FINISHED or endExpNow:
                endExperiment(thisExp, inputs=inputs, win=win)
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in trialComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
                    
                
        # --- Ending Routine "trial" ---
        for thisComponent in trialComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        thisExp.addData('trial.stopped', globalClock.getTime())
        # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
        if routineForceEnded:
            routineTimer.reset()
        else:
            routineTimer.addTime(-6.000000)
            
        #==========================
        # --- Prepare to start Routine "play_stimuli" ---
        stim_index = 0
        for block_cond in block_conds_all:
            print(block_cond)
            print(stim_names[stim_index])
            stimuli = videos[stim_index]
            continueRoutine = True
            play_stimuliComponents = [stimuli]
            for thisComponent in play_stimuliComponents:
                thisComponent.tStart = None
                thisComponent.tStop = None
                thisComponent.tStartRefresh = None
                thisComponent.tStopRefresh = None
                if hasattr(thisComponent, 'status'):
                    thisComponent.status = NOT_STARTED
            
            # reset timers
            t = 0
            _timeToFirstFrame = win.getFutureFlipTime(clock="now")
            frameN = -1
            
            # --- Run Routine "play_stimuli" ---
            routineForceEnded = not continueRoutine
            while continueRoutine and routineTimer.getTime() < 4.0:
                # get current time
                t = routineTimer.getTime()
                tThisFlip = win.getFutureFlipTime(clock=routineTimer)
                tThisFlipGlobal = win.getFutureFlipTime(clock=None)
                frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
                # update/draw components on each frame
                
                # *stimuli* updates
                
                # if stimuli is starting this frame...
                if stimuli.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    stimuli.frameNStart = frameN  # exact frame index
                    stimuli.tStart = t  # local t and not account for scr refresh
                    stimuli.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(stimuli, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'stimuli.started')
                    thisExp.addData('condition',block_conds_all[stim_index])
                    thisExp.addData('stim_name',stim_names[stim_index])
                    # update status
                    stimuli.status = STARTED
                    stimuli.setAutoDraw(True)
                    stimuli.play()
                
                # if stimuli is stopping this frame...
                if stimuli.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > stimuli.tStartRefresh + 4.0-frameTolerance:
                        # keep track of stop time/frame for later
                        stimuli.tStop = t  # not accounting for scr refresh
                        stimuli.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.timestampOnFlip(win, 'stimuli.stopped')
                        # update status
                        stimuli.status = FINISHED
                        stimuli.setAutoDraw(False)
                        stimuli.stop()
                        #if stimuli.isFinished:  # force-end the routine; keep getting error moviestim3 has no attribute isFinished but i dont think im using moviestim3
                        #continueRoutine = False
                    
                    
                # check for quit (typically the Esc key)
                if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
                    core.quit()
                
                # check if all components have finished
                if not continueRoutine:  # a component has requested a forced-end of Routine
                    routineForceEnded = True
                    break
                continueRoutine = False  # will revert to True if at least one component still running
                for thisComponent in play_stimuliComponents:
                    if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                        continueRoutine = True
                        break  # at least one component has not yet finished
                        
                # refresh the screen
                if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                    win.flip()
            
            # --- Ending Routine "play_stimuli" ---
            for thisComponent in play_stimuliComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)
            stimuli.stop()
            
            # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
            if routineForceEnded:
                routineTimer.reset()
            else:
                routineTimer.addTime(-4.000000)
            thisExp.nextEntry() #i think this will make the stimuli save to a new line every iteration
            stim_index = stim_index + 1
        
        # --- End experiment ---
        # Flip one final time so any remaining win.callOnFlip() 
        # and win.timeOnFlip() tasks get executed before quitting
        win.flip()
        
          #Begin Routine tab
        last_image_directory = f'/Users/{usr}/Desktop/bbfloc/psychopy/countdown_imgs/'
        
        # Get a list of all image files in the directory
        last_image_files = [f for f in os.listdir(last_image_directory) if f.endswith('.png')]

        # Choose a random image
        random_last_image = random.choice(last_image_files)
        last_image_path = os.path.join(last_image_directory, random_last_image)

        # Set up image stimulus
        last_image = visual.ImageStim(win, size=(768,768), image=last_image_path)

        # Set durations
        last_image_duration = 5.0  # adjust as needed
        
        # Start image presentation
        last_image.draw()
        win.flip()
        core.wait(last_image_duration)
    
        # these shouldn't be strictly necessary (should auto-save)
        thisExp.saveAsWideText(filename+'.csv', delim='auto')
        thisExp.saveAsPickle(filename)
        logging.flush()
        # make sure everything is closed down
        thisExp.abort()  # or data files will save again on exit
    
        #set color codes
        faces = '1 .3 .3'
    
        hands = '1 1 0'
    
        cars = '0 0 1'
    
        scenes = '0 1 0 '
    
        blank = '0 0 0' #for baselines
    
        condition_colors = pd.DataFrame({
            'condition_num': [5, 6, 7, 8, 0],
            'color_code': [faces, hands, cars, scenes, blank]
        })
    
        #build dataframe for conditions par file
        dfs = []
        for index, category in enumerate(category):
            onset_time = onset_nums[index]
            
            # Check if there are any matching elements
            matching_rows = condition_colors.loc[condition_colors['condition_num'] == category, 'color_code']
            
            if not matching_rows.empty:
                # Use .iloc[0] to get the first element if there are duplicates
                color_code = matching_rows.iloc[0]
            else:
                # Handle the case where no matching elements are found
                color_code = '0 0 0'  # Default color for baselines
            
            condition_name = condition_names[index]
            block_cond = block_conds_all[index]
            
            new_data = {'onset_time': onset_time, 'cond_num': category, 'cond_name': condition_name, 'color_code': color_code} 
            new_data_df = pd.DataFrame([new_data])
            
            dfs.append(new_data_df)
        par_file_df = pd.concat(dfs, ignore_index=True)
    
        # export conditions par file
        par_file_df.to_csv(_thisDir + os.sep + u'data/' + str(participant) + '/' + 'mid' '/' + experiment_info_header + 'dynamic_par_file.par', sep='\t', index=False, header=False, lineterminator='\n')
        print("Par file exported successfully!")

# --- close everything ---
win.close()
core.quit()

        
   
