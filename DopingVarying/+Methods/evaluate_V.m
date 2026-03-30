% Function to return the total voltage across the cell

function V = evaluate_V(J, thick1, res, par, options)
    % Set initial guess for the silicon Voc
    v0 = res.Vbi2 / 2;
    
    % Find where the silicon current is zero
    si_Voc_func = @(v) Methods.evaluate_si_Voc(v, par, res);
    Voc2 = fzero(si_Voc_func, v0);
    
    % Calculate PVK Voc by finding the voltage for J = 0
    Voc0 = res.Vbi1 * 0.9;
    pvk_Voc_func = @(v) Methods.calculate_JPSC(par, res, v, thick1, options);
    Voc1 = fzero(pvk_Voc_func, Voc0);


    % Calculate the constants to be used for the initial guesses
    n_estimate = 1.1;
    jd01 = res.Jsc1 / (exp((Voc1 - res.Vbi1) / (n_estimate * par.VT)));
    jd02 = res.Jsc2 / (exp((Voc2 - res.Vbi2) / (n_estimate * par.VT)));

    % Set the initial guesses
    v01 = res.Vbi1 + (n_estimate * par.VT * log((res.Jsc1 - J)/jd01));
    v02 = res.Vbi2 + (n_estimate * par.VT * log((res.Jsc2 - J)/jd02));

    % Initialise the functions to be used
    pvk_V_func = @(v1) Methods.evaluate_PVK_V(v1, J, thick1, par, res, options);
    si_V_func = @(v2) Methods.evaluate_Si_V(v2, J, par, res);

    % Use fzero to find the corresponding voltage
    V1 = fzero(pvk_V_func, v01);
    V2 = fzero(si_V_func, v02);

    % Calculate the total cell voltage
    v_s = -J * (par.Rs1 + par.Rs2) * par.A;
    V = V1 + V2 + v_s;
end