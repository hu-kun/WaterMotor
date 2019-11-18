# WaterMotor
__This program is designed for the closed-loop "wall" control of rodent tactile-virtual-reality system.__

## What can it do?

1. According to the trial requirements, move and home the walls to specific places
2. We have open-loop and closed-loop trials, during two sets of trials:
   1. Closed-loop: The walls are moving with the animal and make it feel like a tunnel
   2. Open-loop: The walls are not moving during the trials
3. Save the log of animal's movements
4. Use BPod as a central digital signal sender to control other elements

## Hardware and software requirements

1. BPod, a state machine control device
   * [Bpod State Machine r2](https://sanworks.io/shop/viewproduct?productID=1024)
   * [Analog output module 4ch](https://sanworks.io/shop/viewproduct?productID=1013)
   * [Analog input module 8ch](https://sanworks.io/shop/viewproduct?productID=1021)
   * Download and install [BPod package](https://github.com/sanworks/Bpod_Gen2)

2. Motor & controller
   * Motor: [Thorlabs DDSM50](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=8535)
   * Controller: [Thorlabs KBD101](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=5698)
   * Download and install [Thorlabs APT software](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=9019)

3. A treadmill and its signal collector
   * We made our own, refer to [this paper](https://elifesciences.org/articles/12559)
   * The signals are sending to the receivers in step 4

4. Signal receivers
   * National Instrument [USB-6003](https://www.ni.com/en-us/support/model.usb-6001.html)

5. MATLAB 2018a or later version

## How to use

1. Install all the required software
2. Download and unzip [WaterMotor](https://github.com/hu-kun/WaterMotor/archive/master.zip)
2. Make a list of trials, save it into a csv file (see 'randomList_V3.csv')
   * If you wish to change the distances of the walls, find it from 'soft2wall.m'
3. Run 'waterMotor.m'

## Extra functions

1. To test the durations/delay, check the files begin with "test"
2. If there are some issues while running, check if the motors or BPod is initialized, if yes:
   1. Run 'clean_com.m' to clean BPod
   2. Run 'clean_wall.m' to clean the motors
3. To pull out the individual elements, see the files begin with "init"

## Issues?
Please contact me via email, hukun000 AT gmail DOT com
