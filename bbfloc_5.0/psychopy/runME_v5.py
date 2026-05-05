# --- Import packages --

import ffpyplayer
print("ffpyplayer is installed!")

from psychopy import locale_setup
from psychopy import prefs
from psychopy import plugins
import logging
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
import random
import psychopy.iohub as io
from psychopy.hardware import keyboard
import pandas as pd

current_directory = os.getcwd()
print("Current Working Directory:", current_directory)
# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__))
os.chdir(_thisDir)

# ======================== get gui inputs ============================ 
# Store info about the experiment session
psychopyVersion = '2023.2.2'
expName = 'newbabyloc'  # from the Builder filename that created this script
expInfo = {
    'participant': f"bb119",
    'run': '1',
    'user': 'ctyagi',
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
    backgroundImage = f'/Users/{usr}/Desktop/bbfloc_5.0/stimuli/background_color.png', backgroundFit='cover', 
    blendMode='avg', useFBO=True, 
    units='pix')
win.mouseVisible = False

#in scanner: size=(1920, 1080), fullscr = 1
#out of scanner: size=(960, 540), screen=0 

# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur =  1.0 / 60.0
else:
    frameDur = win.getActualFrameRate()  
    
print(frameDur)

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

# Load the audio file
sound_path =  _thisDir + '/' + f'audio{run_num}.mp3'
bg_audio = sound.Sound(sound_path, loops=0)  # loops=0 means play once

# Define the path to your video file
video_path = _thisDir + '/data/' + str(participant) + '/' + f'run{run_num}.mp4' 
print(f"Video path: {video_path}")

# Create a MovieStim object to load the video
#movie = visual.MovieStim3(win, video_path, size=(1920, 1080),  flipVert=False, flipHoriz=False)
movie = visual.MovieStim3(win, video_path,  flipVert=False, flipHoriz=False)

# win.flip()

# ======================== load initializing screens  for run ============================
# --- Load instructions screen info ---
instructions_screen = visual.TextStim(win=win, name='instructions_screen',
    text='Press space bar to proceed.',
    font='Open Sans',
    pos=(0, 0), height=1, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);
intructions_response = keyboard.Keyboard()

# --- Load "wait_for_trigger" screen info ---
waiting_for_trigger_text = visual.TextStim(win=win, name='waiting_for_trigger_text',
    text='Waiting for trigger (t)...',
    font='Open Sans',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);
trigger = keyboard.Keyboard()

# --- load countdown screen ---
countdown = visual.TextStim(win=win, name='countdown',
    text='',
    font='Open Sans',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);
    
from pathlib import Path

#get log file name 
log_directory = (_thisDir + '/data/' + str(participant) + '/output/')
filename = os.path.join(log_directory, f'{participant}_run{run_num}')  
# save a log file for detail verbose info
logFile = logging.LogFile(filename+'.log', level=logging.EXP)
logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath=f'/Users/{usr}/Desktop/bbfloc',
    savePickle=True, saveWideText=True,
    dataFileName=filename)

# --- Create some handy timers---
globalClock = core.Clock()  # to track the time since experiment started
routineTimer = core.Clock()  # to track time remaining of each (possibly non-slip) routine 

# --- Prepare to start Routine "instructions" ---
continueRoutine = True
# update component parameters for each repeat
intructions_response.keys = []
intructions_response.rt = []
_intructions_response_allKeys = []
# keep track of which components have finished
instructionsComponents = [instructions_screen, intructions_response]
for thisComponent in instructionsComponents:
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

