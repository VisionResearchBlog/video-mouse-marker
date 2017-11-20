sca; clear all; clc;
global EXPWIN GREY

%videoname='~/Desktop/MouseSelectingTool/example.MP4';
%datadir=[pwd '/'];

datadir='/Volumes/SAMSUNG1TB/GLANCE/EyeHead_Exp/smi_data/data/';
videoname=[datadir '0A/Scan Path_OA_HORZ_OA_HORZ-1-recording.mp4'];

Volume=1; %1=max, 0=mute sound

% Default preload setting:
maxThreads = [];
shader=[];
pixelFormat = [];
preloadsecs = [];
data=[];

Screen('Preference', 'SkipSyncTests', 1)


try
    
    filename=input('Please type Subject ID - then press enter: ','s');
    
    MONITOR=0; %set to zero main monitor
    SKIP_SYNC=1; %Should be set to 0 for best timing but often fails
    Calib = SetCalibParams(MONITOR, SKIP_SYNC);
catch me
    %save('test0.mat','me')
    keyboard
end

try
    
    vidObj=VideoReader(videoname);
    
    [EXPWIN, winRect] = Screen('OpenWindow', Calib.screenNumber,...
        [255 255 255], [0 0 vidObj.Width vidObj.Height]);
    
    Priority(1);
    AssertOpenGL;
    Screen('TextStyle', EXPWIN, 1);
    Screen('TextFont',EXPWIN, 'Arial');
    Screen('TextSize',EXPWIN, 32);
    Screen('TextColor',EXPWIN, [0 0 0]);
    
    % Open movie file and retrieve basic info about movie:
    [ movie, duration, fps, width, height, count, aspectRatio] =...
        Screen('OpenMovie', EXPWIN, videoname, [], preloadsecs, ...
        [], pixelFormat, maxThreads);
    

    
    vidtest
catch me
    %save('test2.mat','me')
    keyboard
end

Screen('CloseAll')

fprintf('DataFile: %s\n', filename );
save(filename, 'data', 'filename', 'frames', 'vidObj');

