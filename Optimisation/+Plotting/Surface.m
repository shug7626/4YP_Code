% Funtion to create a surface plot of the MPP for the range of input
% thicknesses

function fig = Surface(PVKRange, SiliconRange, MPP)
    fig = figure(1);

    surf(PVKRange, SiliconRange, MPP);
end