# --- Run Routine "instructions" ---
routineForceEnded = not continueRoutine
while continueRoutine:
    # get current time
    t = routineTimer.getTime()
    tThisFlip = win.getFutureFlipTime(clock=routineTimer)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    # *instructions_screen* updates
    # if instructions_screen is starting this frame...
    if instructions_screen.status == NOT_STARTED and tThisFlip >= 0-frameTolerance:
        # keep track of start time/frame for later
        instructions_screen.frameNStart = frameN  # exact frame index
        instructions_screen.tStart = t  # local t and not account for scr refresh
        instructions_screen.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(instructions_screen, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'instructions_screen.started')
        # update status
        instructions_screen.status = STARTED
        instructions_screen.setAutoDraw(True)
    
    # if instructions_screen is active this frame...
    if instructions_screen.status == STARTED:
        # update params
        pass
    
    # *intructions_response* updates
    waitOnFlip = False
    
    # if intructions_response is starting this frame...
    if intructions_response.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        intructions_response.frameNStart = frameN  # exact frame index
        intructions_response.tStart = t  # local t and not account for scr refresh
        intructions_response.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(intructions_response, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'intructions_response.started')
        # update status
        intructions_response.status = STARTED
        # keyboard checking is just starting
        waitOnFlip = True
        win.callOnFlip(intructions_response.clock.reset)  # t=0 on next screen flip
        win.callOnFlip(intructions_response.clearEvents, eventType='keyboard')  # clear events on next screen flip
    if intructions_response.status == STARTED and not waitOnFlip:
        theseKeys = intructions_response.getKeys(keyList=['y','n','left','right','space'], waitRelease=False)
        _intructions_response_allKeys.extend(theseKeys)
        if len(_intructions_response_allKeys):
            intructions_response.keys = _intructions_response_allKeys[-1].name  # just the last key pressed
            intructions_response.rt = _intructions_response_allKeys[-1].rt
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
    for thisComponent in instructionsComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# --- Ending Routine "instructions" ---
for thisComponent in instructionsComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if intructions_response.keys in ['', [], None]:  # No response was made
    intructions_response.keys = None
thisExp.addData('intructions_response.keys',intructions_response.keys)
if intructions_response.keys != None:  # we had a response
    thisExp.addData('intructions_response.rt', intructions_response.rt)
thisExp.nextEntry()
# the Routine "instructions" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

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
# After collecting a response
response = event.getKeys()
# Log the exact time of trigger keypress using globalClock
trigger_time = globalClock.getTime()
thisExp.addData('trigger_time', trigger_time)
event.clearEvents()

# ========================= Start Experiment RUN Loop =======================
continueRoutine = True

# Start audio and video together
bg_audio.play()
movie.play()  # Start playing the movie
# Record the time the video started (using globalClock)
video_start_time = globalClock.getTime()
thisExp.addData('video_started', video_start_time)  # Log the start time of the video

# check for quit (typically the Esc key)
if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
   core.quit()

# Track the current frame for debugging and progress
frame_counter = 0
frame_counter = 0
frame_times = []  # for debugging frame drops

#if run_num % 2 != 0:
#    max_frames = 13860  # num of frames in the combined 7min42s run
#else:
#max_frames = 12360 # 6180 #num of frames in the kosakowski stim only run

# Loop to display the video and update the window
while movie.status != visual.FINISHED: # and frame_counter < max_frames:
    movie.draw()  # Draw the current frame of the movie
    win.flip()    # Update the window to show the current frame
    
    frame_counter += 1  # Increment the frame counter

    # Optional: Debugging output to check if the video is updating correctly
    # print(f"Current frame: {frame_counter}, movie status: {movie.status}")
    # check for quit (typically the Esc key)
    if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()

video_end_time = globalClock.getTime()  # Record the time when the video finishes
win.close()

# Once the video finishes, perform cleanup

thisExp.addData('video_finished', video_end_time)  # Log the end time of the video

# Calculate and log the video duration (optional)
video_duration = video_end_time - video_start_time
thisExp.addData('video_duration', video_duration)  # Log the duration of the video

# Save the data (only once after the video ends)
thisExp.saveAsWideText(filename + '.csv', delim='auto')  # Save the data to CSV
thisExp.saveAsPickle(filename)  # Save as a pickle file for later use
logging.flush()

# Debugging print statements to confirm the flow
print(f"Video start time: {video_start_time}")
print(f"Video end time: {video_end_time}")
print(f"Video duration: {video_duration}")

# Ensure everything is closed down after the video finishes
win.close()      # Close the window
core.quit()      # Quit the experiment




