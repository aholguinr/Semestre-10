%% UMN UAV Simulation: Linearize Tutorial
% This tutorial walks through the steps of linearizing the UMN UAV
% Simulation model. Most of these steps are handled in the "setup.m" and
% "linearize_UAV.m" functions provided with the UMN UAV sim. However, this
% tutorial will give you an in-depth understanding of how these functions
% work.

%%
%  Author: Austin Murch
% University of Minnesota 
% Aerospace Engineering and Mechanics 
% Copyright 2011 Regents of the University of Minnesota. 
% All rights reserved.
% SVN Info: $Id$

%% Setup and Configuration
% Before we get started we need to make sure the MATLAB path is correct and
% we have all of the aircraft and simulation parameters are defined. This
% step is handled in setup.m.

% Add Libraries folder to MATLAB path
addpath ../Libraries
warning('off','Simulink:SL_LoadMdlParameterizedLink')

% Configure Airframe, either 'Ultrastick' or 'FASER'
[AC,Env] = UAV_config('Ultrastick');

% Simulation sample time
SampleTime = 0.02; % sec

% Load model into system memory without opening diagram
load_system('UAV_NL.mdl') 

%% Set Aircraft Initial Conditions and Trim the Model
% Next we need to define initial conditions for the simulation model inputs
% and state vector and trim the model to a particular flight condition.
% This step is handled in setup.m.

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
TrimCondition.LLIni          = [45 -122];     % Initial Latitude/Longitude of Aircraft [Lat Long], [deg]
TrimCondition.VelocitiesIni  = [17 0 0.369]'; % Initial Body Frame velocities [u v w], [m/s]
TrimCondition.AttitudeIni    = [0 0.0217 0]'; % Initial Euler orientation [roll,pitch,yaw] [rad]
TrimCondition.RatesIni       = [0 0 0]';      % Initial Body Frame rotation rates [p q r], [rad/s]
TrimCondition.EngineSpeedIni = 827;           % Initial Engine Speed [rad/s]

% Set the trim target
TrimCondition.target = struct('V_s',17,'gamma',0); % straight and level, (m/s, rad)

% Find the trim solution
[TrimCondition,OperatingPoint] = trim_UAV(TrimCondition,AC);

%% Linearize the Model
% Linearizing is done using the "linearize.m" built-in function. We need to
% pass this function the model name and an operating point object that we
% get from trim_UAV. A linear model is only relevant when created around a
% trimmed flight condition.

linmodel = linearize('UAV_NL',OperatingPoint.op_point);

%% Full Linear Model
% We now have a full 13-state linear model, but the state, input, and
% output names need to be made consistent. Note the "\" in the name will
% format the name as a greek symbol when plotting.
set(linmodel, 'OutputName',{'V'; 'beta'; 'alpha'; 'h'; 'phi'; 'theta';'psi';'p';'q';'r';'gamma';'ax';'ay';'az'});    
set(linmodel, 'StateName', {'\phi';'\theta';'\psi';'p';'q';'r';'u';'v';'w';'Xe';'Ye';'Ze';'\omega'})
linmodel

%% Reduced Order Longitudinal Model
% The full 13 state linear model is a bit cumbersome to work with, so we
% normally separate the model into two decoupled, reduced order models: one
% for the longitudinal axis and another for the lateral-directional axes.
%
% The longitudinal model has 5 states: forward velocity, vertical velocity, 
% pitch rate, pitch angle, vertical position, and motor speed (u, w, q,
% \theta, Ze, \omega). 2 inputs: elevator and throttle, (\delta_e,
% \delta_t). and 7 outputs: airspeed, angle of attack, pitch rate, pitch
% angle, altitude, forward acceleration and normal acceleration. (V, alpha,
% q, theta, h, ax, az). We can reduce the full linear model using model
% reduction with the "modred" function. We first define indices
% corresponding to the states, outputs, and inputs we wish to retain in the
% linear model. We then need to reorder the state vector to the order
% listed above.

% Generate State-space matrices for Longitudinal Model
% Indices for desired state, outputs, and inputs that we want to keep
Xlon = [7 9 5 2 12 13];
Ylon = [1 3 9 6 4 12 14];
Ilon = [2 1];
longmod = modred(linmodel(Ylon,Ilon),setdiff(1:13,Xlon),'Truncate');

% Reorder state vector
longmod = xperm(longmod,[3 4 1 2 5 6]);

%%
% Now we have a reduced order linear model for the longitudinal dynamics.

