% Script to calculate the short circuit current densities

function res = calculate_Jsc(x, par, res, spectrums)
    % Unpack the input
    pvk_thick = x(1);

    % % Create vectors for the reflectivity, absorptivity, and probability
    R1 = spectrums.PVK(:, 3);
    R2 = spectrums.Si(:, 3);
    a1 = 1 - exp(-spectrums.PVK(:,2) * pvk_thick * 1e-7);
    
    % Calculate the spectrum seen by cell 2
    bs2 = (1-R1) .* (1-R2) .* (1-a1) .* spectrums.bs;
    
    % Evaluate Jsc1 and Jsc2
    Jsc1 = par.q * sum((1-R1) .* a1 .* spectrums.bs .* spectrums.validE1);  % (A cm-2)
    [Jsc2, res] = Methods.calculate_si_Jsc(bs2, par, res, spectrums);
    
    % Convert to (mA cm-2)
    res.Jsc1 = Jsc1 * 1e3;
    res.Jsc2 = Jsc2 * 1e3;
end