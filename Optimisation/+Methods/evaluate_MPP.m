% Function to find the MPP for a set of input thicknesses

function MPP = evaluate_MPP(x, par, spectrums, options)
    % Unpack the input variables
    PVKThick = x(1);
    SiThick = x(2);

    % Calculate the short circuit current densities
    [Jsc1, Jsc2] = Methods.calculate_Jsc(par, spectrums, PVKThick, SiThick);

    % Create the power function
    P = @(j) -1*j*Methods.evaluate_V(j, Jsc1, Jsc2, PVKThick, par, options);

    % Use fminbnd to find the minimum negative power
    [Jmpp_res, MPP_res] = fminbnd(P, 0, min([Jsc1 Jsc2]));

    % Return result
    MPP = -1 * MPP_res;
end