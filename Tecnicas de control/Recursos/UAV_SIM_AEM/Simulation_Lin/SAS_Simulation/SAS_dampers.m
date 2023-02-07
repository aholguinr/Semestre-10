%%
% SAS Pitch Rate and Yaw Damper
%
% This function shows the SAS dampers design process for lateral and
% longitudinal models of an UAV (Minnesota). 
% 
% In the first step, a SAS system is designed for the UAV longitudinal
% model. Due to stable longitudinal poles, only pitch rate feedback is
% used. Root-Locus and Bode are shown for elevator to alpha system.
% Then, the pitch feedback gain is found through iteration, looking for
% higher damping. Impulse linear and doublet non linear (elevator input) 
% simuluations are shown.
% 
% After, the procedure is repeated to find the roll an yaw rate gains. The
% roll rate gain is calculated first. Impulse linear and non linear (rudder
% input first, ailerons input after) simulations are shown.
%
% David Herrera UNAL 
% 2012


% Load models
cd ../NL_Sim
setup
cd ../SAS_Simulation
clc
%figure_path='/home/david/Documents/Dropbox/Doctorate/Activities/SAS-CAS/figures/';

%% Longitudinal system

close all
elevtoalpha=tf(longmod(2,1));
disp('')
disp('The elevator to alpha system is')
elevtoalpha
disp('Longitudinal Poles:')
disp('')
damp(elevtoalpha)
% Root-Locus
%h = figure; 
figure
rlocus(elevtoalpha)
grid on
%print(h,'-depsc',strcat(figure_path,'rlocus_LA_pitch.eps'))
%h = figure;
figure
% Bode
bode(elevtoalpha)
grid on
%print(h,'-depsc',strcat(figure_path,'bode_LA_pitch.eps'))
%polos=pole(elevtoalpha);
%zeta=cos(atan(imag(polos(1))/real(polos(1))));
%ct=abs(4.5/real(polos(1)));
%wn=abs(real(polos(1))/zeta);
%disp(['zeta: ' num2str(zeta)])
%disp(['Time constant: ' num2str(ct)])
%disp(['Natural Frecuency: ' num2str(wn)])
disp('')
disp('Root-Locus and Bode diagrams are shown (Elevator to alpha system)')
disp('')
disp('This system is stable, so only pitch rate feedback is needed')
disp('')
disp('Press any key to continue...')

pause
close all
clc

% Augmented System

disp('Now, the augmented system, long. model + actuator, is defined')
actuator= tf(50.3855,[1 50.3855]); % linear
aug_longmod=series(actuator,longmod);

disp('')
disp('The complete system is:')
aug_longmod

aa=aug_longmod.a; ba=aug_longmod.b; ca=aug_longmod.c; 
%h = figure;
% Root-Locus
rlocus(aa,ba(:,1),ca(3,:),0)
grid on
%print(h,'-depsc',strcat(figure_path,'rlocus_LAAug_pitch.eps'))
% Bode
%h = figure;
figure
bode(aa,ba(:,1),ca(3,:),0)
grid on
%print(h,'-depsc',strcat(figure_path,'bode_LAAug_pitch.eps'))
disp('')
disp('Root-Locus and Bode diagrams are shown (Elevator to q system)')
disp('')
% Poles
utoq=tf(ss(aa,ba(:,1),ca(3,:),0));
disp('The Elevator to q system is:')
utoq
disp('The Augmented System Poles are:')
damp(utoq)

disp('Press any key to continue...')
pause
clc

%% Pitch-SAS Design

disp('Now, we iterate over pitch rate feedback gain, in order to increase damping')
disp('')
disp('Watch the root-locus evolution as we change the feedback gain...')
disp('')
close all
zeta_opt=0;
k_opt=0;
for t=-100:180
acl=aa-ba(:,1)*t*0.001*ca(3,:);
utoq_fil=ss(acl,ba(:,1),ca(3,:),0);
rlocus(utoq_fil)
axis([-15 15 -15 15])
grid on
polos=pole(utoq_fil);
if find(real(pole(utoq_fil))>0)
    disp('UNSTABLE')
