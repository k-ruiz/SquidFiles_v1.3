% Function to solve the inverse problem to get the stokeslet forces.

function [F,U] = getForces(stks1,eps1)

    %% Create the linear system to solve, part 1.
    % Put the velocity boundary conditions in vertical form.

    nStok = length(stks1(:,1));
    BdryVertical = zeros(nStok*2,1);
    BdryVertical(1:2:end) = stks1(:,4); BdryVertical(2:2:end) = stks1(:,5);
    % quiver(stks1(:,1),stks1(:,2),BdryVertical(1:2:end),BdryVertical(2:2:end)); % Optional: View the constructed flow profile

    %% Create the linear system to solve, part 2.
    % Create a matrix corresponding to the stokeslet for the full system.

    S = zeros(2*nStok); % Preallocate the full linear stokeslet.

    % Find the forces.
    for l = 1:2*nStok % Loop through the stokeslet-components
        for k = 1:2*nStok % Loop through the stokeslet-components
            %
            n1 = ceil(k/2); % Get the stokelets number of the influence stokeslet.
            n2 = ceil(l/2); % Get the stokelets number of the influenced stokeslet.
            %
            tempStks1 = stks1(n1,1:2); % Get the position of the influence stokeslet.
            tempStks2 = stks1(n2,1:2); % Get the position of the influenced stokeslet.
            %
            r = sqrt(norm(tempStks1-tempStks2)^2 + eps1^2) + eps1; % Get the reg `distance' between them.
            rho = (r+eps1)/(r*(r-eps1)); % Get the "rho", for convenience.
            %
            S(l,k) = -(log(r)-eps1*rho)*(mod(k,2)==mod(l,2)) ... % Get the log term contribution.
                     +(tempStks1(2-mod(k,2))-tempStks2(2-mod(k,2)))*(tempStks1(2-mod(l,2))-tempStks2(2-mod(l,2)))*rho/r; % Get the <....> contribution.
        end
    end

    %% Create the linear system to solve, part 2.

    IN2 = zeros(2*nStok,2);
    IN2(1:2:end,1) = 1;
    IN2(2:2:end,2) = 1;
    S = [S,IN2];
    I2N = [IN2',zeros(2,2)];
    S = [S;I2N];

    %% Create the linear system to solve, part 3.
    % Solve for the forces required to satisfy the system.

    % Calculate the forces and then put them into vector format for output.
    % ForceVertical = zeros(2*nStok,1);
    %tol = 1e-4;
    %maxit = 100;
    %[ForceVertical,~] = gmres(S,BdryVertical,[],tol,maxit); % Inv here is inefficient, but seems to work well. It is likely poorly conditioned for very large numbers of Stokelets.
    ForceVertical = S\[BdryVertical;0;0]; % Backslash method, potential source of error.
    F = zeros(nStok,2);
    F(:,1) = ForceVertical(1:2:end-2);
    F(:,2) = ForceVertical(2:2:end-2);

    U = zeros(2,1);
    U(1) = ForceVertical(end-1);
    U(2) = ForceVertical(end);
    
    % Visualise the forces calculated. May need to remove large values to aid the viewing.
    %quiver(stks1(:,1),stks1(:,2),F(:,1),F(:,2))

end

