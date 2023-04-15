%% COPSIM3 programa modificar la posición de un objeto en CoppeliaSim
% Establecer la conexión
function simpleTest5()
    disp('Program started');
    vrep=remApi('remoteApi'); % usar el archivo prototipo(remoteApiProto.m)
    vrep.simxFinish(-1); % si se requiere, cerrar todas las conexiones abiertas.
    % asigna el handle de identificación de cliente clientID
    clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
    if (clientID>-1)
     disp('Conexión exitosa')
    end
    %Algoritmo
    % Consulta el handle del objeto Caja1 en la escena Esc01 y lo asigna al handle caja_m.
    [returnCode,caja_m]=vrep.simxGetObjectHandle(clientID,'Cuboid',vrep.simx_opmode_blocking);
    [returnCode,Or]=vrep.simxGetObjectOrientation(clientID,caja_m,-1,vrep.simx_opmode_blocking);
    % presenta la orientacion de la caja
    disp(Or)
    %Calcula una posición deseada Pd como un desplazamiento respecto a Or
    
    dx=0; dy=0; dz=0.2;
    OrD = Or + [dx dy dz];
    for i=1:10
        disp(OrD) 
        % Asigna la posición Pd a la caja
        [returnCode]=vrep.simxSetObjectOrientation(clientID,caja_m,-1,OrD,vrep.simx_opmode_blocking);
        OrD = OrD + [dx dy dz];
        % Termina el programa y cierra la conexión de MATLAB con V-Rep.
    end
    
    disp('Programa terminado')
    vrep.delete(); % llama el destructor!
end
