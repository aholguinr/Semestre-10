%% UMN UAV Simulation: Trim Tutorial
% This tutorial walks through the steps of trimming the UMN UAV Simulation
% model. Most of these steps are handled in the "setup.m" and "trim_UAV.m"
% functions provided with the UMN UAV sim. However, this tutorial will give
% you an in-depth understanding of how these functions work.

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

%% Set Aircraft Initial Conditions
% Next we need to define initial conditions for the simulation model inputs
% and state vector. These initial values serve as the starting point for
% the trim algorithm, so if the trim algorithm fails to converge, you can
% try a new set of initial conditions. This step is handled in setup.m.

% Set the initial model inputs
TrimCondition.Inputs.elevator   = 0.091; % rad
TrimCondition.Inputs.l_aileron  = 0;     % rad
TrimCondition.Inputs.r_aileron  = 0;     % rad
TrimCondition.Inputs.aileron    = 0;    % rad, combined aileron input
TrimCondition.Inputs.rudder     = 0;     % rad
TrimCondition.Inputs.l_flap     = 0;     % rad
TrimCondition.Inputs.r_flap     = 0;     % rad
TrimCondition.Inputs.throttle   = 0.559; % nd, 0 to 1

% Set initial state values
TrimCondition.InertialIni    = [0 0 -100]';   % Initial Position in Inertial Frame [Xe Ye Ze], [m]
TrimCondition.LLIni          = [45 -122];     % Initial Latitude/Longitude of Aircraft [Lat Long], [deg]
TrimCondition.VelocitiesIni  = [17 0 0.369]'; % Initial Body Frame velocities [u v w], [m/s]
TrimCondition.AttitudeIni    = [0 0.0217 0]'; % Initial Euler orientation [roll,pitch,yaw] [rad]
TrimCondition.RatesIni       = [0 0 0]';      % Initial Body Frame rotation rates [p q r], [rad/s]
TrimCondition.EngineSpeedIni = 827;           % Initial Engine Speed [rad/s]

%%
% The following steps are handled inside of the trim_UAV.m function. We'll
% cover how to use this function later on.

%% Create Operating Point Specification Object for the Simulation
% The first step in trimming the model is to create an operating point
% specification object for our simulation model. This will allow us to
% specify target values, constraints, and initial guesses for all of the
% relevant simulation states, inputs, and outputs.

op_spec = operspec('UAV_NL')

%%
% For some simulations, it may be easiest to directly specify your desired
% trim condition in the state variables. For our aircraft model, some of
% the relevant parameters (such as angle of attack) are not states, so we
% have made these parameters root-level Outports, which allows us to
% specify their value. For this example, we'll specify our trim target via
% the state variables, and then look at other possibilities.

%% Specifying State Trim Conditions
% Now we will specify desired targets and/or constraints for the state
% variables. Let's first look at what we can specify:

get(op_spec.States)

%%
% Note there are several state entries (5x1 struct array), corresponding to
% each integrator block in our Simulink model. Each of these has a number
% of fields; the ones we are interested in are "x", "Known", "SteadyState",
% "Min", and "Max". Now we'll look at each set of States:

op_spec.States(1)

%%
% This gives us the block name, and what is currently specified. We see
% that this integrator actually has 3 states in it, the Euler angles phi,
% theta, and psi. In general we need to supply three pieces of information:
% if the state is "Known" (boolean), the known value of the state or
% initial guess, and whether the state is steady (i.e. the state derivative
% is zero).
%
% For the Euler angles, in general we want to specify the yaw angle (psi)
% since this doesn't directly affect the trim condition. For this example,
% we will leave the bank and pitch angles (phi and theta) unknown. The
% initial values we set earlier in the TrimCondition data structure. We
% want all of the Euler angles to be steady state.

% phi, theta, psi -- Euler angles
op_spec.States(1).Known       = [0 ; 0; 1];
op_spec.States(1).x           = TrimCondition.AttitudeIni;
op_spec.States(1).SteadyState = [1; 1; 1];

%%
% Next we'll specify the angular rates (p,q,r). We'll leave all of these as
% unknown and steady state, even though we actually know what we want our
% angular rates to be (zero). If you over constrain your model, the trim
% algorithm will often fail. Its a good practice to constrain as few as
% states/inputs/outputs as possible.

