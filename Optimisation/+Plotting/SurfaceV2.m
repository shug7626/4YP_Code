% Function to produce a surface plot of the MPPs from optimisationV2_main

function fig = SurfaceV2(PVKRange, SiRange, MPP, par)
    clf(figure(1));
    fig = figure(1);

    % Change the silicon thickness units
    SiRange = SiRange * 1e6;

    % Create a temporary MPP matrix for reshaping
    MPPsize1 = size(PVKRange(1, :));
    MPPsize = zeros(MPPsize1(2));

    % Plot using a For loop
    for iter = 1:par.N
        % Reshape MPP into the size of MPPtemp
        MPPtemp = reshape(MPP(iter, :), size(MPPsize));

        % Plot the surface
        surf(PVKRange(iter, :), SiRange(iter, :), MPPtemp);
        hold on;
    end

    % Label
    title('Maximum Power Point (MPP) for the Range of Thicknesses');
    xlabel('PVK Thickness (nm)', 'Interpreter', 'latex');
    ylabel('Silicon Thickness ($\mu$m)', 'Interpreter', 'latex');
    zlabel('MPP (mW)', 'Interpreter', 'latex');
end