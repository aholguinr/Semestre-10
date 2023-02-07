% University of Minnesota
% Aerospace Engineering and Mechanics
%
% This file collects all the README blocks and m-file help comments and 
% dumps them in a latex file.
%
%
% SVN Info: $Id$

fid = fopen('UAV_sim_file_info.tex','w');

fprintf(fid,'%s\n','\title{UAV Simulation File Information}');
fprintf(fid,'%s\n','\author{Austin Murch}');
fprintf(fid,'%s\n','\documentclass[12pt]{article}');
fprintf(fid,'%s\n','\usepackage{fullpage}');
fprintf(fid,'%s\n','\begin{document}');
fprintf(fid,'%s\n','\maketitle');
fprintf(fid,'%s\n\n','\tableofcontents');

fprintf(fid,'%s\n\n','\section{Introduction}');
fprintf(fid,'%s\n','This document is a collection of the embedded README blocks and m-file help comments for the UMN UAV simulation, developed by the UAV Research Group at the University of Minnesota. The UAV simulation model is written in the Matlab/Simulink environment using the Aerospace Blockset.  Three simulation environments are maintained: a basic nonlinear simulation, a Software-In-the-Loop simulation, and a Processor-In-the-Loop simulation. All three simulations share the same plant dynamics, actuator, sensor, and environmental models via Simulink Libraries. Aircraft and environmental parameters are set in m-files and shared between the simulations. Two aircraft models are maintained, one for the Ultra Stick 25e and one for the FASER aircraft.');
fprintf(fid,'%s\n\n','\subsection{MATLAB Version}');
fprintf(fid,'%s\n','The UMN UAV simulation was developed with 32-bit MATLAB R2010a. Users have reported successfully using R2009b; however, R2010a or later is recommended. R2009a is known to fail with the SIL simulation.');


addpath ..\Libraries

%% Nonlinear Simulation
fprintf(fid,'%s\n','\section{Nonlinear Simulation: UAV\_NL}');


% m files
fprintf(fid,'%s\n','\subsection{M-Files}');
files = dir('..\NL_Sim\*.m');
addpath ..\NL_sim
for i = 1:length(files)
    fprintf(fid,'%s%s%s\n','\subsubsection{',strrep(files(i).name,'_','\_'),'}');
    fprintf(fid,'%s\n','\begin{verbatim}');
    fprintf(fid,'%s\n\n',help(files(i).name));
    fprintf(fid,'%s\n\n','\end{verbatim}');
end
rmpath ..\NL_sim


% Simulink models
fprintf(fid,'%s\n','\subsection{Simulink Blocks}');

% check if model is loaded
if ~bdIsLoaded('UAV_NL')
    load_system('..\NL_Sim\UAV_NL')
end

% Find README blocks, look under masks and follow library links.
r_blks = find_system('UAV_NL','LookUnderMasks','all','FollowLinks','on','Name','README'); % look into the libraries here

% Sort by length of parent name, so we can
for i=1:length(r_blks)
    % Pull out text data
    j(i) = length(get_param(r_blks{i},'Parent'));
end
[~,ind] = sort(j);

for i=1:length(r_blks)
    % Pull out text data and clean up latex unfriendly text
    udata = get_param(r_blks{ind(i)},'UserData');
    udata = udata.content;
%     udata = strrep(udata,'_','\_');
%     udata = strrep(udata,'^','\^');
    % Pull out block path and clean up latex unfriendly text
    blkpath = r_blks{ind(i)};
    blkpath = strrep(blkpath,'/README','');
    blkpath = strrep(blkpath,'_','\_');
    
    %print to file
    fprintf(fid,'%s%s%s\n','\subsubsection{',blkpath,'}');
    fprintf(fid,'%s\n','\begin{verbatim}');
    fprintf(fid,'%s\n\n',udata);
    fprintf(fid,'%s\n\n','\end{verbatim}');
end

%% SIL Simulation
fprintf(fid,'%s\n','\section{SIL Simulation: UAV\_SIL}');

