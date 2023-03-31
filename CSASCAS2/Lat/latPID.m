clc;
clear;
close all;

%% Cargar el modelo (roll)
load('modelo_lin.mat')
%%
modelo=latmod;

%% Eliminar datos no significativos de las matrices de estados
modelo.A(abs(modelo.A)<1e-10)=0;
modelo.B(abs(modelo.B)<1e-10)=0;
modelo.C(abs(modelo.C)<1e-10)=0;
modelo.D(abs(modelo.D)<1e-10)=0;

%% Funcion de transferencia
%solo necesitamos elevator / theta
modelo;
Mod_p = modelo(2,1);

g_p = tf(Mod_p)


%% matriz de transferencia G = (gth gq)
% G = [gth gq];
step(g_p), title("Respuesta al escalón OL de \theta");
% step(gth), title("Respuesta al escalón OL de q");
%% SAS - Amortiguamiento empleando D
% close all
s=tf("s");
step(g_p);

figure();
rlocus(g_p), grid on;


% Kd = 0.106;
Kd = 2;
gpCL = feedback(-g_p,Kd);
figure()
step(gpCL)

%% CAS
close all
gphi_ol=gpCL*(1/s);
% figure()
rlocus(gphi_ol), grid on;
Ki = 0.002;
%gthki=feedback(gphi_ol*(Ki/s),1);
%figure()
%step(gthki),title ("Step Ki");

% figure()
% rlocus(gthki);
Kp = 7;

gphiCL=feedback(gphi_ol*(Kp+(Ki/s)),1);
figure()
step(gphiCL)
xlim([0 10])
title ("Step PI+D phi");
%% 
figure()
plot(out.ScopeData1.time,out.ScopeData1.signals.values)
title('PI+D con ruido y perturbación')
legend({'\phi','p'})
xlabel('time [s]') 
ylabel('Amplitude[°, °/s]') 




