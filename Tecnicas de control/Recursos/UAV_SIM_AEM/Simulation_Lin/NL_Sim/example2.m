%% example2.m
% 
%---------- Trim & linearize over a range of flight conditions ------------
%
% Script calculates a set of level flight trim condtions and linear models
% for different airspeeds. Plots trim conditions and dynamic mode
% characteristics as a function of airspeed.
%
% University of Minnesota 
% Aerospace Engineering and Mechanics 
% Copyright 2011 Regents of the University of Minnesota. 
% All rights reserved.
%
% SVN Info: $Id$

% -------------V_s plot----------------
% Trim to set of air speeds
speeds=23:-1:10;

% Allocate memory
alpha       = zeros(length(speeds),1);
elevator    = zeros(length(speeds),1);
throttle    = zeros(length(speeds),1);
phugoid     = zeros(length(speeds),2);
shortperiod = zeros(length(speeds),2);
dutchroll   = zeros(length(speeds),2);
rollmode    = zeros(length(speeds),2);
spiralmode  = zeros(length(speeds),2);

% Compute trim points
fprintf('\nLevel Flight Trim\n  Trimming at V_s:\n');
for trimpt=[1:length(speeds)],
    fprintf(1,'     %3.2f,',speeds(trimpt));
    % specify trim target
    TrimCondition.target = struct('V_s',speeds(trimpt),'gamma',0);
    [TrimCondition,OperatingPoint] = trim_UAV(TrimCondition,AC,0,0);
    fprintf(1,'Residual=%5.2f\n',speeds(trimpt)-OperatingPoint.op_report.Outputs(1).y);
    % pull out trim alpha, ele, thr
    alpha(trimpt)   = OperatingPoint.op_report.Outputs(3).y*180/pi;
    elevator(trimpt)= TrimCondition.Inputs.elevator*180/pi;
    throttle(trimpt)= TrimCondition.Inputs.throttle*100;

    % pull out linear models
    [longmod,spmod,latmod,linmodel]=linearize_UAV(OperatingPoint,0);
    
    % Longitudinal
    [wn,z]=damp(longmod);
    phugoid(trimpt,:)     = [wn(2)/2/pi,z(2)];
    shortperiod(trimpt,:) = [wn(5)/2/pi,z(5)];
    
    % Lateral-Directional
    [wn,z]=damp(latmod);
    dutchroll(trimpt,:)  = [wn(3)/2/pi,z(3)];
    rollmode(trimpt,:)   = [wn(5)/2/pi,z(5)];
    spiralmode(trimpt,:) = [wn(2)/2/pi,z(2)];
end
fprintf(' Done\n');

% Make V_s trim point plot
figure(1),clf
set(1,'Name','Trim Points')
[ax,h1,h2]=plotyy(speeds,[elevator,alpha],speeds,throttle); grid on
set(ax,{'YColor'},{'blue';'red'});
set([h1;h2],{'Color'},{'blue';'blue';'red'});
set([h1;h2],{'Marker'},{'o';'s';'>'})
set([h1;h2],{'MarkerFaceColor'},{'blue';'none';'red'});
title('Trimmed level flight by V_s');
legend([h1;h2], { 'elevator','alpha','throttle'} );
set([h1;h2],{'Marker'},{'o';'s';'>'});
ylabel(ax(1),'Elevator(deg),  alpha(deg)');
ylabel(ax(2),'Throttle(%)');
xlabel('V_s (m/s)')

% Make longitudinal plot
figure(2),clf
set(2,'Name','Longitudinal Modes')
subplot(221),plot(speeds,phugoid(:,1),'-s'),grid on
title('Phugoid Mode Frequency');ylabel('Frequency (Hz)');xlabel('V_s (m/s)');

subplot(223),plot(speeds,phugoid(:,2),'-s'),grid on
title('Phugoid Mode Damping');ylabel('Damping');xlabel('V_s (m/s)');

subplot(222),plot(speeds,shortperiod(:,1),'-s'),grid on
title('Short-Period Frequency');ylabel('Frequency (Hz)');xlabel('V_s (m/s)');

subplot(224),plot(speeds,shortperiod(:,2),'-s'),grid on
title('Short-Period Damping');ylabel('Damping');xlabel('V_s (m/s)');

% Make lateral directional plot
figure(3),clf
set(3,'Name','Lateral-Directional Modes')
subplot(221),plot(speeds,dutchroll(:,1),'-s'),grid on
title('Dutch Roll Mode Frequency');ylabel('Frequency (Hz)');xlabel('V_s (m/s)');

subplot(223),plot(speeds,dutchroll(:,2),'-s'),grid on
title('Dutch Roll Mode Damping');ylabel('Damping');xlabel('V_s (m/s)');

subplot(222),plot(speeds,1./rollmode(:,1),'-s'),grid on
title('Roll Mode Time Constant');ylabel('Time Constant (s)');xlabel('V_s (m/s)');

subplot(224),plot(speeds,1./spiralmode(:,1),'-s'),grid on
title('Spiral Mode Time Constant');ylabel('Time Constant (s)');xlabel('V_s (m/s)');
set(gca,'ylim',[100 500])