% p, q, r -- Angular rates
op_spec.States(2).Known       = [0; 0; 0];
op_spec.States(2).x           = TrimCondition.RatesIni;
op_spec.States(2).SteadyState = [1; 1; 1];

%%
% Now we'll specify the body axis velocities (u,v,w). We would like a
% forward speed of 17 m/sec (which was set in the initial conditions
% above), so we'll set the first entry (u) to be known, and leave the rest
% unknown. Remember, we don't want to over constrain the problem, or the
% trim algorithm may fail. We also make use of the "Min" constraint for
% the forward velocity (u). We know this should always be positive, so we
% constrain the minimum value to be zero. We don't want to constrain the
% other states, so we use "-inf" as the minimum.

% u, v, w -- Body velocities
op_spec.States(3).Known       = [1; 0; 0];
op_spec.States(3).x           = TrimCondition.VelocitiesIni;
op_spec.States(3).SteadyState = [1; 1; 1];
op_spec.States(3).Min         = [0 -inf -inf];

%%
% Next are the inertial positions (Xe,Ye,Ze). Here we'll specify the
% altitude, because this doesn't directly affect the trim solution. We'll
% also let the Xe and Ye states be non-steady; since the airplane is
% actually moving, these states are normally changing. Here we constrain
% the maximum value of Ze to be zero; recall that Ze is defined as positive
% downwards, so relative to the inertial frame, Ze should always be
% negative in this simulation.

% Xe, Ye, Ze -- Inertial position
op_spec.States(4).Known       = [0; 0; 1];
op_spec.States(4).x           = TrimCondition.InertialIni;
op_spec.States(4).SteadyState = [0; 0; 1];
op_spec.States(4).Max         = [inf inf 0];

%%
% Finally we specify the motor speed, as unknown and steady.

% omega  -- Motor Speed
op_spec.States(5).Known       = 0;
op_spec.States(5).x           = TrimCondition.EngineSpeedIni;
op_spec.States(5).SteadyState = 1;

%% Setting Input Constraints
% Similar to the states, we need to specify constraints and initial values
% on the inputs to the model, which are the throttle, elevator, rudder, L/R
% aileron, L/R flap, and combined aileron input. We normally use the
% combined aileron input (ailerons moved together), so we'll leave the 8th
% input free and set the L/R aileron input as known to be zero. Note you
% shouldn't try to trim using individual ailerons unless you set one of
% them to a known value. We use the initial values specified earlier.

% Throttle
op_spec.Inputs(1).Known = 0;
op_spec.Inputs(1).u = TrimCondition.Inputs.throttle;
op_spec.Inputs(1).Max = AC.Actuator.throttle.PosLim;
op_spec.Inputs(1).Min = AC.Actuator.throttle.NegLim;

% Elevator
op_spec.Inputs(2).Known = 0;
op_spec.Inputs(2).u = TrimCondition.Inputs.elevator;
op_spec.Inputs(2).Max = AC.Actuator.elevator.PosLim;
op_spec.Inputs(2).Min = AC.Actuator.elevator.NegLim;

% Rudder
op_spec.Inputs(3).Known = 0;
op_spec.Inputs(3).u = TrimCondition.Inputs.rudder;
op_spec.Inputs(3).Max = AC.Actuator.rudder.PosLim;
op_spec.Inputs(3).Min = AC.Actuator.rudder.NegLim;

% left Aileron
op_spec.Inputs(4).Known = 1;
op_spec.Inputs(4).u = TrimCondition.Inputs.l_aileron;

% right Aileron
op_spec.Inputs(5).Known = 1;
op_spec.Inputs(5).u = TrimCondition.Inputs.r_aileron;

% left Flap
op_spec.Inputs(6).Known = 1;
op_spec.Inputs(6).u = TrimCondition.Inputs.l_flap;

% right Flap
op_spec.Inputs(7).Known = 1;
op_spec.Inputs(7).u = TrimCondition.Inputs.r_flap;

