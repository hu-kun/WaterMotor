function init_trialdata

global trials
global randomList
global distanceLeft
global distanceRight
global velocitySet

mouse = input('Enter the ID of the mouse: ');
nth = input('Which time for this mouse? ');
wallset = input('Which wall set to use (1-10)');
trials = input('How many trials? ');
%trials=10;
date = datetime('today', 'format', 'yyyy-MM-dd');
filename =  strcat('C:\Users\MNTL-VLASOV-ACCESS\Desktop\Behavior Data', num2str(mouse), '_', nth, '_', num2str(wallset), datestr(date), '_','.csv');
randomList = csvread('randomList.csv');
randomList = randomList(wallset, 1:trials);
%headers = {'Pattern', 'Left', 'Right', 'Velocity'};
%order = (1:trials);
distanceLeft = [15,35,35,35,5,10,15,35];
distanceRight = [15,5,10,15,35,35,35,35];
velocitySet = [50,35,28,22,35,28,22];
%list = [order', randomList', distanceLeft(randomList)', distanceRight(randomList)', velocitySet(randomList)'];
%csvwrite(filename, list);