global da

sum = 0;
for i = 1:10000
    sum = sum + read_daq(da);
    pause(0.01);
end
sum = sum / 10000

% Results for total, single channel, nonstop -> 123.278 -> 12.33 ms per read
% Results for total, single channel, pause 30 ms each read -> 427.378 - 300 = 127.378 - > 12.38 ms per read
% Results for total, multiple channel, pause 10 ms each read -> 236.580 - 100 = 136.580 -> 13.58 ms per read