% Combined aileron input
op_spec.Inputs(8).Known = 0;
op_spec.Inputs(8).u = TrimCondition.Inputs.aileron;
op_spec.Inputs(8).Max = AC.Actuator.l_aileron.PosLim;
op_spec.Inputs(8).Min = AC.Actuator.l_aileron.NegLim;

%% Trimming the Model
% Finally, we will use the 'findop' function to trim the model (find an
% operating point). This function outputs two objects; an operating point
% object (op_point) and a report on the trim search (op_report). The
% op_point contains all of the trimmed values of the states and inputs. The
% op_report contains all of the same information, plus details on the trim
% search, the state derivatives, model outputs, and trim specifications.

[op_point,op_report] = findop('UAV_NL',op_spec);

%%
% We see near the top of the report, it tells us that the "Operating point
% specifications were successfully met." Scrolling down, we see the values
% of the state (x) and the derivatives (dx). The (0) symbol denotes if the
% state derivative is supposed to be zero (steady state). Farther down, we
% have the model inputs, with the value (u) being our trimmed control
% setting. The numbers in brackets represent the min/max range we set. The
% flaps don't show this range, as we specified the value as known. Finally,
% we have the model outputs, which correspond to the root-level outports in
% the  model. We didn't specify any of these, but it shows us the trimmed
% value of each. 

%% Setting Simulation Initial Conditions to Trim Values
% Now that we have an operating point, we need to set these values as the
% initial conditions for the simulation, replacing the values we specified
% earlier.

% Pull state values from the trim solution
TrimCondition.AttitudeIni    = op_point.States(1).x;
TrimCondition.RatesIni       = op_point.States(2).x;
TrimCondition.VelocitiesIni  = op_point.States(3).x;
TrimCondition.InertialIni    = op_point.States(4).x;
TrimCondition.EngineSpeedIni = op_point.States(5).x;

% Pull input values from the trim solution
TrimCondition.Inputs.throttle = op_point.Inputs(1).u;
TrimCondition.Inputs.elevator = op_point.Inputs(2).u;
TrimCondition.Inputs.rudder   = op_point.Inputs(3).u;
TrimCondition.Inputs.l_aileron= op_point.Inputs(4).u;
TrimCondition.Inputs.r_aileron= op_point.Inputs(5).u;
TrimCondition.Inputs.l_flap   = op_point.Inputs(6).u;
TrimCondition.Inputs.r_flap   = op_point.Inputs(7).u;
TrimCondition.Inputs.aileron  = op_point.Inputs(8).u;

%%
% Now we are ready to run the simulation! Next we'll look at some other
% useful ways of specifying trim targets.

%% Specifying Output Trim Conditions
% As mentioned previously, sometimes we want to specify a trim target that
% is not a state variable. There are two ways to do this; 1) Make the
% desired variable an output of the model by connecting it to root-level
% Outport block, and 2) use the "addoutputspec" function to specify a block
% output signal. We'll look at both methods.
%
% First, lets look at specifying the model outputs. Our operating point
% specification object lists the model outputs:

op_spec.Outputs

%%
% We see that there are 14 outputs, none with specifications. The names of
% these outputs correspond to the names of the root-level Outport blocks in
% the Simulink model. For this example, lets say we want to trim the
% aircraft to steady level flight at 19 m/s airspeed. We need to constrain
% the airspeed (V_s) to 19 m/s and the flight path angle (gamma) to 0
% degrees.

% Airspeed output specification, in m/s
op_spec.Outputs(1).y = 19;
op_spec.Outputs(1).Known = 1;

% Flight path angle output specification, in radians
op_spec.Outputs(11).y = 0;
op_spec.Outputs(11).Known = 1;

%%
% Now lets try to trim the model:

[op_point,op_report] = findop('UAV_NL',op_spec);

%%
% We see that the trim algorithm failed. What happened? We didn't remove
% the constraints we put on the state variables earlier, and thusly had an
% overconstrained model! You will need to use good engineering judgment
% when specifying constraints. For example, airspeed, angle of attack, and
% flight path angle are not independent, so you cannot constrain all three
% of these variables.  As a general rule, you should never have two
% constraints that are similar (e.g. Vertical position steady state &
% flight path angle = 0). Let's remove the constraints on the forward
% velocity (u), and the vertical position (Ze) we set earlier.

