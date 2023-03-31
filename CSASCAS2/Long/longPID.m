clc;
clear;
close all;

%% Cargar el modelo
load('modelo_lin.mat')
modelo=longmod;
longmod.A;
%% Eliminar datos no significativos de las matrices de estados
modelo.A(abs(modelo.A)<1e-10)=0;
modelo.B(abs(modelo.B)<1e-10)=0;
modelo.C(abs(modelo.C)<1e-10)=0;
modelo.D(abs(modelo.D)<1e-10)=0;
%% Funcion de transferencia
%solo necesitamos elevator / theta
g_q = tf(modelo(3,1))
% y elev_q = tf(modelo(3,1));


%% matriz de transferencia G = (gth gq)
% G = [gth gq];
step(g_q), title("Respuesta al escalón OL de q");
% step(gth), title("Respuesta al escalón OL de theta");
%% SAS - Amortiguamiento empleando D
s=tf("s");
figure();
rlocus(g_q)

Kd = 1.5;
gqCL = feedback(-g_q,Kd);
figure()
step(gqCL)

%% CAS

gthol=gqCL*(1/s);
% figure()
% rlocus(gthol);
Ki = 2;
gthki=feedback(gthol*(Ki/s),1);
% figure()
% rlocus(gthki);
Kp = 4.7;


gthCL=feedback(gthol*(Kp+(Ki/s)),1);
figure()
step(gthCL)
xlim([0 10])
%% 
figure()
plot(out.ScopeData2.time,out.ScopeData2.signals.values)
title('PI+D con ruido y perturbación')
legend({'y = \theta','y = \.{a}'})
xlabel('time [s]') 
ylabel('Amplitude[°, °/s]') 

figure()
plot(out.controlruido.time,out.controlruido.signals.values)
title('PI+D con ruido y perturbación')
legend({'y = \theta','y = \theta'})
xlabel('time [s]') 
ylabel('Amplitude[°, °/s]') 