else
    zeta=cos(atan(imag(polos(2))/real(polos(2))));
    if zeta > zeta_opt && zeta < 1
        k_opt=0.001*t;
        zeta_opt=zeta;
    end
    ct=abs(4.5/real(polos(2)));
    wn=abs(real(polos(2))/zeta);
    %damp(utoq_fil)
    %disp(['zeta: ' num2str(zeta)])
    %disp(['Time constant: ' num2str(ct)])
    %disp(['Natural Frecuency: ' num2str(wn)])
end
pause(0.01)
end

close all

acl=aa-ba(:,1)*k_opt*ca(3,:);
utoq_fil=ss(acl,ba(:,1),ca(3,:),0);
%h=figure;
figure
% Root - Locus
rlocus(utoq_fil)
grid on
%print(h,'-depsc',strcat(figure_path,'rlocus_LAfil_pitch.eps'))
%h=figure;
figure
bode(utoq_fil)
grid on
%print(h,'-depsc',strcat(figure_path,'bode_LAfil_pitch.eps'))
clc
disp('Root-Locus and Bode diagrams are shown (Elevator to q system with feedback)')
disp('')
disp('These are the optimal values')
disp('')
disp(['zeta: ' num2str(zeta_opt)])
disp(['K_q ' num2str(k_opt)])
disp('Press any key to continue...')
pause
close all
clc

% simulation

disp('Non Linear simulation is being made...')
disp('We want to compare Longitudinal response with and with out SAS')

roll_input=0;
pitch_input=1;
yaw_input=0;
kp=0;
kr=0;
washout_filter=0;
sim('UAV_NL_NAug')
sim('UAV_NL_Aug')
stime=0:12.5/(length(q)-1):12.5;
%h=figure;
figure
plot(stime,q,'LineWidth',2)
hold
plot(stime,q_aug,'r','LineWidth',2)
grid on
legend('Long. Model','Aug. Long. Model')
title('q [deg/sec]')
%print(h,'-depsc',strcat(figure_path,'q_LAvLAaug.eps'))
%h=figure;
figure
plot(stime,theta,'LineWidth',2)
hold
plot(stime,theta_aug,'r','LineWidth',2)
grid on
legend('Long. Model','Aug. Long. Model')
title('$\theta$ [deg]','interpreter','latex')
%print(h,'-depsc',strcat(figure_path,'theta_LAvLAaug.eps'))

disp('Plots show the system response with SAS on (Aug. Model) and with SAS off')
disp('Press any key to continue...')
pause
clc
close all

%% SAS Roll-Yaw Rate

% setup %% Already loaded
% clc
% figure_path='/home/david/Documents/Dropbox/Doctorate/Activities/SAS-CAS/figures/';

%% Lateral Model 

disp('Now, it is time for the lateral model')
disp('')
% Transfer function definition

ailtop=tf(latmod(2,1));
ailtor=tf(latmod(3,1));
rudtop=tf(latmod(2,2));
rudtor=tf(latmod(3,2));
disp('Roll-Yaw modes:')
damp(latmod)

disp('')
disp('This system is unstable')
disp('In order to apply the SAS design procedure, we remove the psi state')

disp('')
disp('Press any key to continue...')
pause
clc
disp('Now, we define the augmented system:')
disp('Actuator + Model + Washout Filter')

% Augmented system
ryactuator=-[ss(actuator) 0;0 ss(actuator)];
%aug_latmod=series(ryactuator,latmod([2 3],:));
aug_latmod=series(ryactuator,modred(latmod([2 3],:),5,'Truncate'));

% wash-out filter
tau_wo=0.33;
washout_filter=tf([1 0],[tau_wo 1]);
% system with filter
complete_filter=[ss(1) 0; 0 ss(washout_filter)];
aug_latmod_wo=series(aug_latmod,complete_filter);

disp('')
disp('This is the complete model:')
disp('')
aug_latmod_wo
pause
disp('')
disp('Press any key to continue...')
% Roll classical design

clc
disp('Now, we iterate over roll rate feedback gain, in order to increase damping')
disp('')
disp('Watch the root-locus evolution as we change the feedback gain...')
disp('')

