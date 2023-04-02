%% Init
global BpodSystem
global gV
global leftPos_current
global rightPos_current
global num_trial
global randomList
global distanceLeft
global distanceRight
global velocitySet
%global wallStatus
%global filename
global working_path
%global wallLog
%global opto_switch
global theta
%global thetaSet
global trial
global wall_dis_home
global dur_CL_max
global left_wall
global right_wall
 
%% Input parameters
working_path = pwd;
%trialname = 'h1';
%mouseID = 0;
num_trial = 10;
wall_dis_home = 30;
wall_dis_CL = 16;
wall_dis_OL_L = [8];
wall_dis_OL_R = [6,8,14];
p_wall_CL = 1;
p_wall_CL_L = 0;
p_wall_CL_R = 0;
p_wall_OL_L = [0];
p_wall_OL_R = [0,0,0];
opto_switch = 0;
dur_CL_max = 12;
 
%% Generate random list
var_names = {'trial_type','wall_distance','theta'};
var_types = {'string','double','double'};
 
rows_L = sum(round(p_wall_OL_L*num_trial));
tb_OL_L = table('Size',[rows_L,3],'VariableTypes',var_types,'VariableNames',var_names);
tb_OL_L.trial_type(:) = 'OL_L';
wall_distance = [];
for w = wall_dis_OL_L
    wall_distance = [wall_distance;repmat(w,round(p_wall_OL_L(wall_dis_OL_L==w)*num_trial),1)];
end
tb_OL_L.wall_distance = wall_distance;
tb_OL_L.theta(:) = 0;
 
wall_distance = [];
rows_R = sum(round(p_wall_OL_R*num_trial));
tb_OL_R = table('Size',[rows_R,3],'VariableTypes',var_types,'VariableNames',var_names);
tb_OL_R.trial_type(:) = 'OL_R';
wall_distance = [];
for w = wall_dis_OL_R
    wall_distance = [wall_distance;repmat(w,round(p_wall_OL_R(wall_dis_OL_R==w)*num_trial),1)];
end
tb_OL_R.wall_distance = wall_distance;
tb_OL_R.theta(:) = 0;
 
wall_distance = [];
rows_CL = sum(round(p_wall_CL*num_trial));
tb_CL = table('Size',[rows_CL,3],'VariableTypes',var_types,'VariableNames',var_names);
tb_CL.trial_type(:) = 'CL';
wall_distance = [];
for w = wall_dis_CL
    wall_distance = [wall_distance;repmat(w,round(p_wall_CL(wall_dis_CL==w)*num_trial),1)];
end
tb_CL.wall_distance = wall_distance;
tb_CL.theta(:) = 0;
 
wall_distance = [];
rows_CL_L = sum(round(p_wall_CL_L*num_trial));
tb_CL_L = table('Size',[rows_CL_L,3],'VariableTypes',var_types,'VariableNames',var_names);
tb_CL_L.trial_type(:) = 'CL_L';
wall_distance = [];
for w = wall_dis_CL
    wall_distance = [wall_distance;repmat(w,round(p_wall_CL_L(wall_dis_CL==w)*num_trial),1)];
end
tb_CL_L.wall_distance = wall_distance;
tb_CL_L.theta(:) = 11/360*2*pi;
 
wall_distance = [];
rows_CL_R = sum(round(p_wall_CL_R*num_trial));
tb_CL_R = table('Size',[rows_CL_R,3],'VariableTypes',var_types,'VariableNames',var_names);
tb_CL_R.trial_type(:) = 'CL_R';
wall_distance = [];
for w = wall_dis_CL
    wall_distance = [wall_distance;repmat(w,round(p_wall_CL_R(wall_dis_CL==w)*num_trial),1)];
end
tb_CL_R.wall_distance = wall_distance;
tb_CL_R.theta(:) = -11/360*2*pi;
 
randomList = [tb_OL_L;tb_OL_R;tb_CL;tb_CL_L;tb_CL_R];
randomList = randomList(randperm(height(randomList)),:);
 
