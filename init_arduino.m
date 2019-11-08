function init_arduino

global ard

if isempty(ard)
    ard = serial('COM6');
    ard.ReadAsyncMode = 'Manual';
    ard.Baudrate = 9600;
    %ard.Timeout = 0.001;
end

if ~isempty(ard) & strcmp(ard.Status, 'closed')
    fopen(ard);
end