close all
clear z_opt sys_opt zeta_opt kr kp
indice=1;
for z=-0.2:0.001:0.2
    acl=aug_latmod_wo.a-aug_latmod_wo.b*[z 0; 0 0]*aug_latmod_wo.c;
    roll_s=ss(acl,aug_latmod_wo.b(:,1),aug_latmod_wo.c(1,:),0);
    rlocus(roll_s)
    [Wn,zeta,P]=damp(roll_s);
    if min(size(find(real(P)>0)))==0
        z_opt(indice)=z;
        indice=indice+1;
    end
    pause(0.01)
    %disp(z)
end

for z=1:max(size(z_opt))
    roll_s=feedback(aug_latmod_wo,[z_opt(z) 0; 0 0]);
    [Wn,zeta,P]=damp(roll_s);
    %min(abs(zeta))
    if z==1
        zeta_opt=min(abs(zeta));
        sys_opt=feedback(aug_latmod_wo,[z_opt(z) 0; 0 0]);
        kp=z_opt(z);
    end
    if min(abs(zeta)) > zeta_opt %&& min(abs(zeta)) > 0.7
        zeta_opt=min(abs(zeta));
        sys_opt=feedback(aug_latmod_wo,[z_opt(z) 0;0 0]);
        kp=z_opt(z);
    end
    %pause(0.1)
end

clc
close all
kr=0;
disp('')
disp('The optimal feedback gain is:')
disp(kp)
disp('Plots show impulse response (linear simulation)')
impulse(sys_opt,aug_latmod,5)
grid
legend('SAS on','SAS off')
figure
impulse(sys_opt(1,1),aug_latmod(1,1),5)
legend('SAS on','SAS off')
grid

disp('')
disp('Press any key to continue...')
pause

disp('')
disp('Now, the non linear simulation...')
disp('Please wait')
close all
roll_input=1;
pitch_input=0;
yaw_input=1;
sim('UAV_NL_NAug')
sim('UAV_NL_Aug')
stime=0:40/(length(p)-1):40;
plot(stime,p,'LineWidth',2)
hold
plot(stime,p_aug,'r','LineWidth',2)
grid on
legend('Lat. Model','Aug. Lat. Model')
title('p [deg/sec]')
figure
plot(stime,phi,'LineWidth',2)
hold
plot(stime,phi_aug,'r','LineWidth',2)
grid on
legend('Lat. Model','Aug. Lat. Model')
title('$\phi$ [deg]','interpreter','latex')

disp('')
disp('Press any key to continue...')
pause
% Yaw classical design

clc
disp('At this moment, we want to repeat the procedure to find the yaw feedback gain')
close all
clear z_opt sys_opt zeta_opt kr
indice=1;
for z=-1:0.001:1
    yaw_s=feedback(aug_latmod_wo,[kp 0;0 z]);
    %rlocus(yaw_s)
    [Wn,zeta,P]=damp(yaw_s);
    %real(P)
    if max(size(find(real(P)>=-0.01)))==1
        z_opt(indice)=z;
        indice=indice+1;
    end
    %pause(0.005)
    %disp(z)
end

for z=1:max(size(z_opt))
    yaw_s=feedback(aug_latmod_wo,[kp 0; 0 z]);
    [Wn,zeta,P]=damp(yaw_s);
    rlocus(yaw_s(2,2))
    %min(abs(zeta))
    if z==1
        zeta_opt=min(abs(zeta));
        sys_opt=feedback(aug_latmod_wo,[kp 0; 0 z]);
        kr=z_opt(z);
    end
    if min(abs(zeta)) > zeta_opt %&& min(abs(zeta)) < 0.9
        zeta_opt=min(abs(zeta));
        sys_opt=feedback(aug_latmod_wo,[kp 0; 0 z]);
        kr=z_opt(z);
    end
    pause(0.01)
end

close all
disp('')
disp('This is the optimal value:')
disp(kr)
disp('')
disp('Plots show impulse response (linear simulation)')
impulse(sys_opt,aug_latmod,5)
grid
legend('SAS on','SAS off')
figure
impulse(sys_opt(2,2),aug_latmod(2,2),5)
legend('SAS on','SAS off')
grid

disp('')
disp('Press any key to continue...')
pause

