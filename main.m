% Title: Code to get the fluid flow from a set of Regularized Stokeslets.
% Author: Stephen Williams.

clc
close
tic

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

%% Plots output the flowfield
n=5; % Plot coarseness
Umag = sqrt(Uflowx.^2 + Uflowy.^2); % Get flow field magnitude
imagesc(y,x,Umag) % Plot local flow strenght as a background
hold on
scatter(stks(:,2),stks(:,1),2,'r') % Plot the Stokeslets
quiver(y(1:n:end),x(1:n:end),Uflowy(1:n:end,1:n:end),Uflowx(1:n:end,1:n:end),2,'Color','w') % Plot the vector field
axis equal

toc