% Function to calculate the silicon constants for a given set of doping
% concentrations

function res = calculate_silicon_const(Na, Nd, par, res)
    n2 = Nd;
    p2 = Na;

    % Built in voltage
    res.Vbi2 = par.VT * log(Na * Nd / (par.ni2 ^ 2));
    
    % Diffusion current constant
    res.Jdiff02 = par.q * (par.ni2^2) * ((par.Dn2 / (Na * par.Ln2)) + (par.Dp2 / (Nd * par.Lp2)));
    res.Jdiffd2 = par.q * Nd * Na * ((par.Dn2 / (Na * par.Ln2)) + (par.Dp2 / (Nd * par.Lp2)));
    
    % Radiative recombination current constant
    res.Jrad02 = par.beta2 * ((n2 * p2) - (par.ni2 ^ 2));
    res.Jradd2 = par.beta2 * ((n2 * p2 * exp(res.Vbi2/par.VT)) - (Nd * Na));
    
    % Recombination in the depletion region (SCR) current constant
    res.Jscr02 = par.ni2 * sqrt(2 * par.q * par.eps2 * ((1/Na) + (1/Nd)) * res.Vbi2 / (par.tn2 * par.tp2));
    res.Jscrd2 = sqrt(2 * par.q * par.eps2 * (Nd + Na) * res.Vbi2 / (par.tn2 * par.tp2));

    % Calculate the silicon open circuit voltage
    % Find where the silicon current is zero
    si_Voc_func = @(v) evaluate_si_Voc(v, par, res);
    res.Voc2 = fzero(si_Voc_func, res.Vbi2/2);
end