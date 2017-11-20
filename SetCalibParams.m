function Calib = SetCalibParams(screenNumber, SKIP_SYNC, displaysize)

global EXPWIN GREY

if(SKIP_SYNC)
    Screen('Preference', 'SkipSyncTests', 1);
end

screens=Screen('Screens');
%Select the screen where the stimulus is going to be presented
if(exist('screenNumber'))
    Calib.screenNumber=screenNumber;
else
     Calib.screenNumber=max(screens);
end


return



