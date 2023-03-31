clc;
clear;
close all

%% Cargar el modelo
load('modelo_lin.mat')
modelo=linmodel;

%% Eliminar datos no significativos de las matrices de estados
modelo.A(abs(modelo.A)<1e-10)=0;
modelo.B(abs(modelo.B)<1e-10)=0;
modelo.C(abs(modelo.C)<1e-10)=0;
modelo.D(abs(modelo.D)<1e-10)=0;

%% Selección de estados
g_p_ail = tf(modelo(8,8));
g_p_rud = tf(modelo(8,3));

g_q = tf(modelo(9,2));

g_r_ail = tf(modelo(10,8));
g_r_rud = tf(modelo(10,3));

%% Parámetros
% Estos parámetros para los PIDs fueron asignados con los análisis hechos
% anteriormente en sus respectivos modelos.
% PID del elevador
Kp_e = 4.7;
Ki_e = 2;
Kd_e = 1.5;

% PID del alerón
Kp_a = 7;
Ki_a = 0.002;
Kd_a = 2;

% PID del timón de cola
Kp_r = 5;
Ki_r = 0.005;
Kd_r = 1.5;

%% 
close all
figure()
plot(out.ScopeData1.time,out.ScopeData1.signals.values)
title('Simulación ángulos acoplados')
legend({'\theta','\phi','\psi'})
xlabel('time [s]') 
ylabel('Amplitude[°]') 