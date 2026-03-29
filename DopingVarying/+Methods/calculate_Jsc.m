% Script to calculate the short circuit current densities

function res = calculate_Jsc(par, res)
    % Import the spectrum data
    spectrum_table = readmatrix("Spectrum_full.xlsx");
    spectrums.wavelengths = spectrum_table(:,1);
    spectrums.bs_cumulative = spectrum_table(:,2);      % (photons cm-2 s-1)
    
    % Switch from the cumulative spectrum to the photon flux density
    spectrums.bs = zeros(size(spectrums.bs_cumulative));
    spectrums.bs(1) = spectrums.bs_cumulative(1);
    spectrums.bs(2:end) = spectrums.bs_cumulative(2:end) - spectrums.bs_cumulative(1:end-1);
    
    % Convert the spectrums.wavelengths to photon energies (converting from nm to m)
    E = par.h * par.c ./(spectrums.wavelengths / 1e9);  % (eV)
    
    % Find each valid discrete value of energy
    spectrums.validE1 = E >= (par.Ec - par.Ev);
    spectrums.validE2 = E >= par.Eg2;
    
    % Convert the energy masks to doubles
    spectrums.validE1 = double(spectrums.validE1);
    spectrums.validE2 = double(spectrums.validE2);
    
    % Add interpolation to the mask
    % Find the index of the last suitable energy
    indices1 = find(spectrums.validE1);
    last1 = indices1(end);
    indices2 = find(spectrums.validE2);
    last2 = indices2(end);
    % Find the fraction between the last full and next photon energy
    spectrums.validE1(last1 + 1) = (E(last1) - (par.Ec - par.Ev))/(E(last1) - E(last1 + 1));
    spectrums.validE2(last2 + 1) = (E(last2) - par.Eg2)/(E(last2) - E(last2 + 1));
    
    % Create vectors for the reflectivity, absorptivity, and probability
    R1 = spectrums.validE1 * par.R1;
    R2 = spectrums.validE2 * par.R2;
    a1 = spectrums.validE1 * (1 - exp(-par.a1 * par.thick1 * 1e-7));
    a2 = spectrums.validE2 * (1 - exp(-par.a2 * res.W2));
    etac1 = spectrums.validE1 * par.etac1;
    etac2 = spectrums.validE2 * par.etac2;
    
    % Calculate the spectrum seen by cell 2
    spectrums.bs2 = (ones(size(R1))-R1) .* (ones(size(R2))-R2) .* (ones(size(a1))-a1) .* spectrums.bs;
    
    % Evaluate Jsc1 and Jsc2
    Jsc1 = par.q * sum(etac1 .* (ones(size(R1))-R1) .* a1 .* (spectrums.bs .* spectrums.validE1));  % (A cm-2)
    Jsc2 = par.q * sum(etac2 .* (ones(size(R2))-R2) .* a2 .* (spectrums.bs2 .* spectrums.validE2));
    
    % Convert to (mA cm-2)
    res.Jsc1 = Jsc1 * 1e3;
    res.Jsc2 = Jsc2 * 1e3;

    % Return the spectrum data
    spectrums.E = E;
    res.spectrums = spectrums;
end