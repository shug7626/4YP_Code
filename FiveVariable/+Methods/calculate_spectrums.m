% Function to read the spectrum data and return a spectrums structure

function s = calculate_spectrums(par)
    %% Import spectrum data
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

    %% Import the wavelength dependent data
    % PVK data
    opts = detectImportOptions('+Data/Perovskite_data.csv');
    opts.DataLines = [2, Inf];
    opts.SelectedVariableNames = opts.VariableNames([1, 2, 4, 5]);
    PVK = readmatrix('+Data/Perovskite_data.csv', opts);

    % Si data
    opts = detectImportOptions('+Data/Si_Crystalline_data.csv');
    opts.DataLines = [2, Inf];
    opts.SelectedVariableNames = opts.VariableNames([1, 2, 4, 5]);
    Si = readmatrix('+Data/Si_Crystalline_data.csv', opts);

    % Use a for loop and interpolation to find the refractive index and
    % absorption coefficient for each wavelength/energy
    for iter = 1:length(s.wavelengths)
        lambda = s.wavelengths(iter);

        % Calculate the PVK refractive index and absorptivity
        if lambda < PVK(1, 1)
            s.PVK(iter, 1) = PVK(1, 2);
            s.PVK(iter, 2) = PVK(1, 4);
        elseif lambda > PVK(end, 1)
            s.PVK(iter, 1) = PVK(end, 2);
            s.PVK(iter, 2) = PVK(end, 4);
        else
            index = find(PVK(:, 1) <= lambda, 1, 'last');
            if index >= length(PVK(:, 1))
                index2 = length(PVK(:,1));
            else
                index2 = index + 1;
            end
            frac = (lambda - PVK(index, 1)) ...
                / (PVK(index2, 1) - PVK(index, 1));
            s.PVK(iter, 1) = PVK(index, 2) + ...
                frac * (PVK(index2, 2) - PVK(index, 2));
            s.PVK(iter, 2) = PVK(index, 4) + ...
                frac * (PVK(index2, 4) - PVK(index, 4));
        end
        
        % Calculate the Si refractive index and absorptivity
        if lambda < Si(1, 1)
            s.Si(iter, 1) = Si(1, 2);
            s.Si(iter, 2) = Si(1, 4);
        elseif lambda > Si(end, 1)
            s.Si(iter, 1) = Si(end, 2);
            s.Si(iter, 2) = Si(end, 4);
        else
            index = find(Si(:, 1) <= lambda, 1, 'last');
            if index >= length(Si(:, 1))
                index2 = length(Si(:,1));
            else
                index2 = index + 1;
            end
            frac = (lambda - Si(index, 1)) ...
                / (Si(index2, 1) - Si(index, 1));
            s.Si(iter, 1) = Si(index, 2) + ...
                frac * (Si(index2, 2) - Si(index, 2));
            s.Si(iter, 2) = Si(index, 4) + ...
                frac * (Si(index2, 4) - Si(index, 4));
        end
    end

    %% Calculate the Reflectivity Vectors
    % Assuming light has a refractive index of 1 across the considered
    % frequency range
    s.PVK(:, 3) = ((1 - s.PVK(:, 1)) ./ (1 + s.PVK(:, 1))).^2;
    s.Si(:, 3) = ((s.PVK(:, 1) - s.Si(:, 1)) ./ (s.PVK(:, 1) + s.Si(:, 1))).^2;
end