% Insert buffer
for r = height(randomList):-1:2
    if ismember(randomList.trial_type(r), ["OL_R","OL_L"]) && ismember(randomList.trial_type(r-1), ["OL_R","OL_L"])
        randomList = [randomList(1:r,:); {'CL', wall_dis_CL, 0}; randomList(r+1:end,:)];
    end
end
 
randomList = randomList(1:num_trial,:);
 
randomList.trial = [0:height(randomList)-1]';
 
mkdir(working_path);
%mkdir(strcat(working_path,'\ball'));
mkdir(strcat(working_path,'\wall'));
 
writetable(randomList,strcat(working_path,'\randomList.csv'),'Delimiter',',','WriteRowNames',true);
 
num_trial = height(randomList);
 
%%
%init_trialdata(working_path, trialname, mouseID, num_trial);
init_Bpod;
init_bpodmodules;
init_daq;
 
dis2speed = readtable('wall_dis2speed.csv');
 
if opto_switch == 0
    init_wall;
    for t = 0:num_trial-1
        trial = t;
        
        
        %fprintf('Now executing pattern %d...\n', randomList(trial));
        
        trial_curr = randomList(randomList.trial==trial,:);
        %trialmod = randomList(trial);
        
        fprintf('Trial %d, %s...\n', trial, trial_curr.trial_type);
        
        if ismember(trial_curr.trial_type,["CL","CL_L","CL_R"])
            leftPos_current = trial_curr.wall_distance;
            rightPos_current = trial_curr.wall_distance;
        elseif strcmp(trial_curr.trial_type,'OL_L')
            leftPos_current = trial_curr.wall_distance;
            rightPos_current = wall_dis_home;
        else
            leftPos_current = wall_dis_home;
            rightPos_current = trial_curr.wall_distance;
        end
        theta = trial_curr.theta;
        gV = dis2speed(dis2speed.wall==trial_curr.wall_distance,:).speed;
        
        gV = gV * 1.5;
        
        sma = NewStateMachine();
        
        sma = SetCondition(sma, 1, 'BNC1', 1);
        
        sma = AddState(sma, 'Name', 'WFwd', ...
            'Timer', 1,...
            'StateChangeConditions', {'Tup', 'WKeep'},... % Wall Done or time up
            'OutputActions', {'SoftCode', 1}); % Wall move forward; File trigger start; Cam trigger start
        
        sma = AddState(sma, 'Name', 'WKeep', ...
            'Timer', dur_CL_max,...
            'StateChangeConditions', {'BNC2High', 'Buffer', 'Tup', 'Buffer'},... % Forward distance reaches limitation or time up
            'OutputActions', {'SoftCode', 3, 'LED', 2}); % Wall keep; Arduino activation
        
        sma = AddState(sma, 'Name', 'Buffer', ...
            'Timer', 0,...
            'StateChangeConditions', {'Tup', 'WBwd'},...
            'OutputActions', {'SoftCode', 4});
        
        sma = AddState(sma, 'Name', 'WBwd', ...
            'Timer', 1,...
            'StateChangeConditions', {'Tup', 'Restart'},... % Wall Done or time up
            'OutputActions', {'SoftCode', 2}); % Wall move backward;
        
        sma = AddState(sma, 'Name', 'Restart', ...
            'Timer', 0,...
            'StateChangeConditions', {'Tup', 'exit'},...
            'OutputActions', {}); % Stop playback
        
        BpodSystem.SoftCodeHandlerFunction = 'soft2wall';
        SendStateMachine(sma);
        RawEvents = RunStateMachine;        
    end
    %csvwrite(strcat(working_path, '\', filename, '_walldata.csv'), wallStatus);
    clear global wallStatus;
    left_wall.MoveHome(0, 0);
    right_wall.MoveHome(0, 0);
    clean_wall;
    clean_com;
else
    for trial = 1:num_trial
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
            'OutputActions', {'SoftCode', 5, 'LED', 1}); 
        
        sma = AddState(sma, 'Name', 'Restart', ...
            'Timer', 0.5,...
            'StateChangeConditions', {'Tup', 'exit'},...
            'OutputActions', {'SoftCode', 4}); % Stop playback
        
        BpodSystem.SoftCodeHandlerFunction = 'soft2wall';
        SendStateMachine(sma);
        RawEvents = RunStateMachine;
    end
end

