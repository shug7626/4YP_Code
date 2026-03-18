% Plots the spectrum and the proportion of absorbed photons in each layer

function [fig, s] = spectrum(s, p, set)
    fig = figure(5);
    
    % Use a plotting factor to add some extra wavelengths to the end of the
    % plot
    plot_factor = 1.2;
    
    % Use the lower bandgap energy
    min_energy = min([(p.Ec - p.Ev), p.Eg2]) / plot_factor;
    
    % to find the largest wavelength to plot (convert from m to nm)
    max_wavelength = p.h * p.c * 1e9 / min_energy;
    
    % Find where the max wavelength occurs in wavelengths
    index = find(s.wavelengths < max_wavelength, 1, 'last');
    
    % Calculate the spectrum which excited electrons in cell 1
    s.cell1 = p.etac1 .* (ones(size(p.R1)) - p.R1) .* (ones(size(p.R1)) - exp(-p.a1 * p.thick1)) .* (s.bs .* p.validE1);
    
    % Calculate for cell 2
    s.cell2 = p.etac2 .* (ones(size(p.R2)) - exp(-p.a2 * p.thick2)) .* (s.bs2 .* p.validE2);
    
    % Plot up to that index
    plot(s.wavelengths(1:index), s.bs(1:index), 'DisplayName', 'Photon Spectrum');
    hold on
    if set.individual_spectrums
        plot(s.wavelengths(1:index), s.cell1(1:index), 'DisplayName', 'Cell 1 Electron Collection');
        plot(s.wavelengths(1:index), s.cell2(1:index), 'DisplayName', 'Cell 2 Electron Collection');
    end
    if set.total_spectrum
        plot(s.wavelengths(1:index), (s.cell1(1:index) + s.cell2(1:index)), 'DisplayName', 'Total Electron Collection');
    end
    xlabel('Wavelength (nm)');
    ylabel('Number of Photons / Electrons (cm-2)');
    title('Incident Photon Spectrum and Electron Collection Spectrums');
    legend();
    hold off
end