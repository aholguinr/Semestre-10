%% setup.m
% UAV Processor-in-the-Loop Simulation setup
%
% IMPORTANT: Mathworks Real Time Windows Target is only supported for
% 32-bit machines. http://www.mathworks.com/products/rtwt/requirements.html
%
% University of Minnesota
% Aerospace Engineering and Mechanics
% Copyright 2011 Regents of the University of Minnesota.
% All rights reserved.
%
% SVN Info: $Id$

%% Clean up
bdclose all
clear all
clear mex
close all
clc

%% Start FlightGear
% FlightGear will be started automatically for Windows PCs if it is
% installed in C:\Program Files\FlightGear\.

% % First check if FlightGear folder is present
% if isdir('C:\Program Files\FlightGear')
%     !Start_FlightGear.bat &
% else
%     warning('FlightGear directory not found at "C:\Program Files\FlightGear". FlightGear must be started manually')
% end
%% Start Ground Control Station Software
% If the full SVN repository \trunk\ is present, the Ground Station
% software will be started automatically.

% % First check if GroundStation folder is present
% if isdir('..\..\GroundStation\OpenUGS\')
%     currentdir = pwd;
%     cd ..\..\GroundStation\OpenUGS\
%     !runOpenUGS.bat &
%     cd(currentdir)
% else
%     warning('GroundStation directory not located at "..\..\GroundStation\OpenUGS\". GCS must be started manually')
% end
%% Adding to MATLAB path
addpath ../Libraries

%% Configure Airframe and load trim condition
load UAV_modelconfig
load UAV_trimcondition

%% Simulation sample time
SampleTime = 0.02; % sec

% Additional time delay in flight software loop. There is an inherent
% 40 msec delay in the PIL loop.
TimeDelay = 0.00; % sec

%% Open model, build target, and connect.
UAV_PIL
rtwbuild UAV_PIL
set_param('UAV_PIL','SimulationCommand','connect')

