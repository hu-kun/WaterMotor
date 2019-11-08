global left_wall right_wall

% Stop to move, then stop. Both walls.

currentBallV = 100;
for i = 1:1000
    left_wall.SetJogVelParams(0,0,1000,abs(currentBallV));
    right_wall.SetJogVelParams(0,0,1000,abs(currentBallV));
    left_wall.MoveJog(0,1);
    right_wall.MoveJog(0,2);
    pause(0.05);
    left_wall.StopImmediate(0);
    right_wall.StopImmediate(0);
    pause(0.05);
    left_wall.SetJogVelParams(0,0,1000,abs(currentBallV));
    right_wall.SetJogVelParams(0,0,1000,abs(currentBallV));
    left_wall.MoveJog(0,2);
    right_wall.MoveJog(0,1);
    pause(0.05);
    left_wall.StopImmediate(0);
    right_wall.StopImmediate(0);
    pause(0.05);
end

% Result, constand speed (5), pause 30 ms after move and stop. (123.464 - 120) / 2 / 1000 = 0.001732 -> 1.732 ms per move & stop
% Result, constand speed (100), pause 50 ms after move and stop. (203.353 - 200) / 2 / 1000 = 0.003353 -> 3.3353 ms per move & stop