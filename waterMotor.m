function waterMotor(mouseID, wallset, trial, trialname)

%Example:
%    waterMotor(399,1,300,'h-1') -> mouse 399, wallset 1, 300 trials
%    wallsets: 0 for optogenetics. 1-6, 1-2 100% ones, 3-4 98% ones, 5 67% ones, 6 96% ones, 7 for testing

global BpodSystem
global gV
global leftPos_current
global rightPos_current
global trials
global randomList
global distanceLeft
global distanceRight
global velocitySet
global wallStatus
global filename
global working_path
global wallLog
global opto_switch

working_path = 'C:\Users\MNTL-VLASOV-ACCESS\Documents\Animals\';

init_trialdata(working_path, trialname, mouseID, wallset, trial);
init_Bpod;
init_bpodmodules;
init_daq;

if opto_switch == 0
    init_wall;
    for trial = 1:trials
        fprintf('Trial %d...\n', trial);
        %fprintf('Now executing pattern %d...\n', randomList(trial));
        
        if mod(trial,30) == 0
            clean_wall;
            pause(2);
            init_wall;
        end
        
        trialmod = randomList(trial);
        gV = velocitySet(trialmod);
        leftPos_current = 50-distanceLeft(trialmod);
        rightPos_current = 50-distanceRight(trialmod);
        
        sma = NewStateMachine();
        
        sma = AddState(sma, 'Name', 'WFwd', ...
            'Timer', 1,...
            'StateChangeConditions', {'Tup', 'WKeep'},... % Wall Done or time up
            'OutputActions', {'SoftCode', 1, 'LED', 1, 'LED', 2}); % Wall move forward; File trigger start; Cam trigger start
        
        sma = AddState(sma, 'Name', 'WKeep', ...
            'Timer', 4,...
            'StateChangeConditions', {'Tup', 'WBwd'},... % Forward distance reaches limitation or time up
            'OutputActions', {'SoftCode', 3, 'LED',1, 'LED', 2}); % Wall keep; Arduino activation
        
        sma = AddState(sma, 'Name', 'Buffer', ...
            'Timer', 0.3,...
            'StateChangeConditions', {'Tup', 'WBwd'},... % Forward distance reaches limitation or time up
            'OutputActions', {'LED', 2});
        
        sma = AddState(sma, 'Name', 'WBwd', ...
            'Timer', 1,...
            'StateChangeConditions', {'Tup', 'Restart'},... % Wall Done or time up
            'OutputActions', {'SoftCode', 2, 'LED', 2}); % Wall move backward;
        
        sma = AddState(sma, 'Name', 'Restart', ...
            'Timer', 1,...
            'StateChangeConditions', {'Tup', 'exit'},...
            'OutputActions', {'SoftCode', 4}); % Stop playback
        
        BpodSystem.SoftCodeHandlerFunction = 'soft2wall';
        SendStateMachine(sma);
        %SessionData = struct;
        RawEvents = RunStateMachine;
        %SessionData = AddTrialEvents(SessionData, RawEvents);
        
        
    end
    mkdir(working_path);
    csvwrite(strcat(working_path, '\', filename, '_walldata.csv'), wallStatus);
    clear global wallStatus;
    
    clean_wall;
    clean_com;
    
else
    for trial = 1:trials
        fprintf('Trial %d...\n', trial);
        %fprintf('Now executing pattern %d...\n', randomList(trial));

        sma = NewStateMachine();
        
        sma = AddState(sma, 'Name', 'Start', ...
            'Timer', 0.5,...
            'StateChangeConditions', {'Tup', 'Stimulation'},... % Wall Done or time up
            'OutputActions', {}); % Wall move forward; File trigger start; Cam trigger start
        
        sma = AddState(sma, 'Name', 'Stimulation', ...
            'Timer', 1,...
            'StateChangeConditions', {'Tup', 'Restart'},...
            'OutputActions', {'SoftCode', 5}); 
        
        sma = AddState(sma, 'Name', 'Restart', ...
            'Timer', 0.5,...
            'StateChangeConditions', {'Tup', 'exit'},...
            'OutputActions', {'SoftCode', 4}); % Stop playback
        
        BpodSystem.SoftCodeHandlerFunction = 'soft2wall';
        SendStateMachine(sma);
        %SessionData = struct;
        RawEvents = RunStateMachine;
        %SessionData = AddTrialEvents(SessionData, RawEvents);
    end
end
