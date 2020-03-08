sampling_rate = 50000;
dur_open_loop = 6.3;
dur_close_loop = 1;
dur_opto = 1;
freq_opto = 20; 

waves = [];
% Channel 1, all high
waves(1,:) = 5*ones(1,round(dur_open_loop*sampling_rate));

% Channel 1, high & low, frequency = 1/2 * sampling_rate
waves(2,:) = 5*ones(1,round(dur_open_loop*sampling_rate));
waves(2,2:2:end) = 0;

% Channel 3, optogenetics stimulation
opto_sine = 2.5*(sin(((freq_opto*2*pi/sampling_rate)*[0:dur_opto*sampling_rate-1])-0.5*pi)+1);
waves(3,1:length(opto_sine)) = opto_sine;

%channel 4, opto beginning indication, 2ms
opto_indic = zeros(1,dur_opto*sampling_rate/freq_opto);
opto_indic(1:sampling_rate/500) = 5;
opto_indic = repelem(opto_indic, freq_opto*dur_opto);
waves(4,1:length(opto_indic)) = opto_indic;

csvwrite('waveforms.csv', waves, 0, 0)