function read_daq_2(event)

global ball_V

% Constant numbers here
gamma = 0.1; % Test data is on \\mntl-vlasov-srv.ad.uillinois.edu\Projects\Users\Kun\WaterMotor
ball2wallCorrection = 0.8;
step_V = 0.19;
Calib_Lat = [0.2564, -0.1580, 0.1903, -4.5241];
Zero_V    = [2.5024    2.5262    2.5099    2.5344];

ball_V_Tmp = mean(event.Data(end-50, end,:));

v_abs = round((ball_V_Tmp - Zero_V)/step_V);
ball_V = Calib_Lat * v_abs' * 10 * gamma * ball2wallCorrection;