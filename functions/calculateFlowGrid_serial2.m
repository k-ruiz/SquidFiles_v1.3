%% Function to calculate the flow profile
% generated by some collection of Stokeslets over some pre-defined grid

function [Uflowx,Uflowy, Uback, torque] = calculateFlowGrid_serial2(stks1,iS,x1,y1,eps1)

    % Calculate the forces, drift, and torque

    Ubdry = zeros(2*length(stks1(:,1)),1);
    Ubdry(1:2:end) = stks1(:,4);
    Ubdry(2:2:end) = stks1(:,5);
    Ubdry = [Ubdry;0;0;0];
    Fvert = iS*Ubdry;
    F = zeros(length(stks1(:,1)),2);
    F(:,1) = Fvert(1:2:end-3);
    F(:,2) = Fvert(2:2:end-3);
    Uback = Fvert(end-2:end-1);
    torque = Fvert(end);

    % Preallocate the arrays for magnitudes of flow in each component
    Uflowx = zeros(length(x1),length(y1)); % X-component of the flow
    Uflowy = zeros(length(x1),length(y1)); % Y-component of the flow
    [nStok,~] = size(stks1); % Total number of Stokeslets 

    % Scan through the whole grid 
    for xposition = 1:length(x1)
        for yposition = 1:length(y1)

            Stemp = zeros(2,2); % Store for the Stokeslet between the current point of consideration [xposition,yposition] and the collection of Stokeslets

            p = [x1(xposition),y1(yposition)]'; % Get the coordinates of position of consideration

            % Loop through the Stokeslets that can generate a flow at the position being considered
            for n = 1:nStok

                pN = stks1(n,1:2)'; % Get the position of stokeslet N.
                Ftemp = F(n,:)'; % Get the forces of stokeslet N.
                r = sqrt(norm(p - pN).^2 + eps1^2) + eps1; % Distance, considered to stokeslet N.
                rho = (r+eps1)/(r*(r-eps1)); % Rho, considered to stokeslet N.

                % Construct the Stokeslet contribution for this comparison
                for k = 1:2
                    for l = 1:2
                        Stemp(k,l) = -(log(r)-eps1*rho)*(k==l) + (p(k)-stks1(n,k))*(p(l)-stks1(n,l))*rho/r;
                    end
                end

                % Get the flow due to Stokeslet n and add it to the overall flow calculated
                U = Stemp*Ftemp;
                Uflowx(xposition,yposition) = Uflowx(xposition,yposition) + U(1) - torque*p(2);
                Uflowy(xposition,yposition) = Uflowy(xposition,yposition) + U(2) + torque*p(1);

            end

        end
    end

    Uflowx = Uflowx + Uback(1);
    Uflowy = Uflowy + Uback(2);

end