fprintf(fid,'%s\n','\subsection{M-Files}');
% m files
files = dir('..\SIL_Sim\*.m');
addpath ..\SIL_sim
for i = 1:length(files)
    fprintf(fid,'%s%s%s\n','\subsubsection{',strrep(files(i).name,'_','\_'),'}');
    fprintf(fid,'%s\n','\begin{verbatim}');
    fprintf(fid,'%s\n\n',help(files(i).name));
    fprintf(fid,'%s\n\n','\end{verbatim}');
end
rmpath ..\SIL_sim

% Simulink models
fprintf(fid,'%s\n','\subsection{Simulink Blocks}');

% check if model is loaded
if ~bdIsLoaded('UAV_SIL')
    load_system('..\SIL_Sim\UAV_SIL')
end

%find README blocks
r_blks = find_system('UAV_SIL','Name','README');

% Sort by length of parent name
j = [];
for i=1:length(r_blks)
    % Pull out text data
    j(i) = length(get_param(r_blks{i},'Parent'));
end
[~,ind] = sort(j);

for i=1:length(r_blks)
    % Pull out text data and clean up latex unfriendly text
    udata = get_param(r_blks{ind(i)},'UserData');
    udata = udata.content;
%     udata = strrep(udata,'_','\_');
%     udata = strrep(udata,'^','\^');
    % Pull out block path and clean up latex unfriendly text
    blkpath = r_blks{ind(i)};
    blkpath = strrep(blkpath,'/README','');
    blkpath = strrep(blkpath,'_','\_');
    
    %print to file
    fprintf(fid,'%s%s%s\n','\subsubsection{',blkpath,'}');
    fprintf(fid,'%s\n','\begin{verbatim}');
    fprintf(fid,'%s\n\n',udata);
    fprintf(fid,'%s\n\n','\end{verbatim}');
end

%% PIL Simulation
fprintf(fid,'%s\n','\section{PIL Simulation: UAV\_PIL}');


% m files
fprintf(fid,'%s\n','\subsection{M-Files}');
files = dir('..\PIL_Sim\*.m');
addpath ..\PIL_sim
for i = 1:length(files)
    fprintf(fid,'%s%s%s\n','\subsubsection{',strrep(files(i).name,'_','\_'),'}');
    fprintf(fid,'%s\n','\begin{verbatim}');
    fprintf(fid,'%s\n\n',help(files(i).name));
    fprintf(fid,'%s\n\n','\end{verbatim}');
end
rmpath ..\PIL_sim

% Simulink models
fprintf(fid,'%s\n','\subsection{Simulink Blocks}');

% check if model is loaded
if ~bdIsLoaded('UAV_PIL')
    load_system('..\PIL_Sim\UAV_PIL')
end

%find README blocks
r_blks = find_system('UAV_PIL','Name','README');

% Sort by length of parent name, so the order is logical
j = [];
for i=1:length(r_blks)
    % Pull out text data
    j(i) = length(get_param(r_blks{i},'Parent'));
end
[~,ind] = sort(j);

for i=1:length(r_blks)
    % Pull out text data and clean up latex unfriendly text
    udata = get_param(r_blks{ind(i)},'UserData');
    udata = udata.content;
%     udata = strrep(udata,'_','\_');
%     udata = strrep(udata,'^','\^');
    % Pull out block path and clean up latex unfriendly text
    blkpath = r_blks{ind(i)};
    blkpath = strrep(blkpath,'/README','');
    blkpath = strrep(blkpath,'_','\_');
    
    %print to file
    fprintf(fid,'%s%s%s\n','\subsubsection{',blkpath,'}');
    fprintf(fid,'%s\n\n','\begin{verbatim}');
    fprintf(fid,'%s\n\n',udata);
    fprintf(fid,'%s\n\n','\end{verbatim}');
end

%% Common m-files
fprintf(fid,'%s\n','\section{Common M-Files}');
files = dir('..\Libraries\*.m');
for i = 1:length(files)
    fprintf(fid,'%s%s%s\n','\subsection{',strrep(files(i).name,'_','\_'),'}');
    fprintf(fid,'%s\n','\begin{verbatim}');
    fprintf(fid,'%s\n\n',help(files(i).name));
    fprintf(fid,'%s\n\n','\end{verbatim}');
end

%% End document
fprintf(fid,'%s','\end{document}');

fclose(fid);

