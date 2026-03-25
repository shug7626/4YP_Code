% Funtion to create a surface plot of the MPP for the range of input
% thicknesses

function fig = Surface(PVKRange, SiliconRange, MPP)
    fig = figure(1);

    % Change the silicon thickness units to be in micometers
    SiliconRange = SiliconRange * 1e6;
    
    % Plot
    surf(PVKRange, SiliconRange, MPP);

    % Label
    title('Plot of the Maximum Power Point (MPP) for the Range of Thicknesses');
    xlabel('PVK Thickness (nm)');
    ylabel('Silicon Thickness ($\mu$m)', 'Interpreter', 'latex');
    zlabel('MPP (mW)');
end