clc
disp('Finally, the non linear simulation with SAS system (lateral model) for Yaw and Roll rates')
close all
roll_input=1;
pitch_input=0;
yaw_input=1;
sim('UAV_NL_NAug')
sim('UAV_NL_Aug')
stime=0:40/(length(p)-1):40;
plot(stime,r,'LineWidth',2)
hold
plot(stime,r_aug,'r','LineWidth',2)
grid on
legend('Lat. Model','Aug. Lat. Model')
title('r [deg/sec]')
figure
plot(stime,psi,'LineWidth',2)
hold
plot(stime,psi_aug,'r','LineWidth',2)
grid on
legend('Lat. Model','Aug. Lat. Model')
title('$\psi$ [deg]','interpreter','latex')
figure
plot(stime,p,'LineWidth',2)
hold
plot(stime,p_aug,'r','LineWidth',2)
grid on
legend('Lat. Model','Aug. Lat. Model')
title('p [deg/sec]')
figure
plot(stime,phi,'LineWidth',2)
hold
plot(stime,phi_aug,'r','LineWidth',2)
grid on
legend('Lat. Model','Aug. Lat. Model')
title('$\phi$ [deg]','interpreter','latex')

clc
disp('Pitch gain:')
disp(k_opt)
disp('Roll gain:')
disp(kp)
disp('Wash-out filter:')
washout_filter
disp('Yaw gain')
disp(kr)
disp('End')


%% Pole placement + Observer (Be carefull)

% yaw-roll-damping system
%yr_poles=real(pole(aug_latmod_wo));
%yr_poles(3)=yr_poles(3)+0.1*1i;%-5;
%yr_poles(4)=yr_poles(4)-0.1*1i;%-5;
%yr_poles(5)=yr_poles(5)-5;
%SAS_gain=place(aug_latmod_wo.a,aug_latmod_wo.b,yr_poles);

% closed-loop
%aug_latmod_wo_cl=ss(aug_latmod_wo.a-aug_latmod_wo.b*SAS_gain,aug_latmod_wo.b,aug_latmod_wo.c,aug_latmod_wo.d);


% time response
%h=figure;
% impulse(aug_latmod_wo,aug_latmod_wo_cl,5)
% grid on
% print(h,'-depsc',strcat(figure_path,'impulse_LAfil_yr.eps'))
% % root-locus
% h=figure;
% rlocus(aug_latmod_wo_cl(1,1))
% grid on
% print(h,'-depsc',strcat(figure_path,'rlocus_LAfil_yr.eps'))
% clc
% damp(aug_latmod_wo_cl)

% simulation

% l_poles=-5+yr_poles;
% L_SAS=place(aug_latmod_wo.a',aug_latmod_wo.c',l_poles);
% L_SAS=L_SAS';
% IntegerTimeDelay = 2;
% DON'T RUN

% close all
% sim('UAV_NL_RY')
% sim('UAV_NL_RYAug')
% stime=0:40/(length(p)-1):40;
% h=figure;
% plot(stime,p,'LineWidth',2)
% hold
% plot(stime,p_aug,'r','LineWidth',2)
% grid on
% legend('Lat. Model','Aug. Lat. Model')
% title('p [deg/sec]')
% print(h,'-depsc',strcat(figure_path,'p_LAvLAaug.eps'))
% h=figure;
% plot(stime,phi,'LineWidth',2)
% hold
% plot(stime,phi_aug,'r','LineWidth',2)
% grid on
% legend('Lat. Model','Aug. Lat. Model')
% title('$\phi$ [deg]','interpreter','latex')
% print(h,'-depsc',strcat(figure_path,'phi_LAvLAaug.eps'))
% h=figure;
% plot(stime,r,'LineWidth',2)
% hold
% plot(stime,r_aug,'r','LineWidth',2)
% grid on
% legend('Lat. Model','Aug. Lat. Model')
% title('r [deg/sec]')
% print(h,'-depsc',strcat(figure_path,'r_LAvLAaug.eps'))
% h=figure;
% plot(stime,psi,'LineWidth',2)
% hold
% plot(stime,psi_aug,'r','LineWidth',2)
% grid on
% legend('Lat. Model','Aug. Lat. Model')
% title('$\psi$ [deg]','interpreter','latex')
% print(h,'-depsc',strcat(figure_path,'psi_LAvLAaug.eps'))