% Remove Known constraint on forward velocity (u)
op_spec.States(3).Known       = [0; 0; 0];

% Remove steady state constraint on vertical position (Ze)
op_spec.States(4).SteadyState = [0; 0; 0];

%%
% Now lets try to trim the model:

[op_point,op_report] = findop('UAV_NL',op_spec);

%%
% Success! We see in the Outputs section of the op_report the airspeed
% (V_s) is at 19 and the flight path angle is at (nearly) zero. Now lets
% look at the second method of specifying output constraints: using the
% addoutputspec function.
%
% Say we wanted to specify a constraint on a variable that is not an output
% of the model; rather than go through the hassle of modifying the model,
% we can add an output specification to the output of any block in the
% simulation. One situation where this is necessary is trimming to a
% steady turn. The variable we need to constrain is the derivative of the
% heading (psi), or psidot. Psi is a state variable, but there isn't a way
% to specify a value other than zero for the state derivatives. We can use
% the addoutputspec function to constrain the value of psidot within the
% model. To use this function, you need to know the full path name to the
% block. An easy way to find this is to click through the model until you
% find the block; with the block selected, go to the MATLAB command window
% and type "gcb", or get current block, which will return the full path to
% the selected (current) block. We'll pass our op_spec object, the full
% path to the block (in this case the block that computes the Euler angle
% derivatives), and the block output signal number to addoutputspec. The
% function will return the modified op_spec object.

op_spec=addoutputspec(op_spec,...
    'UAV_NL/Nonlinear UAV Model/6DoF EOM/Calculate DCM & Euler Angles/phidot thetadot psidot',...
    1);

%%
% Now we have an additional output in the op_spec object:

op_spec.Outputs

%%
% We can now specify a constraint on the third value of the 15th output
% (psidot):

% Psidot output specification, in radians/sec
op_spec.Outputs(15).y(3) = 15/180*pi;
op_spec.Outputs(15).Known(3) = 1;

%%
% However, we can't over constrain the model! We can leave our airspeed and
% flight path angle specifications (this will be a steady, level turn), but
% we will need to remove the steady state constraint we put on the psi
% state earlier:

% Remove steady state constraint on psidot state
op_spec.States(1).steadystate(3) = 0; 

%%
% Now lets try to trim the model:

[op_point,op_report] = findop('UAV_NL',op_spec);

%%
% Success! We now have the aircraft trimmed at 19 m/s airspeed, level
% flight, a right-hand bank angle of a few degrees, resulting in a turn
% rate of 15 deg/sec. This is a pretty shallow bank angle for a turn rate
% this high; you may notice that the sideslip angle (beta) is quite large.
% This means we are in a skidding turn, using mainly the rudder to effect
% the turn. This is not only poor piloting technique, but can also be risky
% at slow airspeeds as it can quickly lead to an accelerated stall/spin
% condition! To correct this, we need to specify a constraint on the
% sideslip angle to keep this at zero, so we'll have a coordinated turn:

% Sideslip angle output specification, in radians
op_spec.Outputs(2).y = 0;
op_spec.Outputs(2).Known = 1;

%%
% Now lets try to trim the model:

[op_point,op_report] = findop('UAV_NL',op_spec);

%%
% Success! Now we see beta is zero, the turn rate is still 15 deg/sec, but
% now the bank angle is about 30 degrees. This is much more appropriate!
% Now we will look at one last aspect of trimming: constraining the inputs.

%% Specifying Input Trim Conditions
% Normally when we trim a model, our main goal is to find the inputs (and
% unknown state values) that will give us a certain set of desired states
% and outputs. We can, however, do this process in reverse: specify the
% inputs, and then figure out what states and outputs will result. This can
% be useful for determining the flight envelope of possible trim conditions
% for a given configuration of an aircraft. 
%
% Specifying input constraints is very similar to specifying output
% constraints. We simply set the Known flag and initial value. The key,
% again, is to make sure we don't over constrain the  model. For this
% example, lets attempt to find out what the maximum level flight speed is
% for this aircraft. This condition will be at maximum throttle setting and
% a flight path angle of zero, but we don't know what the other inputs or
% states will be, so we'll need to free up some constraints we set earlier.

