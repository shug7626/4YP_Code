% Function to return a results structure with the constants required to
% calculate the voltage from the input current density

function res = calculate_const(x, par, spectrums)
    % Unpack the input variables
    Nd = x(4);
    Na = x(5);

    % Calculate the built in voltage of the silicon
    res.Vbi2 = par.VT * log(Na * Nd / (par.ni2 ^ 2));

    % Calculate the silicon depletion region widths
    w_pre = sqrt((2 * par.eps2 * res.Vbi2)/(par.q * ((1/Na) + (1/Nd))));    % (cm-2)
    res.wn = (1/Nd) * w_pre;            % (cm)
    res.wp = (1/Na) * w_pre;

    % Calculate the short circuit current densities
    res = Methods.calculate_Jsc(x, par, res, spectrums);

    % Calculate the silicon constants
    res = Methods.calculate_silicon_const(Na, Nd, par, res);
end