% Funtion to create a surface plot of the MPP for the range of input
% thicknesses

function fig = Surface(PVKRange, SiliconRange, MPP)
    fig = figure(1);

    surf(PVKRange, SiliconRange, MPP);
    title('Plot of the Maximum Power Point (MPP) for the Range of Thicknesses');
    xlabel('PVK Thickness (nm)');
    ylabel('Silicon Thickness (m)');
    zlabel('MPP (mW)');
end