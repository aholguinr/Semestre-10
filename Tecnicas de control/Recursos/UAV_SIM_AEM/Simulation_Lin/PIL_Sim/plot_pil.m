function plot_pil(varargin)
%% plot_pil.m
% UAV_PIL sim plot
%
% Input file names of saved simulation results (pilSimData structure) and this
% function will co-plot the results. If no file name is input, the file
% "pilSimData.mat" will be used.
%
% University of Minnesota
% Aerospace Engineering and Mechanics
% Copyright 2011 Regents of the University of Minnesota.
% All rights reserved.
%
% SVN Info: $Id$

close all

% default case
if nargin < 1
    varargin = {'pilSimData'};
end

% Check if input names are saved files
for i = 1:length(varargin)
    if ~exist([varargin{i} '.mat'],'file')
        error('File name %s not found!',[varargin{i} '.mat'])
    end
end

% Setup color order
clr = get(0,'DefaultAxesColorOrder');
clr = clr(1:length(varargin),:); % only keep as many colors as file names

% turn off nuiusance warnings
warning('off','MATLAB:legend:IgnoringExtraEntries')

% Loop over 
for i = 1:length(varargin)
    load(varargin{i}) % Load in sim data
    if ~exist('pilSimData','var')
        warning('pilSimData data structure not found in file %s.',varargin{i})
        continue
    end
    % Plot Elevator response
    figure(1), hold on, grid on
    plot(pilSimData.time, pilSimData.elevator, 'Color',clr(i,:), 'LineWidth',2);
    title('PIL SIM Elevator Deflection')
    xlabel('time [s]'), ylabel('\delta_{elev} [deg]')
    legend(varargin)
    
    % Plot Aileron response
    figure(2), hold on, grid on
    plot(pilSimData.time, pilSimData.r_aileron, 'Color',clr(i,:), 'LineWidth',2);
    title('PIL SIM Aileron Deflection')
    xlabel('time [s]'), ylabel('\delta_{ail} [deg]')
    legend(varargin)
    
    % Plot Rudder response
    figure(3), hold on, grid on
    plot(pilSimData.time, pilSimData.rudder, 'Color',clr(i,:), 'LineWidth',2);
    title('PIL SIM Rudder Deflection')
    xlabel('time [s]'), ylabel('\delta_{rud} [deg]')
    legend(varargin)
    
    % Plot Flap response
    figure(4), hold on, grid on
    plot(pilSimData.time, pilSimData.r_flap, 'Color',clr(i,:), 'LineWidth',2);
    title('PIL SIM Flap Deflection')
    xlabel('time [s]'), ylabel('\delta_{flap} [deg]')
    legend(varargin)
    
    % Plot V_s response
    figure(5), hold on, grid on
    plot(pilSimData.time,pilSimData.V_s , 'Color',clr(i,:), 'LineWidth', 2);
    title('PIL SIM V_s Response')
    xlabel('time [s]'), ylabel('V_s [m/s]')
    legend(varargin)
    
    % Plot Angle of Attack response
    figure(6), hold on, grid on
    plot(pilSimData.time, pilSimData.alpha, 'Color',clr(i,:), 'LineWidth', 2);
    title('PIL SIM Angle of Attack Response')
    xlabel('time [s]'), ylabel('\alpha [deg]')
    legend(varargin)
    
    % Plot Sideslip response
    figure(7), hold on, grid on
    plot(pilSimData.time,pilSimData.beta, 'Color',clr(i,:), 'LineWidth', 2);
    title('PIL SIM Sideslip Response')
    xlabel('time [s]'), ylabel('\beta [deg]')
    legend(varargin)
    
    % Plot Bank Angle response
    figure, hold on, grid on
    plot(pilSimData.time, pilSimData.phi, 'Color',clr(i,:), 'LineWidth', 2);
    title('PIL SIM Bank Angle Response')
    xlabel('time [s]'), ylabel('\phi [deg]')
    legend(varargin)
    
    % Plot Pitch Angle response
    figure, hold on, grid on
    plot(pilSimData.time, pilSimData.theta, 'Color',clr(i,:), 'LineWidth', 2);
    title('PIL SIM Pitch Angle Response')
    xlabel('time [s]'), ylabel('\theta [deg]')
    legend(varargin)
    
    % Plot Yaw Angle response
    figure(10), hold on, grid on
    plot(pilSimData.time, pilSimData.psi, 'Color',clr(i,:), 'LineWidth', 2);
    title('PIL SIM Heading Angle Response')
    xlabel('time [s]'), ylabel('\psi [deg]')
    legend(varargin)
    
    % Plot altitude response
    figure(11), hold on, grid on
    plot(pilSimData.time, pilSimData.alt, 'Color',clr(i,:), 'LineWidth', 2);
    title('PIL SIM altitude (above Ground Level) Response')
    xlabel('time [s]'), ylabel('alt [m]')
    legend(varargin)
    
    % Plot roll rate response
    figure(12), hold on, grid on
    plot(pilSimData.time, pilSimData.p, 'Color',clr(i,:), 'LineWidth', 2);
    title('PIL SIM Roll Rate Response')
    xlabel('time [s]'), ylabel('p [deg/s]')
    legend(varargin)
    
    % Plot pitch rate response
    figure(13), hold on, grid on
    plot(pilSimData.time, pilSimData.q, 'Color',clr(i,:), 'LineWidth', 2);
    title('PIL SIM Pitch Rate Response')
    xlabel('time [s]'), ylabel('q [deg/s]')
    legend(varargin)
    
    % Plot yaw rate response
    figure(14), hold on, grid on
    plot(pilSimData.time, pilSimData.r, 'Color',clr(i,:), 'LineWidth', 2);
    title('PIL SIM Yaw Rate Response')
    xlabel('time [s]'), ylabel('r [deg/s]')
    legend(varargin)  
    clear simData
end

% Turn warning back on
warning('on','MATLAB:legend:IgnoringExtraEntries')
