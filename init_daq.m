function init_daq

global da
global ball_V
global lh

ball_V = 0;

da = daq.createSession('ni');
da.addAnalogInputChannel('YV-USB6366-32-0',[0,1,2,3],'Voltage');
da.IsContinuous = 1;

lh = da.addlistener('DataAvailable', @(src, event) read_daq_2(event));
da.Rate = 50000;
da.NotifyWhenDataAvailableExceeds = 100;

da.startBackground();