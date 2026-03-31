% Function to return a results structure with the constants required to
% calculate the voltage from the input current density

function res = calculate_const(x, par, spectrums)
    % Unpack the input variables
    pvk_thick = x(1);
    si_n_thick = x(2);
    si_p_thick = x(3);
    Nd = x(4);
    Na = x(5);

    % Calculate the built in voltage of the silicon
    res.Vbi2 = par.VT * log(Na * Nd / (par.ni2 ^ 2));

    % Calculate the silicon depletion region width
    res.W2 = sqrt(2 * par.eps2 * res.Vbi2 * ((1/Na) + (1/Nd)) / par.q);
end