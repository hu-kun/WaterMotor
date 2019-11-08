function init_daq

global da

da = daq.createSession('ni');
da.Rate = 100000;
addAnalogInputChannel(da,'Dev2',[0,1,2,3],'Voltage');