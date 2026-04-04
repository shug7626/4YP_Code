% Plot of the photon flux spectrum and corresponding electrons released

function fig = spectrum(s, setting, par, res)
    % Clear data from the figure if already open
    clf(figure(5));

    % Set the axes numbers font sizes
    set(groot, 'defaultAxesFontSize', setting.axes_numbers);

    % Plot in figure 5
    fig = figure(5);

    % Use a plotting factor to add some extra wavelengths to the end of the
    % plot
    plot_factor = 1.2;
    
    % Use the lower bandgap energy
    min_energy = min([(par.Ec - par.Ev), par.Eg2]) / plot_factor;
    
    % to find the largest wavelength to plot (convert from m to nm)
    max_wavelength = par.h * par.c * 1e9 / min_energy;
    
    % Find where the max wavelength occurs in wavelengths
    index = find(s.wavelengths < max_wavelength, 1, 'last');
    
    % Calculate the spectrum which excited electrons in cell 1
    s.cell1 = (1 - res.R1) .* res.a1 .* s.bs .* s.validE1;
    
    % Calculate for cell 2
    s.cell2 = (res.int_res_p + res.int_res_d + res.int_res_n) ...
        .* s.Si(:,2) .* res.bs2 .* s.validE2;
    
    % Plot up to that index
    plot(s.wavelengths(1:index), s.bs(1:index), ...
        'DisplayName', 'Photon Spectrum', ...
        'LineWidth', setting.small_line_width);
    hold on
    if setting.individual_spectrums
        plot(s.wavelengths(1:index), s.cell1(1:index), ...
            'DisplayName', 'Cell 1 Electron Collection', ...
            'LineWidth', setting.small_line_width);
        plot(s.wavelengths(1:index), s.cell2(1:index), ...
            'DisplayName', 'Cell 2 Electron Collection', ...
            'LineWidth', setting.small_line_width);
    end
    if setting.total_spectrum
        plot(s.wavelengths(1:index), (s.cell1(1:index) + s.cell2(1:index)), ...
            'DisplayName', 'Total Electron Collection', ...
            'LineWidth', setting.small_line_width);
    end
    
    % Title and labels
    title('Incident Photon Spectrum and Electron Collection Spectrums', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.title_font);
    xlabel('Wavelength $\left(\mathrm{nm}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    ylabel('Number of Photons / Electrons $\left(\mathrm{cm}^{-2}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);

    % Add a legend
    legend();
    hold off
end