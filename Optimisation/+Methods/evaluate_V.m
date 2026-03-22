% Function to return the total cell voltage

function V = evaluate_V(J, Jsc1, Jsc2, par, options)
    % Set initial guess for the silicon Voc
    v0 = par.Vbi2 / 2;
    
    % Find where the silicon current is zero
    si_Voc_func = @(v) evaluate_si_Voc(v, par);
    Voc2 = fzero(si_Voc_func, v0);
    
    % Calculate PVK Voc by finding the voltage for J = 0
    Voc0 = par.Vbi1 * 0.9;
    pvk_Voc_func = @(v) calculate_JPSC(par, v, options);
    Voc1 = fzero(pvk_Voc_func, Voc0);


    % Calculate the constants to be used for the initial guesses
    n_estimate = 1.1;
    jd01 = Jsc1 / (exp((Voc1 - par.Vbi1) / (n_estimate * par.VT)));
    jd02 = Jsc2 / (exp((Voc2 - par.Vbi2) / (n_estimate * par.VT)));

    % Set the initial guesses
    v01 = par.Vbi1 + (n_estimate * par.VT * log((Jsc1 - J(iter))/jd01));
    v02 = par.Vbi2 + (n_estimate * par.VT * log((Jsc2 - J(iter))/jd02));

    % Initialise the functions to be used
    pvk_V_func = @(v1) evaluate_PVK_V(v1, J, par, options);
    si_V_func = @(v2) evaluate_Si_V(v2, J, par);

    % Use fzero to find the corresponding voltage
    V1 = fzero(pvk_V_func, v01);
    V2 = fzero(si_V_func, v02);

    % Calculate the total cell voltage
    v_s = -J * (par.Rs1 + par.Rs2) * par.A;
    V = V1 + V2 + v_s;
end