% Display model
fprintf('\n  Longitudinal Model\n------------------------\n');    
longmod

%% Short Period Approximation
% Often when designing controllers for the pitch axis, we wish to further
% simplify the model to just the fast dynamics, or the short period. This
% can be done with a two state model (alpha/w and q) and three outputs
% (alpha/w, q, and az), with only one input (elevator

% Generate State-space matrices for Longitudinal Model
% Indices for desired state, outputs, and inputs
Xlon = [9 5];
Ylon = [3 9 14];
Ilon = [2];
spmod = modred(linmodel(Ylon,Ilon),setdiff(1:13,Xlon),'Truncate');

%%
% Now we have a simple linear model for the fast longitudinal dynamics.

% Display model
fprintf('\n  Short Period Model\n------------------------\n');    
spmod


%% Reduced Order Lateral-Directional Model
% The lateral-directional model has 5 states: side velocity, roll rate, yaw
% rate, roll angle, and yaw angle . (v, p, r, \phi, \psi). 2 inputs:
% aileron and rudder, (\delta_a, \delta_r). and 6 outputs: sideslip angle,
% roll rate, yaw rate, roll angle, yaw angle, and side acceleartion (\beta,
% p, r, \phi, \psi, ay). We can reduce the full linear model using model
% reduction with the "modred" function. We first define indices
% corresponding to the states, outputs, and inputs we wish to retain in the
% linear model. We then need to reorder the state vector to the order
% listed above.

% Generate State-space matrices for lateral-directional Model
% Indices for desired state, outputs, and inputs that we want to keep
Xlat = [8 4 6 1 3];
Ylat = [2 8 10 5 7];
Ilat = [8 3];
latmod = modred(linmodel(Ylat,Ilat),setdiff(1:13,Xlat),'Truncate');
latmod = xperm(latmod,[5 3 4 1 2]); % reorder state

%%
% Now we have a reduced order linear model for the lateral-directional
% dynamics. 

%% Longitudinal Model Analysis
% Now that we have linear models, let's look at the bode plot of a few
% relevant cases: first we'll look at elevator to pitch rate, comparing the
% full model to the 5 state model and the 2 state model.

figure
bode(linmodel(9,2),longmod(3,1),spmod(2,1),{.01,1000}); grid on
legend('Full Model','5 State Model','2 State Model')

%%
% We see that there is very little difference between the three models for
% the high frequencies, and that the 5 state model accurately captures the
% dynamics at lower frequences.  so the reduced order model is a good
% approximation. We can also see the two dominant modes of the system, the
% Phugoid and short period, in the two humps in the magnitude plot. Also of
% interest is where the magnitude crosses zero- this defines the bandwidth
% of the system response.
%
% The best way to look at the modes of the system is to look at the
% Eigenvalues; for this, we'll use the "damp" function.

damp(longmod)

%%
% This shows us the Eigenvalues of the system, as well as their frequency
% and damping. We see the Phugoid mode, with reasonable damping and normal
% low frequency. The Short Period mode is the other complex pair, with a
% good damping ratio and reasonable frequency.

%% Lateral-Directional Model Analysis
% For the lateral-directional model, let's look at aileron to roll rate and
% rudder to yaw rate.

figure
bode(linmodel(8,8),latmod(2,1),{.01,1000}); grid on
legend('Full Model','Reduced Order Model')

%%
% Again, we see that there is very little difference between the two models
% for any reasonable frequencies, so the reduced order model is a good
% approximation. We can also see the dominant behavior of the roll axis, in
% that the roll rate response behaves as a first-order system.
%
% Now the rudder to yaw rate:

figure
bode(linmodel(10,3),latmod(3,2),{.01,1000}); grid on
legend('Full Model','Reduced Order Model')

%%
% Again, the reduced order model is a good approximation. The hump in the
% magnitude is the Dutch Roll mode.
%
% The best way to look at the modes of the system is to look at the
% Eigenvalues; for this, we'll use the "damp" function.

damp(latmod)

%%
% This shows us the Eigenvalues of the system, as well as their frequency
% and damping. We see the Dutch Roll mode is the only complex pair of
% Eigenvalues, with a lower damping ratio and moderate frequency. The roll
% mode is first order and relatively fast; the slow first order mode is the
% spiral mode, which can be unstable for some aircraft.
%
% This concludes the linearize tutorial. Please send any comments or
% questions to Austin Murch (murch@aem.umn.edu).