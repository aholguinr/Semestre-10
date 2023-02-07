%% save_pil_data.m
%  UAV Processor-in-the-Loop save_pil_data script
%
% This script saves the results to a file with the
% name specified in variable savename. 
%
% University of Minnesota 
% Aerospace Engineering and Mechanics 
% Copyright 2011 Regents of the University of Minnesota. 
% All rights reserved.
%
% SVN Info: $Id$

savename = 'pilSimData'; % file name for sim data

% Save the simulation data in the simData data structure.
pilSimData.time= dataSimPil(:,1);
pilSimData.phi=dataSimPil(:,4);
pilSimData.theta = dataSimPil(:,5);
pilSimData.psi = dataSimPil(:,6); 
pilSimData.p=dataSimPil(:,13);
pilSimData.q=dataSimPil(:,14); % Pitch rate
pilSimData.r=dataSimPil(:,15) ;
pilSimData.V_s= dataSimPil(:,25); 
pilSimData.alpha = dataSimPil(:,26);
pilSimData.beta = dataSimPil(:,27);
pilSimData.alt = dataSimPil(:,28); 
pilSimData.throttle= dataSimPil(:,29);
pilSimData.elevator= dataSimPil(:,30);
pilSimData.rudder=dataSimPil(:,31);
pilSimData.l_aileron= dataSimPil(:,32);
pilSimData.r_aileron= dataSimPil(:,33);
pilSimData.l_flap= dataSimPil(:,34);
% pilSimData.r_flap= dataSimPil(:,35);

% save data
save(savename,'pilSimData');