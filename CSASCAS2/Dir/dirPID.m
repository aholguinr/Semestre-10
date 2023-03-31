clc;
clear;
close all;

%% Cargar el modelo (roll)
load('modelo_lin.mat')
modelo=latmod;

%% Eliminar datos no significativos de las matrices de estados
modelo.A(abs(modelo.A)<1e-10)=0;
modelo.B(abs(modelo.B)<1e-10)=0;
modelo.C(abs(modelo.C)<1e-10)=0;
modelo.D(abs(modelo.D)<1e-10)=0;

%% Funcion de transferencia
%solo necesitamos elevator / theta
modelo;
Mod_r = modelo(3,2);

g_r = tf(Mod_r)
rlocus(g_r), grid on;
% y elev_q = tf(modelo(3,1));

% actuador = tf(50.3855,[1 50.3855]);
% 
% g_th = actuador*g_th;
% g_q = actuador*g_q;

[n_th, d_th] = tfdata(g_r, 'v');
[n_q, d_q] = tfdata(g_r, 'v');

%% matriz de transferencia G = (gth gq)
% G = [gth gq];
step(g_r), title("Respuesta al escalón OL de \theta");
% step(gth), title("Respuesta al escalón OL de q");
%% SAS - Amortiguamiento empleando D
close all
s=tf("s");
step(g_r), title("Respuesta al escalón OL de r");

figure();
rlocus(g_r), grid on;


% Kd = 0.106;
Kd = 1.5;
grCL = feedback(-g_r,Kd);
figure()
step(grCL)

%% CAS
close all
gpsi_ol=grCL*(1/s);
% figure()
rlocus(gpsi_ol), grid on;
Ki = 0.005;
gthki=feedback(gpsi_ol*(Ki/s),1);
figure()
step(gthki),title ("Step Ki");

% figure()
% rlocus(gthki);
Kp = 5;

gpsiCL=feedback(gpsi_ol*(Kp+(Ki/s)),1);
figure()
step(gpsiCL)
xlim([0 10])
title ("Step PI+D psi");

%% 
figure()
plot(out.ScopeData1.time,out.ScopeData1.signals.values)
title('PI+D con ruido y perturbación')
legend({'\psi','r'})
xlabel('time [s]') 
ylabel('Amplitude[°, °/s]') 


