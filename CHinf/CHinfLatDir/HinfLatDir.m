clc;
clear;
close all;

%% Carga del modelo
load('modelo_lin.mat')

modelo = latmod;

Alat = modelo.A
Blat = modelo.B
Clat = modelo.C
Dlat = modelo.D

%% Eliminacion de datos irrelevantes
Alat(abs(Alat)<1e-10)=0;
Blat(abs(Blat)<1e-10)=0;
Clat(abs(Clat)<1e-10)=0;
Dlat(abs(Dlat)<1e-10)=0;

%% Seleccion de estados
modelo;
Blat=Blat(:,1);
Clat=Clat(4,:)
Dlat=Dlat(4,1);
G=ss(Alat,Blat,Clat,Dlat)

%% Filtros
s=tf('s');

wB1=8*2*pi;
A1=0.0003;
M1=0.3;

wB3=6*2*pi;
A3=0.1;
M3=10;

% W1=(0.5*s+0.015)/(s+0.00015);
W1=(s/M1+wB1)/(s+wB1*A1);
W2=tf(1,1);
W3=(1+s/M3)/(1+(s/wB3));

%% Grafica de filtros
hold on
bodemag(1/W1,'r');
bodemag(1/W2,'g');
bodemag(1/W3,'b');
hold off

%% Calculo del controlador
[K,CL,gamma]=mixsyn(G,W1,W2,W3)

% K.A(abs(K.A)<1e-10) = 0;
% K.B(abs(K.B)<1e-10) = 0;
% K.C(abs(K.C)<1e-10) = 0;
% K.D(abs(K.D)<1e-10) = 0;
% 
% CL.A(abs(CL.A)<1e-10) = 0;
% CL.B(abs(CL.B)<1e-10) = 0;
% CL.C(abs(CL.C)<1e-10) = 0;
% CL.D(abs(CL.D)<1e-10) = 0;
% 
% Gg=augw(G,W1,W2,W3);
%  [K, CL, gamma]=hinfsyn(Gg,2,1);

%% Conexion de planta
OL=series(K,G);

I = eye(14,1);

GCL=feedback(OL,I);

figure (1)
step(GCL)

% step(CL), xlim([0 10])
%% Comprobación W1
S = feedback(1,OL);
figure (2)
bodemag(S,'r');
hold on
bodemag(1/W1,'g');
hold off

%%Comprobación W2
S = feedback(1,OL);
figure(3)
bodemag(S*K,'r');
hold on
bodemag(1/W2,'g'), title("Comprobación W2");
legend("Señal Filtrada", "Filtro");
hold off

%% Comprobacion W3

T = feedback(OL,1);
figure (4)
bodemag(T,'r');
hold on
bodemag(1/W3,'g'), title("Comprobación W3");
legend("Señal Filtrada", "Filtro");
hold off


% Gg=augw(G,W1,W2,w3);
% Kaug=hinfsyn(Gg,2,1);
% 
% K.u='e';
% K.y='u';
% G.u='u';
% G.y='y';
% sum=sumblk('e=r-y');
% 
% CL=connect(K,G,sum,'r',{'y','e'})
