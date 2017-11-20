
Program to annotate eye gaze x,y coordinates in reference to calibration
pattern.  Use the key mappings below to advance to the appropriate video
times and then pause the video. Per frame, first click should be the
calibration point and 2nd the eye tracker point-of-gaze cursor. 

Run & edit StartVid.m to get started.
Enter the visual angle FOV of your scene camera for proper calculation of visual angle.

Note, briefly tap the space key to trigger pausing, long presses may cause
pause & unpause.


Keys while playing:
W: Increase playing rate
S: Decrease playing rate
A: Rewind by 30s
D: Advance by 30s
SPACE: Pause for mouse select

Keys while pausing:
A: Rewind for 1 frame
D: Advance for 1 frame
SPACE: Continue to play
Mouse click 1st time: Select and record Point 1
Mouse click 2nd time: Select and record Point 2

Datafile format:
Column 1: Time index
Column 2: Frame No.
Column 3, 4: Calibration point X,Y coordinate in pixels
Column 5, 6: Eye POG cursor X,Y coordinate in pixels
Column 7, 8: 1-dimensional X,Y error in visual angle
Column 9: Total 2D error in visual angle

