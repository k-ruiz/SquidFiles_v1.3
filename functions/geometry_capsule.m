% function to initialize the outer boundary / mantle
% walls A, B, C should have stks(:,3) = 8
% walls D, E should have stks(:,3) = 9

% walls A and C are symmetrical to each other, side walls
% walls D and E are symmetrical to each other, bottom walls
% wall B is the top wall

function [caps_stks] = geometry_capsule(rho2,Pty2,Ltot2,side2,bott2,top2)

    % construction of the top boundary
    phi = linspace(0,pi,floor(top2*rho2*pi)); % gets the angles to parameterise the surface of the top boundary

    wallB = [cos(phi);sin(phi);zeros(floor(top2*rho2*pi),1)']'; % gets the coordinates of the half-circle
    wallB = floor(top2)*wallB + [0,side2,0]; % shifts the half-circle to the top of the squid

    % construction of the bottom boundaries
    wallD = [linspace(bott2,top2-1,ceil(top2*rho2));ceil(Pty2-Ltot2)*ones(ceil(top2*rho2),1)';ones(ceil(top2*rho2),1)']';

    wallE = wallD;
    wallE(:,1) = -wallE(:,1); % reflect across the x axis
    %wallE = wallE(2:end-1,:); 

    % construction of the side boundaries 
    wallA = [floor(top2)*ones(ceil(2*side2*rho2),1)';linspace(Pty2-Ltot2,side2,ceil(2*side2*rho2));zeros(ceil(2*side2*rho2),1)']';

    wallC = wallA;
    wallC(:,1) = -wallC(:,1); % reflect accorss the x axis

    % combining all the arrays
    caps_stks = [wallA;wallB;wallC;wallD;wallE]; % combines all the boundaries

end
% i have a question... for god... why?

% this code has set me on an emotional journey of edurance

% everyday I question why this things doesn't work. then i realize that i am
% the problem
