function pruebas2()
vrep=remApi('remoteApi'); % usar el archivo prototipo (remoteApiProto.m)
    vrep.simxFinish(-1); % si se requiere, cerrar todas las conexiones abiertas.
    % asigna el handle de identificación de cliente clientID
    clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
    if (clientID>-1)
     disp('Conexión exitosa')
    end
    %Algoritmo
    
    [returnCode,H_MTB]=vrep.simxGetObjectHandle(clientID,'MTB',vrep.simx_opmode_blocking);
    [returnCode,H_Rectangle]=vrep.simxGetObjectHandle(clientID,'Rectangle',vrep.simx_opmode_blocking);
    
    
    
    [returnCode,P_MTB]= vrep.simxGetObjectPosition(clientID, H_MTB,-1,vrep.simx_opmode_blocking);
    [returnCode,P_Rectangle]= vrep.simxGetObjectPosition(clientID, H_Rectangle,-1,vrep.simx_opmode_blocking);
    
    
    disp('pos mtb')
    disp(P_MTB)
    
    disp('pos rec')
    disp(P_Rectangle)
    %[returnCode,Or]=vrep.simxGetObjectOrientation(clientID,H_Cuboid,-1,vrep.simx_opmode_blocking);
    %disp(Or)
    %disp('ori')
    
    dx=0.1; dy=0.1; dz=0;
    P_Rectangle_N = P_Rectangle + [dx dy dz];
   
     for i=1:10
        disp(P_Rectangle_N) 
        % Asigna la posición Pd a la caja
        [returnCode]=vrep.simxSetObjectPosition(clientID,H_Rectangle,-1,P_Rectangle_N,vrep.simx_opmode_blocking);
        P_Rectangle_N = P_Rectangle_N + [dx dy dz];
        pause(1);
        % Termina el programa y cierra la conexión de MATLAB con V-Rep.
    end
    
    % Termina el programa y cierra la conexión de MATLAB con V-Rep.
    disp('Programa terminado')
    vrep.delete(); % llama el destructor!

end