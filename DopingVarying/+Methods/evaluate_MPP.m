% Script to return the MPP for a given input

function MPP = evaluate_MPP(x, par, options)
    % Unpack the input variables
    pvk_thick = x(1);
    Nd = x(2);
    Na = x(3);

    % Initialise a blank res structure
    res = struct();

    % Calculate the built in voltage of the silicon
    res.Vbi2 = par.VT * log(Na * Nd / (par.ni2 ^ 2));
    
    % Calculate the silicon depletion region width
    res.W2 = sqrt(2 * par.eps2 * res.Vbi2 * ((1/Na) + (1/Nd)) / par.q);         % (cm)
    
    % Calculate the short circuit current densities
    res = Methods.calculate_Jsc(par, res, pvk_thick);
    
    % Calculate the silicon constants
    res = Methods.calculate_silicon_const(Na, Nd, par, res);
    
    % Calculate the PVK constants
    res = Methods.calculate_pvk_const(pvk_thick, res, par, options);

    % Create the negative power function
    P = @(j) -1*j*Methods.evaluate_V(j, pvk_thick, res, par, options);

    % Use fminbnd to find the minimum negative power
    [Jmpp_res, MPP_res] = fminbnd(P, 0, min([res.Jsc1 res.Jsc2]));

    % Return the result
    MPP = -1 * MPP_res;
end