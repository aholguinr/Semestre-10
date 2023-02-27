%% setup.m
% UAV Software-in-the-Loop Simulation setup
%
% This script will setup the SIL simulation. Stored aircraf configuration
% and trim conditions are used.
%
% University of Minnesota
% Aerospace Engineering and Mechanics
% Copyright 2011 Regents of the University of Minnesota.
% All rights reserved.
%
% SVN Info: $Id$

%% Clean up
clear all
close all
bdclose all
clc

%% Add Libraries and controllers folder to MATLAB path
addpath ../Libraries
addpath ../Controllers

%% Load airframe configuration and trim condition
% To change these, use the functions "UAV_config.m" and "trim_UAV.m"
load UAV_modelconfig
load UAV_trimcondition

%% Simulation sample time
SampleTime = 0.02; % sec
%% Set controller variants
% Each variant corresponds to a different Simulink model that will be
% referenced in the "UAV_SIL/Control Software/Control Software" block.
flightcode_var = Simulink.Variant('controller_mode == 1 || controller_mode == 3 || controller_mode == 5');
baseline_control_var = Simulink.Variant('controller_mode == 2');
waypoint_control_var = Simulink.Variant('controller_mode == 4');
lqr_control_var = Simulink.Variant('controller_mode == 6');
student_control_var = Simulink.Variant('controller_mode == 8');

%% Set controller mode
% Use this variable to quickly change what controller is used in the
% simulation.
%
% 1 = baseline controller (C implementation)
% 2 = baseline controller (Simulink)
% 3 = Waypoint controller (C implementation)
% 4 = Waypoint controller (Simulink)
% 5 = LQR controller (C implementation)
% 6 = LQR controller (Simulink)
% 7 = Student controller (C implementation) 
% 8 = Student controller (Simulink)         
controller_mode = 1;

% Load controller parameters or compile flight code
switch controller_mode
    case 1 % Baseline controller in C
        % Compile Flight Software:
        control_code_path = '../../Software/FlightCode/control/baseline_control_LOAW_2.c';     
        
    case 2 % Baseline controller in Simulink.
        baseline_gains;   % Declare baseline controller gains
        pitch_gains = [kp_PT, ki_PT, kp_PD];
        roll_gains = [kp_RT, ki_RT, kp_RD];
        yaw_damper_num = [YDz_num]; % discrete transfer function yaw damper coefficients
        yaw_damper_den = [YDz_den];

        
    case 3 % Waypoint controller in C
        % Compile Flight Software:
        control_code_path ='../../Software/FlightCode/control/heading_tracker.c';
        
    case 4 % Waypoint controller in Simulink
        baseline_gains;  % waypoint controller lays on top of the baseline controller        
        pitch_gains = [kp_PT, ki_PT, kp_PD];
        roll_gains = [kp_RT, ki_RT, kp_RD];
        yaw_damper_num = [YDz_num]; % discrete transfer function yaw damper coefficients
        yaw_damper_den = [YDz_den];
        
        waypoint_gains;  % Specify waypoint gains
        phi_sat = 45;   % phi cotnroller output saturation
        theta_sat = 20; % altitude controller output saturation

        
    case 5 % LQR controller in C
        % Compile Flight Software:
        control_code_path ='../../Software/FlightCode/control/lqr_control.c';
        
    case 6 % LQR controller in Simulink
        % Parameters defined here are identical to those in lqr_control.c
        K_pitch = [-0.240144526553189,  0.079132432193614, 0.287138908852059];
        K_roll = [-0.6679,   0.0243,   0.0251,   0.3631;...
            -0.1355,   0.0004,   0.0284,   0.0710];
        
    case 7 % Student controller in C 
        % Compile Flight Software:
        control_code_path ='../../Software/FlightCode/control/student_control.c'; % Specify your control code file name here       
             
    case 8 % Student controller in Simulink        
        % Get control gains

end

% Advanced Users: Include guidance, system ID, or fault injection codes.
% Set the path to the .c code in the following variables.
%
%%%%% GUIDANCE LAW %%%%%
% Point to the desired guidance code here. Use '-DSIMULINK_GUIDANCE' to
% input the reference commands from the simulink diagram.
% GUIDANCE = '../../Software/FlightCode/guidance/waypoint_track.c';
% GUIDANCE = '../../Software/FlightCode/guidance/doublet_rates.c';
 GUIDANCE = '../../Software/FlightCode/guidance/doublet_phi_theta.c';
% GUIDANCE = '../../Software/FlightCode/guidance/phi_theta_cmds.c';
% GUIDANCE = '../../Software/FlightCode/guidance/baseline_valid.c';
% GUIDANCE = '-DSIMULINK_GUIDANCE';

%%%%%% SYSTEM ID SELECTION %%%%%
% Point to the desired system ID code here
% SYSTEM_ID = '../../Software/FlightCode/system_id/pyr_doublet.c';
% SYSTEM_ID = '../../Software/FlightCode/system_id/ele_sysid.c';
% SYSTEM_ID = '../../Software/FlightCode/system_id/ail_sysid.c';
% SYSTEM_ID = '../../Software/FlightCode/system_id/rud_sysid.c';
SYSTEM_ID = '../../Software/FlightCode/system_id/systemid_none.c';
% SYSTEM_ID = '../../Software/FlightCode/system_id/chirp_sysid.c';

%%%%%% SURFACE FAULT MODE SELECTION %%%%%
% Point to the desired fault code here
% SURFACE_FAULT = '../../Software/FlightCode/faults/fault_onesurf.c';
SURFACE_FAULT = '../../Software/FlightCode/faults/surffault_none.c';

%%%%%% SENS0R FAULT MODE SELECTION %%%%%
% Point to the desired fault code here
SENSOR_FAULT = '../../Software/FlightCode/faults/sensfault_none.c';

% Compile control software
if exist('control_code_path','var')
    eval(['mex -I../../Software/FlightCode/ control_SIL.c  ' control_code_path...
                       ' ' GUIDANCE ' ' SYSTEM_ID ' ' SURFACE_FAULT ' ' SENSOR_FAULT ...
                       ' ../../Software/FlightCode/faults/fault_functions.c ' ...
                       ' ../../Software/FlightCode/system_id/systemid_functions.c ']);
end



%% Integer Time delay in flight software loop
IntegerTimeDelay = 2; % .04sec

%% Open sim diagram
UAV_SIL