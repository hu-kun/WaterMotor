function soft2wall(byte)

global left_wall
global right_wall
global leftPos_current
global rightPos_current
global leftPos_pre
global rightPos_pre
global gV
global W
global wallLog
global wallMovement

global theta
global ball_Vl
global ball_Vf
global inTrialTrig
global wall_dis_home
global dur_CL_max
global working_path
global trial
global distance_for_max

switch byte
    case 1 % Wall forward period
        inTrialTrig = 1;
        
        %wallLog(end+1,:) = [1, 1];
        if ~isempty(W)
            W.play(1,1); % Channel 1 - File tigger
            W.play(2,2); % Channel 2 - Cam trigger
        end
        l = left_wall.SetVelParams(0,0,500,gV);
        r = right_wall.SetVelParams(0,0,500,gV);
        %wallLog(end+1,:) = [l, r];
        fprintf('Moving left wall to %d, right wall to %d...', leftPos_current, rightPos_current);
        l = left_wall.MoveAbsoluteEx(0,50-leftPos_current ,0,0);
        r = right_wall.MoveAbsoluteEx(0,50-rightPos_current,0,1);

        leftPos_pre = leftPos_current;
        rightPos_pre = rightPos_current;
        %wallLog(end+1,:) = [l, r];
        wallLog = [];
        disp([l,r]);
    case 2 % Wall homing period
        %wallLog(end+1,:) = [2, 2];
        leftPos_current = wall_dis_home;
        rightPos_current = wall_dis_home;
        l = left_wall.SetVelParams(0,0,500,gV);
        r = right_wall.SetVelParams(0,0,500,gV);
        %wallLog(end+1,:) = [l, r];
        fprintf('Homing...');
        l = left_wall.MoveAbsoluteEx(0,50-leftPos_current ,0,0);
        r = right_wall.MoveAbsoluteEx(0,50-rightPos_current,0,1);
        leftPos_pre = leftPos_current;
        rightPos_pre = rightPos_current;
        %wallLog(end+1,:) = [l, r];
        %disp([l,r]);
    case 3 % Wall keep period
        %wallLog(end+1,:) = [3, 3];
        
        if leftPos_current ==  rightPos_current % When current trial is closed loop
            dur_curr_trial = 0;
            distance_curr_trial = 0;
            % Here are the adjustables
            wallMax = leftPos_current-3; % mm
            update_freq = 40; % Hz
            %dur_total = 4; % Seconds
            
            % Init settings
            %trial_count = 1;
            %trial_count_max = dur_total * update_freq; % Currently working on 25 Hz, 6 seconds in total
            typecase = 0;
            preBallV = 0;
            wall_read_switch = 1;
            
            ball_V = ball_Vf * sin(theta) + ball_Vl * cos(theta);
            currentBallV = ball_V;
            
            tic;
            
            while dur_curr_trial < dur_CL_max - 0.01 && distance_curr_trial <= distance_for_max
                if abs(currentBallV) <= 1 % if currentBallV is 0
                    if abs(preBallV) <= 1
                        typecase = 0;  % oo
                    else
                        typecase = 1;  % xo
                    end
                elseif currentBallV > 1
                    if abs(preBallV) <= 1
                        typecase = 4;  % o+
                    else
                        typecase = 2;  % x+
                    end
                else
                    if abs(preBallV) <= 1
                        typecase = 5;  % o-
                    else
                        typecase = 3;  % x-
                    end
                end
                
                % Now it's only check the position of the left wall,
                % because this progress takes 15ms at most.
                wallMovement = 0;
                switch wall_read_switch
                    case 1
                        leftp = 50-left_wall.GetPosition_Position(0);
                        wallMovement = -(leftp - leftPos_current);
                        wall_read_switch = 2;
                        wall_pos_save = leftp;
                    case 2
                        rightp = 50-right_wall.GetPosition_Position(0);
                        wallMovement = (rightp - rightPos_current);
                        wall_read_switch = 1;
                        wall_pos_save = rightPos_current*2-rightp;
                end
                if typecase > 1 % Check if the walls are moving
                    
                    if ismember(typecase, [2 4]) % Check if the left wall is going positive
                        if wallMovement > 0.95*wallMax % Check if the left wall is reaching positive limit. If so, stop
                            if wallMovement > wallMax
                                currentBallV = 0;
                                switch typecase
                                    case 2
                                        typecase = 1;
                                    case 4
                                        typecase = 0;
                                end
                            else
                                % 20191006 update: To slow down the wall when it's getting closer to the limit
                                currentBallV = currentBallV * ((wallMax-abs(wallMovement))/wallMax)^2*16;
                                typecase = 2;
                            end
                        else % Else, keep moving
                            typecase = 2;
                        end
                    else % If the wall is going negetive
                        if wallMovement < -0.95*wallMax % Check if the left wall is reaching negetive limit. If so, stop
                            if wallMovement < -wallMax
                                currentBallV = 0;
                                switch typecase
                                    case 3
                                        typecase = 1;
                                    case 5
                                        typecase = 0;
                                end
                            else
                                currentBallV = currentBallV * ((wallMax-abs(wallMovement))/wallMax)^2*16;
                                typecase = 3;
                            end
                        else
                            typecase = 3;
                        end
                    end
                end
                
                switch typecase
                    case 0
                        %disp("Nothing to be done.");
                    case 1
                        l = left_wall.StopImmediate(0);
                        r = right_wall.StopImmediate(0);
                        if l+r ~= 0
                            %wallLog(end+1,:) = [l, r];
                            disp([l,r]);
                        end
                    case 2 % Left wall moves positive
                        l = left_wall.SetJogVelParams(0,0,100,abs(currentBallV));
                        r = right_wall.SetJogVelParams(0,0,100,abs(currentBallV));
                        if l+r ~= 0
                            %wallLog(end+1,:) = [l, r];
                            disp([l,r]);
                        end
                        l = left_wall.MoveJog(0,1);
                        r = right_wall.MoveJog(0,2);
                        if l+r ~= 0
                            %wallLog(end+1,:) = [l, r];
                            disp([l,r]);
                        end
                    case 3 % Left wall moves negetive
                        l = left_wall.SetJogVelParams(0,0,100,abs(currentBallV));
                        r = right_wall.SetJogVelParams(0,0,100,abs(currentBallV));
                        if l+r ~= 0
                            %wallLog(end+1,:) = [l, r];
                            disp([l,r]);
                        end
                        l = left_wall.MoveJog(0,2);
                        r = right_wall.MoveJog(0,1);
                        if l+r ~= 0
                            %wallLog(end+1,:) = [l, r];
                            disp([l,r]);
                        end
                end
                
                preBallV = currentBallV;
                T_single_update = toc; % Delete the ";" for outputing updating time
                %wallStatus(wallStatus_count+1, trial_count) = wallMovement;
                %wallStatus(wallStatus_count+2, trial_count) = T_single_update;
                %wallStatus(wallStatus_count+3, trial_count) = currentBallV;
                T_wait = 1/update_freq - T_single_update;
                if T_wait > 0
                    pause(T_wait); % Pausing here for a constant updating duration
                    T_single_update = T_single_update + T_wait;                    
                end
                dur_curr_trial = dur_curr_trial + T_single_update;
                
                distance_curr_trial = distance_curr_trial + T_single_update * ball_Vf / 2.6;
                
                wallLog(size(wallLog,1)+1,:) = [dur_curr_trial,wall_pos_save];
                
                tic;
                ball_V = ball_Vf * sin(theta) + ball_Vl * cos(theta);
                currentBallV = ball_V;
                %trial_count = trial_count + 1; %%%%% TO BE IMPROVED: the frequency can be increased. Please test it before doing this.
            end
            if typecase > 1
                l = left_wall.StopImmediate(0);
                r = right_wall.StopImmediate(0);
                if l+r ~= 0
                    %wallLog(end+1,:) = [l, r];
                    disp([l,r]);
                end
            end
        end
    case 4
        if ~isempty(W)
            inTrialTrig = 0;
            W.stop;
        end
        if ~isempty(wallLog)
            csvwrite(strcat(working_path, '\wall\', int2str(trial),'.csv'), wallLog);
            wallLog = [];
            W.stop;
        end
    case 5
        if ~isempty(W)
            W.play(3,3); % Channel 3 - Opto Stimulation
            W.play(4,4); % Channel 4 - Opto Indication
        end
end
end
