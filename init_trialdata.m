function init_trialdata(working_path, trialname, mouseID, wallset, trial)

global trials
global randomList
global distanceLeft
global distanceRight
global velocitySet
global wallStatus
global filename
%global working_path
global wallLog
global opto_switch
wallLog = [];

mouseID = num2str(mouseID);%input('Mouse ID: '));
%wallset = input('Wall set ramdom list selection (0 for optogenetics. 1-6, 1-2 100% ones, 3-4 98% ones, 5 67% ones, 6 96% ones, 7 for testing): '); % randomList_V3.csv
% For randomList_V2.csv
% wallset = input('Wall set ramdom list selection (1-10, 1-2 all ones, 3-4 1/2 ones, 5-10 1/3 ones): ');
%trialname = input('How would you like to name this session? Please add single quatation marks. ');
trials = trial;%input('How many trials? ');
%trials=10;
date = datestr(datetime('today', 'format', 'MMddyyyy'));
filename =  strcat(mouseID, '_', num2str(wallset), '_', trialname, '_', date);

if wallset == 0
    opto_switch = 1;
else
    opto_switch = 0;
    randomList = csvread('randomList_V3.csv');
    randomList = randomList(wallset, 1:trials);
    %headers = {'Pattern', 'Left', 'Right', 'Velocity'};
    %order = (1:trials);
    distanceLeft = [15,30,30,30,5,10,15,30];
    distanceRight = [15,5,10,15,30,30,30,30];
    velocitySet = [22,35,28,22,35,28,22];
    %list = [order', randomList', distanceLeft(randomList)', distanceRight(randomList)', velocitySet(randomList)'];
    %csvwrite(filename, list);
    
    working_path = strcat(working_path, '\', mouseID);
    wallStatus = 0;
    
    filename_log = fullfile(working_path, 'log-walls.csv');
    log_wall.MouseID = mouseID;
    log_wall.Date = date;
    log_wall.Trial = trialname;
    log_wall.Pattern = num2str(wallset);
    if isfile(filename_log)
        log_walls = table2struct(readtable(filename_log, 'Format','%s%s%s%s'));
        log_walls = [log_walls; log_wall];
    else
        log_walls = log_wall;
    end
    writetable(struct2table(log_walls), filename_log);
    
    
    load('BehaviorRecordsBeh.mat');
    BehaviorRecordsBeh=[BehaviorRecordsBeh,filename];
    save('BehaviorRecordsBeh.mat','BehaviorRecordsBeh');
end