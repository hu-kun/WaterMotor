sum = [0, 0, 0, 0];
for i = 1:10000
    v_raw = 0;
    for i = 1:3
        v_raw = v_raw + da.inputSingleScan;
    end
    v_raw = v_raw / 3;
    sum = sum + v_raw;
    %pause(0.01);
end
sum = sum / 10000

