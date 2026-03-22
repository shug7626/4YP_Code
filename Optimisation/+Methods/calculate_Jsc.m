% Function to calculate and return the short circuit current densities
% based on the incident photon flux and material parameters

function [Jsc1, Jsc2, bs2] = calculate_Jsc(par, spectrums, thick1, thick2)
    % Unpack the energy spetrum
    E = spectrums.E;

    % Find each valid discrete value of energy
    ValidE1 = E >= (par.Ec - par.Ev);
    ValidE2 = E >= par.Eg2;
    
    % Convert the energy masks to doubles
    ValidE1 = double(ValidE1);
    ValidE2 = double(ValidE2);
    
    % Add interpolation to the mask
    % Find the index of the last suitable energy
    indices1 = find(ValidE1);
    last1 = indices1(end);
    indices2 = find(ValidE2);
    last2 = indices2(end);
    % Find the fraction between the last full and next photon energy
    ValidE1(last1 + 1) = (E(last1) - (par.Ec - par.Ev))/(E(last1) - E(last1 + 1));
    ValidE2(last2 + 1) = (E(last2) - par.Eg2)/(E(last2) - E(last2 + 1));
    
    % Create vectors for the reflectivity, absorptivity, and probability
    R1 = ValidE1 * par.R1;
    R2 = ValidE2 * par.R2;
    a1 = ValidE1 * (1 - exp(-par.a1 * thick1));
    a2 = ValidE2 * (1 - exp(-par.a2 * thick2));
    etac1 = ValidE1 * par.etac1;
    etac2 = ValidE2 * par.etac2;
    
    % Calculate the spectrum seen by cell 2
    bs2 = (ones(size(R1))-R1) .* (ones(size(R2))-R2) .* (ones(size(a1))-a1) .* spectrums.bs;
    
    % Evaluate Jsc1 and Jsc2
    Jsc1 = par.q * sum(etac1 .* (ones(size(R1))-R1) .* a1 .* (spectrums.bs .* ValidE1));  % (A cm-2)
    Jsc2 = par.q * sum(etac2 .* (ones(size(R2))-R2) .* a2 .* (bs2 .* ValidE2));
    
    % Convert to (mA cm-2)
    Jsc1 = Jsc1 * 1e3;
    Jsc2 = Jsc2 * 1e3;
end