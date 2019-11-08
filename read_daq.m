function v = read_daq(da)

% Constant numbers here
gamma = 0.1; % Test data is on \\mntl-vlasov-srv.ad.uillinois.edu\Projects\Users\Kun\WaterMotor
ball2wallCorrection = 2;
step_V = 0.145;
Calib_Lat = [0.2564, -0.1580, 0.1903, -4.5241];
Zero_V    = [2.3206,  2.3672, 2.3600,  2.3307]; % Tested using test_zero_daq.m

% Ball reading, averaged every 3rd. Delay ~13 ms
v_raw = 0;
for i = 1:3
    v_raw = v_raw + da.inputSingleScan;
end
v_raw = v_raw / 3;

% Ball caculation
v_abs = round((v_raw - Zero_V)/step_V);
v = Calib_Lat * v_abs' * 10 * gamma * ball2wallCorrection;