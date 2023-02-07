%% example1.m
%
%-------------- Doublet response, NonLinear and Linear Models -------------
%
% Script trims the model to a level flight condition and linearizes.
% It compares doublet responses between full nonlinear sim and 
% the full and decoupled linearized models
%
% University of Minnesota 
% Aerospace Engineering and Mechanics 
% Copyright 2011 Regents of the University of Minnesota. 
% All rights reserved.
%
% SVN Info: $Id$


% Assumes model has already been trimmed and linearized, ie, run setup.m
% Construct 1 degree double sequence. 
f=50;    % 50 Hz input sampling on sequence
d=1;      % 2 sec pulse duration
a=[1 1 1]/180*pi;% pulse amplitude(deg), [ele,rud,ail]
dub=[zeros(4*f*d,1);ones(f*d,1);-1*ones(f*d,1);zeros(4*f*d,1)]; % a doublet
ulin = [  [a(1)*dub;0*dub;0*dub], [0*dub;a(2)*dub;0*dub] [0*dub;0*dub;a(3)*dub],]; % doublet sequence
tlin=[0:length(ulin)-1]/f;
% setup trim bias vector
trimbias = [TrimCondition.Inputs.throttle,TrimCondition.Inputs.elevator,TrimCondition.Inputs.rudder,TrimCondition.Inputs.l_aileron,TrimCondition.Inputs.r_aileron,TrimCondition.Inputs.l_flap,TrimCondition.Inputs.l_flap,0];

%% Full Linear Model

% Run linear NonLinear
[ylin,t,xlin]=lsim(linmodel(:,[2,3,8]),ulin,tlin); % assumes input order of elevator, aileron, rudder

% add trim bias to doublet commands
ulin_nl = [zeros(length(tlin),1) ulin(:,[1 2]), zeros(length(tlin),4) ulin(:,3)] + repmat(trimbias,length(ulin),1);
% Run the same doublet sequence via simulink
[tsim,xsim,ysim]=sim('UAV_NL',[0 max(tlin)],[],[tlin' ulin_nl]);

% Save data
if exist('savedata','var')
    save('./Verification/linearmodels.mat','longmod','latmod','linmodel','TF','OperatingPoint')
    save('./Verification/doublet_fullmodel.mat','xlin','tlin','ylin','xsim','tsim','ysim')
end
%% Plot results
figure(1)
set(gcf,'Name','Full Linear Model')
set(gcf,'Units','normalized')
set(gcf,'Position',[0.0050    0.0533    0.4900    0.8533])   
subplot(321),
plot(tsim,xsim(:,1),  tlin,xlin(:,7)+xsim(1,1)); grid on
title('Linear Velocity to Doublet Sequence [elevator,rudder,aileron]');
xlabel('Time (sec)');ylabel('u (m/sec)')
legend('NonLinear', 'Linear');
subplot(323),
plot(tsim,xsim(:,2),  tlin,xlin(:,8)+xsim(1,2)); grid on
xlabel('Time (sec)');ylabel('v (m/sec)')
subplot(325),
plot(tsim,xsim(:,3),  tlin,xlin(:,9)+xsim(1,3)); grid on
xlabel('Time (sec)');ylabel('w (m/sec)')

subplot(322),
plot(tsim,180/pi*xsim(:,10),  tlin,180/pi*(xlin(:,4)+xsim(1,10))); grid on
title('Angular Velocity to Doublet Sequence [elevator,rudder,aileron]');
xlabel('Time (sec)');ylabel('p (deg/sec)')
subplot(324),
plot(tsim,180/pi*xsim(:,11),  tlin,180/pi*(xlin(:,5)+xsim(1,11))); grid on
xlabel('Time (sec)');ylabel('q (deg/sec)')
subplot(326),
plot(tsim,180/pi*xsim(:,12),  tlin,180/pi*(xlin(:,6)+xsim(1,12))); grid on
xlabel('Time (sec)');ylabel('r (deg/sec)')


%% Longitudinal Linear Model
ulin = [  [a(1)*dub;0*dub;0*dub], [0*dub;0*dub;0*dub] ]; % doublet sequence

% Run linear sim
[ylin,t,xlin]=lsim(longmod,ulin,tlin);

% add trim bias to doublet commands
ulin_nl = [zeros(length(tlin),1) ulin(:,1), zeros(length(tlin),6)] + repmat(trimbias,length(ulin),1);

% Run the same doublet sequence via simulink
[tsim,xsim,ysim]=sim('UAV_NL',[0 max(tlin)],[],[tlin' ulin_nl]);

% Save data
if exist('savedata','var')
    save('./Verification/doublet_longmodel.mat','xlin','tlin','ylin','xsim','tsim','ysim')
end
%% Plot results
figure(2)
set(gcf,'Name','Longitudinal Model')
set(gcf,'Units','normalized')
set(gcf,'Position',[0.0050    0.0533    0.4900    0.8533])
subplot(211),
plot(tsim,180/pi*ysim(:,3),  tlin,180/pi*(ylin(:,2)+ysim(1,3))); grid on
title('Longitudinal Model Doublet Sequence [elevator]');
xlabel('Time (sec)');ylabel('\alpha (deg)')
legend('NonLinear', 'Linear');

subplot(212),
plot(tsim,180/pi*xsim(:,11),  tlin,180/pi*(ylin(:,3)+xsim(1,11))); grid on
xlabel('Time (sec)');ylabel('q (deg/sec)')


%% Lateral-Directional Linear Model
ulin = [  [0*dub;a(2)*dub;0*dub], [a(3)*dub;0*dub;0*dub] ]; % doublet sequence aileron, rudder

% Run linear NonLinear
[ylin,t,xlin]=lsim(latmod,ulin,tlin);

% add trim bias to doublet commands
ulin_nl = [zeros(length(tlin),2) ulin(:,2), zeros(length(tlin),4) ulin(:,1)] + repmat(trimbias,length(ulin),1);

% Run the same doublet sequence via simulink
[tsim,xsim,ysim]=sim('UAV_NL',[0 max(tlin)],[],[tlin' ulin_nl]);

% Save data
if exist('savedata','var')
    save('./Verification/doublet_latmodel.mat','xlin','tlin','ylin','xsim','tsim','ysim')
end

%% Plot results
figure(3)
set(gcf,'Name','Lateral-Directional Model')
set(gcf,'Units','normalized')
set(gcf,'Position',[0.0050    0.0533    0.4900    0.8533])
subplot(311),
plot(tsim,180/pi*ysim(:,2),  tlin,180/pi*(ylin(:,1)+ysim(1,2))); grid on
title('Lateral-Directional Model Doublet Sequence [rudder, aileron]');
xlabel('Time (sec)');ylabel('\beta (deg)')
legend('NonLinear', 'Linear');

subplot(312),
plot(tsim,180/pi*xsim(:,10),  tlin,180/pi*(ylin(:,2)+xsim(1,10))); grid on
xlabel('Time (sec)');ylabel('p (deg/sec)')

subplot(313),
plot(tsim,180/pi*xsim(:,12),  tlin,180/pi*(ylin(:,3)+xsim(1,12))); grid on
xlabel('Time (sec)');ylabel('r (deg/sec)')

