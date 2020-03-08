function init_wall

global left_wall
global right_wall
global atx_left_wall
global atx_right_wall

if isempty(left_wall) | isempty(right_wall)
    % Create Matlab Figure Container
    fpos    = get(0,'DefaultFigurePosition');
    fpos(3) = 650; % figure window size;Width
    fpos(4) = 450; % Height
    
    atx_left_wall = figure('Position', fpos,...
        'Menu','None',...
        'Name','APT GUI');
    atx_right_wall = figure('Position', fpos,...
        'Menu','None',...
        'Name','APT GUI');
    
    % Create ActiveX Controller
    left_wall = actxcontrol('MGMOTOR.MGMotorCtrl.1',[20 20 600 400 ], atx_left_wall);
    right_wall = actxcontrol('MGMOTOR.MGMotorCtrl.1',[20 20 600 400 ], atx_right_wall);
    
    % Initialize & Start Control
    left_wall.StartCtrl;
    right_wall.StartCtrl;
    
    % Set the Serial Number
    SN1 = 28250158;
    SN2 = 28250420;
    set(left_wall,'HWSerialNum', SN1);
    set(right_wall,'HWSerialNum', SN2);
end

left_wall.registerevent({'MoveComplete' 'Handler_MoveComplete'});
right_wall.registerevent({'MoveComplete' 'Handler_MoveComplete'});
left_wall.registerevent({'HomeComplete' 'Handler_HomeComplete'});
right_wall.registerevent({'HomeComplete' 'Handler_HomeComplete'});
left_wall.registerevent({'MoveStopped' 'Handler_MoveStopped'});
right_wall.registerevent({'MoveStopped' 'Handler_MoveStopped'});
left_wall.registerevent({'SettingsChanged' 'Handler_SettingsChanged'});
right_wall.registerevent({'SettingsChanged' 'Handler_SettingsChanged'});
%    {'MoveComplete'    }    {'MoveComplete'       }
%    {'HomeComplete'    }    {'MoveComplete'       }
%    {'MoveStopped'     }    {'MoveComplete'       }
%    {'HWResponse'      }    {'MoveComplete'       }
%    {'SettingsChanged' }    {'MoveComplete'       }
%    {'EncCalibComplete'}    {'MoveComplete'       }
%    {'PositionClick'   }    {'MoveComplete'       }
%    {'PositionDblClick'}    {'MoveComplete'       }
%    {'HWPoweredDown'   }    {'MoveComplete'       }

pause(1);
left_wall.MoveHome(0, 0);
pause(1);
right_wall.MoveHome(0, 0);
pause(3);
SetJogMode(left_wall,0,1,1);
SetJogMode(right_wall,0,1,1);
pause(1);
SetJogVelParams(left_wall,0,0,500,1);
SetJogVelParams(right_wall,0,0,500,1);
pause(1);
SetStageAxisInfo(left_wall,0,3,45,1,1,1);
SetStageAxisInfo(right_wall,0,3,45,1,1,1);
pause(0.1);