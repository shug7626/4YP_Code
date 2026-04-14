% Function to plot the results

function plots = plot_res(res, spectrums, par, set)
    % Plot the J_V plots
    if set.plot_j_v
        plots(1) = Plotting.J_V(res, set);
    end
    
    % Plot the voltage area plot
    if set.plot_V_area
        plots(2) = Plotting.V_Area(res, set);
    end
    
    % Plot the voltage - volage plots
    if set.plot_v_v
        plots(3) = Plotting.V_VBias(res, set);
    end
    
    % Plot the P-V plot
    if set.plot_p_v
        plots(4) = Plotting.P_V(res, set);
    end
    
    % Plot the spectrum data
    if set.plot_spectrum
        plots(5) = Plotting.spectrum(spectrums, set, par, res);
    end

    % Plot the absorption diagram
    if set.plot_absorption
        plots(6) = Plotting.absorption(res, par, spectrums, set);
    end

    % Plot the PSC internal potential drops
    if set.plot_internal_PSC
        plots_temp = Plotting.V_PSC_internal(res, set);
        plots(7:8) = plots_temp;
    end
end