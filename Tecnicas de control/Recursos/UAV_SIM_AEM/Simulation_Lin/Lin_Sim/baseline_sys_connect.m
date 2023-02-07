clc;clear;
load linmodel17; SampleTime=0.02;
addpath ../Controllers
baseline_gains;

%===========================Actuators=====================================%
w = 2*pi*8; % 8.0 Hz bandwidth
Act=tf(w,[1 w]);
e_act=Act; r_act=Act; la_act=Act; ra_act=Act; % elevator, rudder, left aileron, right aileron

e_act.InputName = 'elev_cmd';  r_act.InputName = 'rud_cmd'; 
e_act.OutputName = 'elevator'; r_act.OutputName = 'rudder';

la_act.InputName = 'l_ail_cmd';  ra_act.InputName = 'r_ail_cmd';
la_act.OutputName = 'l_aileron'; ra_act.OutputName = 'r_aileron';

% Yaw damper
K_YD.InputName='r';
K_YD.OutputName='rud_cmd';

% Roll damper
K_RD=tf(kp_RD,1);
K_RD.InputName='p';
K_RD.OutputName='RD_out';

% Roll tracker
K_RT=tf([kp_RT ki_RT],[1 0]);
K_RT.InputName='e1';
K_RT.OutputName='RT_out';

% Pitch damper
K_PD=tf(kp_PD,1);
K_PD.InputName='q';
K_PD.OutputName='PD_out';

% Pitch tracker
K_PT=tf([kp_PT ki_PT],[1 0]);
K_PT.InputName='e3';
K_PT.OutputName='PT_out';



% Sum blocks
sum1=sumblk('e1','phi_ref','phi','+-');
sum2=sumblk('r_ail_cmd','RT_out','RD_out','+-');  %% FIGURE OUT IF HAVING ONE INPUT FOR AILERON WORKS OR IF IT 
sum3=sumblk('e3','theta_ref','theta','+-');     %% NEEDS TO BE SPLIT INTO RIGHT AND LEFT
sum4=sumblk('elev_cmd','PT_out','PD_out','+-');

GAIN=tf(-1,1);
GAIN.InputName='r_ail_cmd'; GAIN.OutputName='l_ail_cmd';

INPUTS ={'throttle','l_flap','r_flap','aileron','phi_ref','PT_out'};
SYS=connect(K_YD,K_RD,K_RT,K_PD,GAIN,e_act,r_act,la_act,ra_act,sum1,...
sum2,sum3,sum4,linmodel,INPUTS,linmodel.OutputName);

L=SYS(6,6)*K_PT; margin(L);
isstable(L/(1+L))
