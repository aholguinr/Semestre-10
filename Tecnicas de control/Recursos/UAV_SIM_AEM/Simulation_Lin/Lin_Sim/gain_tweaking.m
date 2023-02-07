%setup;

%%
%=========================================================================%
% Change desired parameters
% 

% old baseline params: ki_TT=-.09; kp_TT=-.6; ki_RT=-0.022; kp_RT=-0.45;
% kp_RD=0.05;
%%
% simulation parameters
phi_mag = 690; % step size for phi doublet (degrees)
phi_pulse = 390; % doublet pulse time (seconds)

theta_mag=0*pi/180;

V_mag = 0; %m/s
V_pulse = 90; %sec

h_mag = 0; % h pulse magnitude (m) 
h_pulse = 90; %h pulse time (sec)

%% Environmental Parameters
%%% Dryden Wind Turbulence Model (+q +r)
Env.Winds.TurbulenceOn=0;
Env.Winds.TurbWindSpeed = 2; % these params determine the turbulence level for 1000 ft and below
Env.Winds.TurbWindDir = 1;

%%% Wind Gust Model
Env.Winds.GustOn=1;
% Gust Start time (sec)
Env.Winds.GustStartTime = 4;
% Gust Length [dx dy dz] (m)
Env.Winds.GustLength = [1 1 1];
% Gust amplitude [ug vg wg] (m/s)
Env.Winds.GustAmplitude = [1 1 1];

%%% Horizontal Wind Model
Env.Winds.SteadyWindOn=0;
Env.Winds.WindSpeed = 0;
Env.Winds.WindDir = 0;
AC.Sensors.NoiseOn = 0;

%%
run_time = 60; %simulation time in seconds
sim('UAV_Lin',run_time)

figure
subplot 221
plot(time_L,[h_L h_cmd],'LineWidth',2); title('h with both holds');grid;
subplot 222
plot(time_L,V_L+17,'LineWidth',2); title('V with both holds');grid;
subplot 223
plot(time_L,[psi_L psi_cmd_L],'LineWidth',2); title('psi');grid;
% % subplot 221
% % plot(time_L,[h_L h_cmd],'LineWidth',2); title('h');grid;
% % 
% % subplot 222
% % plot(time_L,[theta_L],'LineWidth',2); title('theta');grid;
% % 
% % subplot 223
% % plot(time_L,V_L+17,'LineWidth',2); title('V');grid;
% % 
% % subplot 224
% % plot(time_L,alpha_L+3,'LineWidth',2); title('alpha');grid;