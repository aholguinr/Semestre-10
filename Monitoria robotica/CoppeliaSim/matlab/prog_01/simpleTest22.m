%% Programa para verificar el uso de handles y desde MATLAB leer variables en Coppelia Sim.
% Establecer la conexión
    
function simpleTest22()
    vrep=remApi('remoteApi'); % usar el archivo prototipo (remoteApiProto.m)
    vrep.simxFinish(-1); % si se requiere, cerrar todas las conexiones abiertas.
    % asigna el handle de identificación de cliente clientID
    clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
    if (clientID>-1)
     disp('Conexión exitosa')
    end
    %Algoritmo
    
    [returnCode,H_MTB]=vrep.simxGetObjectHandle(clientID,'MTB',vrep.simx_opmode_blocking);
    
    [returnCode,P]= vrep.simxGetObjectPosition(clientID, H_MTB,-1,vrep.simx_opmode_blocking);
    % Muestra en la pantalla de comandos de MATLAB la posición
    disp('pos')
    disp(P)
    [returnCode,Or]=vrep.simxGetObjectOrientation(clientID,H_MTB,-1,vrep.simx_opmode_blocking);
    disp(Or)
    disp('ori')
    
    
    % Termina el programa y cierra la conexión de MATLAB con V-Rep.
    disp('Programa terminado')
    vrep.delete(); % llama el destructor!
end