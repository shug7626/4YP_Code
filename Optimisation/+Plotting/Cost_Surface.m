% Function to produce a plot of the cost per watt for various thicknesses

function [fig, cost] = Cost_Surface(PVKRange, SiRange, MPP, par)
    clf(figure(2));
    fig = figure(2);

    % Create the cost per area matrix
    cost = par.baselineCost + ... 
        ((par.PVKCost * PVKRange * 1e-6)' * (par.SiCost * SiRange * 1e3));

    % Create the cost per watt matrix
    cost = (cost ./ MPP) * 1e3;

    % Plot
    surf(PVKRange, SiRange*1e6, cost);

    % Labels
    title('Cost per Watt for the Range of Thicknesses');
    xlabel('PVK Thickness (nm)', 'Interpreter', 'latex');
    ylabel('Silicon Thickness ($\mu$m)', 'Interpreter', 'latex');
    zlabel('Cost per Watt ($\mathsterling$/W)', 'Interpreter', 'latex');
end