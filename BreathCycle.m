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

N = 4;
U0 = 100/45;
omega = 2*pi/N;

for ii = 1:N

    a = find(stks(:,3) == 2); % Find the Pousielle boundary sections
    Ut = -U0*(1+cos(ii*omega)); % Set the maximum flow rate in
    stks(a,4:5) = poisuelleFlow(length(a),Ut); % Re-set the Pousielle boundary sections

    [Uflowx,Uflowy,Uback,omega1] = calculateFlowGrid_serial2(stks,iS,x,y,eps_reg);

    hold off;
    Umag = sqrt(Uflowx.^2 + Uflowy.^2);
    imagesc(y,x,Umag); hold on
    c=colorbar;
    c.Limits=[0 10]; % the range that I want
    scatter(stks(:,2),stks(:,1),0.5,'r');
    a = find(stks(:,3) == 2);
    quiver(stks(a(1:4:end),2),stks(a(1:4:end),1),stks(a(1:4:end),5),stks(a(1:4:end),4),'off','k')
    axis equal
    saveas(gcf,['outputs/breathCycle/breathCycle_' num2str(ii) '.png'])
    save(['outputs/breathCycle/breathCycle_Uback_omega_' num2str(ii)],'Uback','omega1');
    pause(0.5);
end

%% Make the png into an mp4 file

video = false;

if video == true

    v = VideoWriter('breathCycle');
    v.Quality = 100;

    open(v);

    for ii = 1:100

        img = imread(['outputs/breathCycle/breathCycle_' num2str(ii) '.png']);
        writeVideo(v,img)

    end

    close(v);

end

%% Uback & omega

Ubackx = zeros(100,1);
Ubacky = zeros(100,1);
omegas = zeros(100,1);

for i = 1:100

    load(['outputs/breathCycle/breathCycle_Uback_omega_' num2str(i) '.mat'])

    Ubackx(i) = Uback(1);
    Ubacky(i) = Uback(2);
    omegas(i) = omega;

end

plot(linspace(0,2*pi,100),Ubackx,'LineWidth',5); hold on
plot(linspace(0,2*pi,100),Ubacky,'LineWidth',5);
%plot(linspace(0,2*pi,100),omegas,'LineWidth',5);