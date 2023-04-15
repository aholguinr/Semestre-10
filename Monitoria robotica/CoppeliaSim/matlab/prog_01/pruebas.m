function pruebas()
vrep=remApi('remoteApi'); % usar el archivo prototipo (remoteApiProto.m)
    vrep.simxFinish(-1); % si se requiere, cerrar todas las conexiones abiertas.
    % asigna el handle de identificación de cliente clientID
    clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
    if (clientID>-1)
     disp('Conexión exitosa')
    end
    %Algoritmo
    
    [returnCode,H_Cuboid]=vrep.simxGetObjectHandle(clientID,'Cuboid',vrep.simx_opmode_blocking);
    [returnCode,H_Cylinder]=vrep.simxGetObjectHandle(clientID,'Cylinder',vrep.simx_opmode_blocking);
    [returnCode,H_MTB]=vrep.simxGetObjectHandle(clientID,'MTB',vrep.simx_opmode_blocking);
    [returnCode,H_Rectangle]=vrep.simxGetObjectHandle(clientID,'Rectangle',vrep.simx_opmode_blocking);
    
    
    
    [returnCode,P_Cuboid]= vrep.simxGetObjectPosition(clientID, H_Cuboid,-1,vrep.simx_opmode_blocking);
    [returnCode,P_Cylinder]= vrep.simxGetObjectPosition(clientID, H_Cylinder,-1,vrep.simx_opmode_blocking);
    [returnCode,P_MTB]= vrep.simxGetObjectPosition(clientID, H_MTB,-1,vrep.simx_opmode_blocking);
    [returnCode,P_Rectangle]= vrep.simxGetObjectPosition(clientID, H_Rectangle,-1,vrep.simx_opmode_blocking);
    
    [returnCode,VL_Rectangle,VA_Rectangle]= vrep.simxGetObjectVelocity(clientID, H_Rectangle,vrep.simx_opmode_blocking);
    
    disp('pos cubo')
    disp(P_Cuboid)
    
    disp('pos sphere')
    disp(P_Cylinder)
    
    disp('pos mtb')
    disp(P_MTB)
    
    disp('pos rec')
    disp(P_Rectangle)
    
    disp('vel rec')
    disp(VL_Rectangle)
    disp(VA_Rectangle)
    
    %[returnCode,Or]=vrep.simxGetObjectOrientation(clientID,H_Cuboid,-1,vrep.simx_opmode_blocking);
    %disp(Or)
    %disp('ori')
    
    %dx=0.1; dy=0.1; dz=0;
    %P_Rectangle_N = P_Rectangle + [dx dy dz];
   
     for i=1:20
        [returnCode,P_Rectangle]= vrep.simxGetObjectPosition(clientID, H_Rectangle,-1,vrep.simx_opmode_blocking);
        [returnCode,VL_Rectangle,VA_Rectangle]= vrep.simxGetObjectVelocity(clientID, H_Rectangle,vrep.simx_opmode_blocking);
        
        
        
        disp(i)
        disp('posición')
        disp(P_Rectangle)
        disp('Velocidad linear')
        disp(VL_Rectangle)
        disp('Velocidad angular')
        disp(VA_Rectangle)
        % Asigna la posición Pd a la caja
        %[returnCode]=vrep.simxSetObjectPosition(clientID,H_Rectangle,-1,P_Rectangle_N,vrep.simx_opmode_blocking);
        %P_Rectangle_N = P_Rectangle_N + [dx dy dz];
        pause(0.5);
        % Termina el programa y cierra la conexión de MATLAB con V-Rep.
    end
    
    % Termina el programa y cierra la conexión de MATLAB con V-Rep.
    disp('Programa terminado')
    vrep.delete(); % llama el destructor!

end