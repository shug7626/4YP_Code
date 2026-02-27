% Plots the spectrum and the proportion of absorbed photons in each layer

function fig = spectrum(s, p)
    fig = figure(5);
    
    % Use a plotting factor to add some extra wavelengths to the end of the
    % plot
    plot_factor = 1.1;
    
    % Use the lower bandgap energy
    min_energy = min([p.Eg1, p.Eg2]) / plot_factor;
    
    % to find the largest wavelength to plot (convert from m to nm)
    max_wavelength = p.h * p.c * 1e9 / min_energy;
    
    % Find where the max wavelength occurs in wavelengths
    index = find(s.wavelengths < max_wavelength, 1, 'last');
    
    % Plot up to that index
    plot(s.wavelengths(1:index), s.bs(1:index));
end