% Throttle
op_spec.Inputs(1).Known = 1;
op_spec.Inputs(1).u = 1; % maximum

% Remove psidot output specification, in radians/sec
op_spec.Outputs(15).y(3) = 0;
op_spec.Outputs(15).Known(3) = 0;

% Replace steady state constraint on psidot state
op_spec.States(1).steadystate(3) = 1; 

% Remove airspeed output specification, in m/s
op_spec.Outputs(1).y = 19;
op_spec.Outputs(1).Known = 0;

%%
% Now lets try to trim the model:

[op_point,op_report] = findop('UAV_NL',op_spec);

%%
% Success! We see in the outputs that the airspeed is 23.4 m/sec. All other
% states are at reasonable values- note the angle of attack is actually at
% -0.83 degrees. This is because the zero lift angle of attack is actually
% negative (not at zero), so a slightly negative angle of attack is
% necessary to get the required CL for this airspeed.

%% Using trim_UAV.m
% To simplify the trimming process, the UAV Research Group has written a
% function, "trim_UAV", which handles the details required to trim a model
% that we have just discussed. The trim_UAV function allows the user to
% simply specify the target trim values, and the function will take care of
% the rest. 
%
% trim_UAV requires two inputs: the trim condition data structure
% (TrimCondition) with initial values and trim targets, and the aircraft
% configuration data structure (AC). The TrimCondition data structure must
% have a field called "target", where you can specify your desired trim
% targets by adding fields corresponding to the following list of
% possibilities:
%
%     V_s          - True airspeed (m/s)
%     alpha        - Angle of attack (rad)
%     beta         - Sideslip (rad), defaults to zero
%     gamma        - Flight path angle (rad), defaults to zero
%     phi          - roll angle (rad)
%     theta        - pitch angle (rad)
%     psi          - Heading angle (0-360)
%     phidot       - d/dt(phi) (rad/sec), defaults to zero
%     thetadot     - d/dt(theta) (rad/sec), defaults to zero
%     psidot       - d/dt(psi) (rad/sec), defaults to zero
%     p            - Angular velocity (rad/sec)
%     q            - Angular velocity (rad/sec)
%     r            - Angular velocity (rad/sec)
%     h            - Altitude above ground level (AGL) (m)
%     elevator     - elevator control input, rad. 
%     aileron      - combined aileron control input, rad. (da_r - da_l)/2
%     l_aileron    - left aileron control input, rad
%     r_aileron    - right aileron control input, rad
%     rudder       - rudder control input, rad. 
%     throttle     - throttle control input, nd. 
%     flap         - flap control input, rad. Defaults to fixed at zero.
%
% Note that you don't need to specify every field, just the ones you
% are interested in (unspecified variables will be free). Some fields have
% default values; to override these, either specify a value for them, or
% set the value to an empty matrix ([]) to leave them free.
%
% trim_UAV will return the TrimCondition data structure with the trim
% values embedded and a structure called OperatingPoint that contains the
% original specifications (op_spec), the operating point itself (op_point),
% and the report (op_report).
%
% setup.m gives several examples of usage for trim_UAV; we'll look at one
% case here: a climbing turn. For this flight condition, we need to specify
% three variables: airspeed, flight path angle, and turn rate. With
% trim_UAV, we do that by creating a data structure in TrimCondition.target
% with those three variables and the desired values:

TrimCondition.target = struct('V_s',17,'gamma',5/180*pi,'psidot',20/180*pi);
disp(TrimCondition.target)

%%
% We now pass the require arguments into trim_UAV, which will trim the
% model and display the op_report:

[TrimCondition,OperatingPoint] = trim_UAV(TrimCondition,AC);

%% 
% Success! We see the aircraft is now trimmed to a climbing turn. While
% trim_UAV does perform some checks, it is still possible to over constrain
% the model by specifying conflicting constraints. Good engineering
% judgment is still needed!
%
% This concludes the trim tutorial. Please send any comments or questions
% to Austin Murch (murch@aem.umn.edu).