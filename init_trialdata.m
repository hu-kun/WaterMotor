function init_trialdata

global trials
global randomList
global distanceLeft
global distanceRight
global velocitySet
global wallStatus
global filename
global working_path
global wallLog

wallLog = [];

working_path = '\\mntl-vlasov-srv.ad.uillinois.edu\Projects\Users\Ryan\Data';

mouse = input('Mouse ID: ');
wallset = input('Wall set ramdom list selection (1-5, 1-2 100% ones, 3-4 98% ones, 5-10 67% ones): '); % randomList_V3.csv
% For randomList_V2.csv
% wallset = input('Wall set ramdom list selection (1-10, 1-2 all ones, 3-4 1/2 ones, 5-10 1/3 ones): ');
trialname = input('How would you like to name this session? Please add single quatation marks. ');
trials = input('How many trials? ');
%trials=10;
date = datetime('today', 'format', 'yyyy-MM-dd');
filename =  strcat(num2str(mouse), '_', num2str(wallset), '_', trialname, '_', datestr(date));
randomList = csvread('randomList_V3.csv');
randomList = randomList(wallset, 1:trials);
%headers = {'Pattern', 'Left', 'Right', 'Velocity'};
%order = (1:trials);
distanceLeft = [15,30,30,30,5,10,15,30]+10;
distanceRight = [15,5,10,15,30,30,30,30]+10;
velocitySet = [22,35,28,22,35,28,22];
%list = [order', randomList', distanceLeft(randomList)', distanceRight(randomList)', velocitySet(randomList)'];
%csvwrite(filename, list);

working_path = strcat(working_path, '\', num2str(mouse));
wallStatus = 0;

load('BehaviorRecordsBeh.mat');
BehaviorRecordsBeh=[BehaviorRecordsBeh,filename];
save('BehaviorRecordsBeh.mat','BehaviorRecordsBeh');