function clean_wall

global left_wall
global right_wall
global atx_left_wall
global atx_right_wall

left_wall.StopCtrl;
right_wall.StopCtrl;
delete(left_wall);
delete(right_wall);
delete(atx_left_wall);
delete(atx_right_wall);
clear global left_wall;
clear global right_wall;
clear global atx_left_wall;
clear global atx_right_wall;