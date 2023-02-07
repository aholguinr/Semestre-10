%% setup.m
% UAV Nonlinear Simulation setup
%
% This script will setup the nonlinear simulation (UAV_NL.mdl) and call
% trim and linearization routines. Select the desired aircraft here in this
% script, via the "UAV_config()" function call.
%
% Note: the UAV_NL.mdl model is not opened by default. This is not
% necessary to trim, linearize, and simulate via command line inputs.
%
% Calls: UAV_config.m
%        trim_UAV.m
%        linearize_UAV.m
%       
% University of Minnesota 
% Aerospace Engineering and Mechanics 
% Copyright 2011 Regents of the University of Minnesota. 
% All rights reserved.
%
% SVN Info: $Id$

% clean up
clear all
close all
bdclose all
clc

%% Add Libraries folder to MATLAB path
addpath ../Libraries
warning('off','Simulink:SL_LoadMdlParameterizedLink')

%% Configure Airframe, either 'Ultrastick' or 'FASER'
% [AC,Env] = UAV_config('Ultrastick'); 
[AC,Env] = UAV_config('Ultrastick'); 

%% Simulation sample time
SampleTime = 0.02; % sec

%% Set aircraft initial conditions 
% Note: these are NOT the trim condition targets. If the trim fails to
% coverge, try using different initial conditions. Also note that the trim
% function will overwrite these initial conditions with the trimmed
% conditions.

% Set the initial model inputs
TrimCondition.Inputs.elevator = 0.091; % rad
TrimCondition.Inputs.l_aileron  = 0;     % rad
TrimCondition.Inputs.r_aileron  = 0;     % rad
TrimCondition.Inputs.aileron  = 0;    % rad, combined aileron input
TrimCondition.Inputs.rudder   = 0;     % rad
TrimCondition.Inputs.l_flap     = 0;     % rad
TrimCondition.Inputs.r_flap     = 0;     % rad
TrimCondition.Inputs.throttle = 0.559; % nd, 0 to 1

% Set initial state values
TrimCondition.InertialIni    = [0 0 -100]';   % Initial Position in Inertial Frame [Xe Ye Ze], [m]
TrimCondition.LLIni          = [44.7258357 -93.07501316]';     % Initial Latitude/Longitude of Aircraft [Lat Long], [deg]
TrimCondition.VelocitiesIni  = [17 0 0.369]'; % Initial Body Frame velocities [u v w], [m/s]
TrimCondition.AttitudeIni    = [0 0.0217 pi/2]'; % Initial Euler orientation [roll,pitch,yaw] [rad], can't use 0 heading, causes large entry in C matrix for psi 

TrimCondition.RatesIni       = [0 0 0]';      % Initial Body Frame rotation rates [p q r], [rad/s]
TrimCondition.EngineSpeedIni = 827;           % Initial Engine Speed [rad/s]

%% Trim aircraft to a specific flight condition
% Set the trim targets here. See trim_UAV for complete list of target
% variables. Sideslip angle (beta), flight path angle (gamma) and flap
% setting default to zero. If a fixed control input setting is desired,
% specify as a target.

if(strcmpi(AC.aircraft,'FASER'))
    TrimCondition.target = struct('V_s',23,'gamma',0); % straight and level, (m/s, rad)
else
    TrimCondition.target = struct('V_s',17,'gamma',0); % straight and level, (m/s, rad)
end
% TrimCondition.target = struct('V_s',17,'gamma',5/180*pi); % level climb, (m/s, rad)
% TrimCondition.target = struct('V_s',17,'gamma',0,'psidot',20/180*pi); % level turn, (m/s, rad, rad/sec)
% TrimCondition.target = struct('V_s',17,'gamma',5/180*pi,'psidot',20/180*pi); % climbing turn, (m/s, rad, rad/sec)
% TrimCondition.target = struct('V_s',17,'gamma',0,'beta',5/180*pi); % level steady heading sideslip, (m/s, rad, rad)

% Find the trim solution
[TrimCondition,OperatingPoint] = trim_UAV(TrimCondition,AC);

%% Linearize about the operating point
[longmod,spmod,latmod,linmodel]=linearize_UAV(OperatingPoint);




