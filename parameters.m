% Parameters needed to run the 2D flow code

% Parameters:

% Parameter handling
parallel = true;

rho = 5.0;
eps_reg = 0.5/rho; % Regularisaton parameter.

% Geometry type
geometry_type = 2;
system = geometry;

switch geometry_type

    case 1 % Free space

        % Channel geometry
        system.channel_parameters = [];

        % Appendage geometry
        system.appendage_parameters(1) = 2; % Appendage separation.
        system.appendage_parameters(2) = 0; % Placeholder
        system.appendage_parameters(3) = 5; % Placeholder, defines solver grid

    case 2 % Confining funnel

        NDL = 45; % Non-dimensional length scale

        % Channel geometry
        system.channel_parameters(1) = (367+500)/NDL; % Length of top segment.
        system.channel_parameters(2) = 366/NDL; % Length of transition region.
        system.channel_parameters(3) = 200/NDL; % Length of bottom segment.
        system.channel_parameters(4) = (pi/2)-0.61; % Angle of right transition region to horizontal.
        system.channel_parameters(5) = system.channel_parameters(1)+cos(system.channel_parameters(4))*system.channel_parameters(2)+system.channel_parameters(3); % Total height of system simulated.
        system.channel_parameters(6) = 500/NDL; % Position x of top point of right boundary.
        system.channel_parameters(7) = system.channel_parameters(1)+system.channel_parameters(2)/2; % Position y of top point of right boundary.

        % Appendage geometry
        system.appendage_parameters(1) = 0.95*90/NDL; % Appendage separation.
        system.appendage_parameters(2) = 0.82-pi/2; % Angle of inclination between appendage pairs (Rad).
        system.appendage_parameters(3) = 125/45; % Position of right appendage in x.
        system.appendage_parameters(4) = 11; % Position of right appendage in y.

        % Capsule geometry
        system.capsule_parameters(1) = 1120/NDL; % Radius of the posterier 
        system.capsule_parameters(2) = system.channel_parameters(7); % Lengths of the side walls
        system.capsule_parameters(3) = system.channel_parameters(6)-system.channel_parameters(2)*sin(system.channel_parameters(4)); % Length of the inlet

end

% Flow parameters
U0 = 100/NDL; % Background flow strength Max.

% Underlying space parameters.
nptx = 200; % Solver points in x direction.
npty = nptx; % Solver points in y direction.
Ptx = system.channel_parameters(6);
Pty = system.channel_parameters(7);
x = linspace(-Ptx-15,Ptx+15,nptx); % Solver x coords.
y = linspace(Pty-system.channel_parameters(5)-5,system.capsule_parameters(2)+system.capsule_parameters(1)+5,npty); % Solver y coords.
