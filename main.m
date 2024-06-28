% Title: Code to get the fluid flow from a set of Regularized Stokeslets.
% Author: Stephen Williams.

%close all
%clear all %#ok<CLALL>

%% Add the function files need to run
addpath('functions/')
addpath('classes/')

%% Set parameters
parameters % Set the parameters

%% Set channel geometry
stks = getStokesletPositions(rho,geometry_type,system,U0);

%% Solve for the forces
[iS] = getForces3(stks,eps_reg);

%% Get the flow over the space
[Uflowx,Uflowy] = calculateFlowGrid_serial2(stks,iS,x,y,eps_reg);