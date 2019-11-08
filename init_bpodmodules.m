function init_bpodmodules

global W
global A

% Input module setting
if isempty(A)
    A = BpodAnalogIn('COM3');
end
A.Thresholds(1:8) = 2.5;
A.ResetVoltages(1:8) = 1;
A.SMeventsEnabled(1:8) = 1;
if isempty(A)
    A.startReportingEvents();
end

% Output module setting
if isempty(W)
    W = BpodWavePlayer('COM5');
end
W.SamplingRate = 200;
W.OutputRange = '0V:5V';
W.TriggerProfileEnable = 'On';
W.TriggerProfiles(1,1) = 1;
W.TriggerProfiles(2,2) = 2;
W.TriggerProfiles(3,3) = 3;
W.TriggerProfiles(4,4) = 2;
waves = csvread('waveforms.csv');
wave5 = 5*ones(1,10);
wave0 = waves(2,:);
wave0 = 0.5 * wave0;
W.loadWaveform(1, waves(1,:));    % Continous
W.loadWaveform(2, wave0); % For the high speed camera
W.loadWaveform(3, wave5); % Trigger signal
W.TriggerMode = 'Normal';

% Output module waveform setting
%LoadSerialMessages('WavePlayer1', {['P' 1 1]}); % 1 Short trigger %Arduino activation
%LoadSerialMessages('WavePlayer1', {['P' 2]}); % 2 File Trigger
%LoadSerialMessages('WavePlayer1', {['P' 3]}); % 3 High speed cam
%LoadSerialMessages('WavePlayer1', {['P' 1]}); % 4