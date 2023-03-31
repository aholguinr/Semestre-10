clc;
clear;
close all;

%% Cargar el modelo
load('modelo_lin.mat')
modelo=latmod;

%% Eliminar datos no significativos de las matrices de estados
modelo.A(abs(modelo.A)<1e-10)=0;
modelo.B(abs(modelo.B)<1e-10)=0;
modelo.C(abs(modelo.C)<1e-10)=0;
modelo.D(abs(modelo.D)<1e-10)=0;

%% Espacio de estados
% Entradas ail (1) y rud(2), con estados p (2) y r (3). Se integran p
% y r para obtener phi (4) y psi (5)
p_ail = modelo(2,1);
p_rud = modelo(1,2);

r_ail = modelo(3,1);
r_rud = modelo(3,2);

%% Funcion de transferencia
%Resultan matriz 2x4 de estados phi/p, psi/r para ail y para rudd
g_phi_ail = tf(modelo(4,1));
g_phi_rud = tf(modelo(4,2));

g_psi_ail = tf(modelo(5,2));
g_psi_rud = tf(modelo(5,2));

g_p_ail = tf(modelo(2,1));
g_p_rud = tf(modelo(2,2));

g_r_ail = tf(modelo(3,1));
g_r_rud = tf(modelo(3,2));
 
% matriz de transferencia G = (gth gq)
G_pos = [g_phi_ail g_psi_ail;
     g_phi_rud  g_psi_rud];

G_vel = [g_p_ail g_r_ail;g_p_rud g_r_rud];

% step(g_th), title("Respuesta al escalón OL de \theta");
% step(gth), title("Respuesta al escalón OL de q");
%% SAS - Amortiguamiento empleando D
% 
% figure();
% rlocus(-g_q)
% 
% Kd = 0.059;
% gqCL = feedback(g_q,-Kd);
% 
% figure()
% step(gqCL)


%% Parámetros
Kp_a = 7;
Ki_a = 0.002;
Kd_a = 2;

Kp_r = 7;
Ki_r = 0.002;
Kd_r = 2;