% Initialize with unified keynames and normalized colorspace:
PsychDefaultSetup(2);

% Playbackrate defaults to 1:
rate=1;
% Use blocking wait for new frames by default:
blocking = 1;
maxrate=3.0;
minrate=0.1;
timeindex=0;
framenum=1;

% Setup key mapping:
esc=KbName('ESCAPE');
right=KbName('d');
left=KbName('a');
up=KbName('w');
down=KbName('s');
space=KbName('space');

frames=vidObj.NumberOfFrames;
frametime=(0:(frames/2))*(1/vidObj.FrameRate);
rating=zeros(length(frametime),1);


disp('waiting to start')
Screen('DrawText', EXPWIN, 'When ready, press spacebar...', 0,20);
Screen('Flip',EXPWIN)
while(1)
    [~,~,keyCode] = KbCheck;
    %find(keyCode)
    if( keyCode(space) ) % press 'space'
        disp('start  movie......')
        
        break
    end
end

pausing = 0;
ShowCursor('CrossHair');
n = 0;
paired = 0;
x1=0; x2=0; y1=0; y2=0;
WaitSecs(0.1);

Screen('PlayMovie', movie, rate, 1, Volume);
while ((1+timeindex)<duration)
    [val,idx]=min(abs(timeindex-frametime));
    framenum=idx;
    
    [~,~,keyCode] = KbCheck;
    
    if ~pausing
        tex = Screen('GetMovieImage', EXPWIN, movie, blocking);
        
        % Draw the new texture immediately to screen:
        Screen('DrawTexture', EXPWIN, tex, [], [], [], [], [], [], shader);
        
        
        timeindex=Screen('GetMovieTimeIndex', movie);
        
        Screen('DrawText', EXPWIN, num2str(timeindex), 0,10);
        Screen('DrawText', EXPWIN, ['Rate: x' num2str(rate)], 0,35);
        
        % Update display:
        Screen('Flip', EXPWIN);
    end
       
    
    if( rate<=maxrate ) && ~pausing
        if keyCode(up)
            % Increase playback rate by 1 unit.
            rate=rate+0.1; %disp(rate)
        end
    end
    
    if(rate>=minrate)&& ~pausing
        if keyCode(down)
            % Decrease playback rate by 1 unit.
            rate=rate-0.1; %disp(rate)
        end
    end
    
    % Further keyboard checks...
    if ~pausing
        step=30; %# seconds to advance
    else
        step=1/vidObj.FrameRate;
    end
    
    if( (timeindex + step) < (duration-1) )
        if ( keyCode(right))
            % Advance movietime by one second:
            Screen('SetMovieTimeIndex', movie, ...
                Screen('GetMovieTimeIndex', movie) + step);
            
            tex = Screen('GetMovieImage', EXPWIN, movie, blocking);
            
            % Draw the new texture immediately to screen:
            Screen('DrawTexture', EXPWIN, tex, [], [], [], [], [], [], shader);
            
            timeindex=Screen('GetMovieTimeIndex', movie);
            
            Screen('DrawText', EXPWIN, num2str(timeindex), 0,10);
            Screen('DrawText', EXPWIN, ['Rate: x' num2str(rate)], 0,35);
            
            % Update display:
            Screen('Flip', EXPWIN);
            
        end
    end
    
    if( (timeindex - step) > 0 )
        if (keyCode(left))
            % Rewind movietime by one second:
            Screen('SetMovieTimeIndex', movie, ...
                Screen('GetMovieTimeIndex', movie) - step);
            tex = Screen('GetMovieImage', EXPWIN, movie, blocking);
            
            % Draw the new texture immediately to screen:
            Screen('DrawTexture', EXPWIN, tex, [], [], [], [], [], [], shader);
            
            timeindex=Screen('GetMovieTimeIndex', movie);
            
            
            Screen('DrawText', EXPWIN, num2str(timeindex), 0,10);
            Screen('DrawText', EXPWIN, ['Rate: x' num2str(rate)], 0,35);
            
            % Update display:
            Screen('Flip', EXPWIN);
            
        end
    end
    
    if (keyCode(space))
        
        if pausing
            %replay
            rate = 1;
            pausing = 0;
        else
            Screen('PlayMovie', movie, 0,[],Volume);
            pausing = 1;
        end
        WaitSecs(0.1);
    end
    
    
    if pausing
        [x,y,buttons] = GetMouse;
        pressed = 0;
        while buttons(1)
            pressed = 1;
            [x,y,buttons] = GetMouse;
        end
        if x>vidObj.Width || y>vidObj.Height
            pressed = 0;
        end
        if pressed
            if paired
                x2 = x;
                y2 = y;
                n = n+1;
                data(n, 1) = timeindex;
                data(n, 2) = framenum;
                data(n, 3) = x1;
                data(n, 4) = y1;
                data(n, 5) = x2;
                data(n, 6 ) = y2;
                paired = 1 - paired;
                
                Screen('DrawTexture', EXPWIN, tex, [], [], [], [], [], [], shader);
                Screen('DrawText', EXPWIN, num2str(timeindex), 0,10);
                Screen('DrawText', EXPWIN, ['Rate: x' num2str(rate)], 0,35);
                Screen('DrawText', EXPWIN, ['Gaze Location: (' num2str(x) ...
                    ',' num2str(y) ')'], 0,60);
                
                % Update display:
                Screen('Flip', EXPWIN);
                
                
            else
                x1 = x;
                y1 = y;
                paired = 1 - paired;
                
                
                Screen('DrawTexture', EXPWIN, tex, [], [], [], [], [], [], shader);
                Screen('DrawText', EXPWIN, num2str(timeindex), 0,10);
                Screen('DrawText', EXPWIN, ['Rate: x' num2str(rate)], 0,35);
                Screen('DrawText', EXPWIN, ['Calibration Point: (' num2str(x) ...
                    ',' num2str(y) ')'], 0,60);
                
                % Update display:
                Screen('Flip', EXPWIN);
                
            end
        end
    end
    
    if ~pausing
        Screen('PlayMovie', movie, rate, 1, Volume);
    end
    
    % Release texture:
    if ~pausing
        Screen('Close', tex);
    end
    %exit strategy
    if (keyCode(esc))
        break
    end
end

Screen('Flip', EXPWIN);
KbReleaseWait;

% Done. Stop playback:
Screen('PlayMovie', movie, 0, Volume);

% Close movie object:
Screen('CloseMovie', movie);