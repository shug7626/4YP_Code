% Function to read the spectrum data and return a spectrums structure

function s = calculate_spectrums(par)
    % Import spectrum data
    opts = detectImportOptions('+Data/Spectrum_full.xlsx', 'Sheet', 2);
    opts.SelectedVariableNames = opts.VariableNames([1, 3]);
    s.full = readmatrix('+Data/Spectrum_full.xlsx', opts);
    s.wavelengths = s.full(:, 1);
    s.cumulative_flux = s.full(:, 2);
    
    % Convert from cumulative to photon flux density
    s.bs = zeros(size(s.cumulative_flux));
    s.bs(1) = s.cumulative_flux(1);
    s.bs(2:end) = s.cumulative_flux(2:end) ...
        - s.cumulative_flux(1:end-1);
    
    % Convert the wavelengths to energies
    s.E = par.h * par.c ./ (s.wavelengths * 1e-9);      % (eV)
    
    % Create an energies mask for each layer
    s.validE1 = double(s.E >= (par.Ec - par.Ev));
    s.validE2 = double(s.E >= par.Eg2);
    
    % Add interpolation to the mask
    % Find the last energies
    last1 = find(s.validE1);
    last1 = last1(end);
    last2 = find(s.validE2);
    last2 = last2(end);
    % Find the disatnce between last and last+1
    s.validE1(last1 + 1) = (s.E(last1) - (par.Ec - par.Ev)) ...
        / (s.E(last1) - s.E(last1 + 1));
    s.validE2(last2 + 1) = (s.E(last2) - (par.Ec - par.Ev)) ...
        / (s.E(last2) - s.E(last2 + 1));
end