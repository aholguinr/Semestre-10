%% model_check.m
% UAV_NL Model Verification
%
% Compares the linear/nonlinear doublet response of the current simulation 
% model (blue/green lines) with the checkcase data (red/black).
%
% University of Minnesota 
% Aerospace Engineering and Mechanics 
% Copyright 2011 Regents of the University of Minnesota. 
% All rights reserved.
%
% SVN Info: $Id$

% Execute this line of code in the command window to publish the pdf report
% publish('model_check.m',struct('format','pdf','showCode',false,'outputDir','Verification'));

example1

%% Full Linear Model
% Full 13 state linear model. Doublets on elevator, aileron, and rudder.
load('./Verification/doublet_fullmodel.mat')

% Plot results
figure(1)
subplot(321), hold on
plot(tsim,xsim(:,1),'r',  tlin,xlin(:,7)+xsim(1,1),'k'); grid on
title('Linear Velocity to Doublet Sequence [elevator,rudder,aileron]');
xlabel('Time (sec)');ylabel('u (m/sec)')
legend('NonLinear', 'Linear','Checkcase: NonLinear','Checkcase: Linear');
subplot(323),hold on
plot(tsim,xsim(:,2),'r',  tlin,xlin(:,8)+xsim(1,2),'k'); grid on
xlabel('Time (sec)');ylabel('v (m/sec)')
subplot(325),hold on
plot(tsim,xsim(:,3),'r',  tlin,xlin(:,9)+xsim(1,3),'k'); grid on
xlabel('Time (sec)');ylabel('w (m/sec)')

subplot(322),hold on
plot(tsim,180/pi*xsim(:,10),'r',  tlin,180/pi*(xlin(:,4)+xsim(1,10)),'k'); grid on
title('Angular Velocity to Doublet Sequence [elevator,rudder,aileron]');
xlabel('Time (sec)');ylabel('p (deg/sec)')
subplot(324),hold on
plot(tsim,180/pi*xsim(:,11),'r',  tlin,180/pi*(xlin(:,5)+xsim(1,11)),'k'); grid on
xlabel('Time (sec)');ylabel('q (deg/sec)')
subplot(326),hold on
plot(tsim,180/pi*xsim(:,12),'r',  tlin,180/pi*(xlin(:,6)+xsim(1,12)),'k'); grid on
xlabel('Time (sec)');ylabel('r (deg/sec)')


%% Longitudinal Linear Model
% Reduced order longitudinal linear model. Doublets on elevator only.
load('./Verification/doublet_longmodel.mat')

% Plot results
figure(2)
subplot(211),hold on
plot(tsim,180/pi*ysim(:,3),'r',  tlin,180/pi*(ylin(:,2)+ysim(1,3)),'k'); grid on
title('Longitudinal Model Doublet Sequence [elevator]');
xlabel('Time (sec)');ylabel('\alpha (deg)')
legend('NonLinear', 'Linear','Checkcase: NonLinear','Checkcase: Linear');

subplot(212),hold on
plot(tsim,180/pi*xsim(:,11),'r',  tlin,180/pi*(ylin(:,3)+xsim(1,11)),'k'); grid on
xlabel('Time (sec)');ylabel('q (deg/sec)')


%% Lateral-Directional Linear Model
% Reduced order lateral directional linear model. Doublets on aileron and
% rudder.
load('./Verification/doublet_latmodel.mat')

% Plot results
figure(3)
subplot(311),hold on
plot(tsim,180/pi*ysim(:,2),'r',  tlin,180/pi*(ylin(:,1)+ysim(1,2)),'k'); grid on
title('Lateral-Directional Model Doublet Sequence [rudder, aileron]');
xlabel('Time (sec)');ylabel('\beta (deg)')
legend('NonLinear', 'Linear','Checkcase: NonLinear','Checkcase: Linear');

subplot(312),hold on
plot(tsim,180/pi*xsim(:,10),'r',  tlin,180/pi*(ylin(:,2)+xsim(1,10)),'k'); grid on
xlabel('Time (sec)');ylabel('p (deg/sec)')

subplot(313),hold on
plot(tsim,180/pi*xsim(:,12),'r',  tlin,180/pi*(ylin(:,3)+xsim(1,12)),'k'); grid on
xlabel('Time (sec)');ylabel('r (deg/sec)')

