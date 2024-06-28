function [] = plot_flow(stks,Uflowx,Uflowy,x,y,n)
    Umag = sqrt(Uflowx.^2 + Uflowy.^2); % Get flow field magnitude
    imagesc(x,y,(Umag)) % Plot local flow strenght as a background
    hold on
    scatter(stks(:,2),stks(:,1),2,'r') % Plot the Stokeslets
    quiver(x(1:n:end),y(1:n:end),Uflowy(1:n:end,1:n:end),Uflowx(1:n:end,1:n:end),2,'Color','y') % Plot the vector field
    axis equal

end

