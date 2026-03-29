% Function to calculate the silicon constants for a given set of doping
% concentrations

function par = calculate_silicon_const(Na, Nd, par)
    n2 = Nd;
    p2 = Na;

    % Built in voltage
    par.Vbi2 = par.VT * log(Na * Nd / (par.ni2 ^ 2));
    
    % Diffusion current constant
    par.Jdiff02 = par.q * (par.ni2^2) * ((par.Dn2 / (Na * par.Ln2)) + (par.Dp2 / (Nd * par.Lp2)));
    par.Jdiffd2 = par.q * Nd * Na * ((par.Dn2 / (Na * par.Ln2)) + (par.Dp2 / (Nd * par.Lp2)));
    
    % Radiative recombination current constant
    par.Jrad02 = par.beta2 * ((n2 * p2) - (par.ni2 ^ 2));
    par.Jradd2 = par.beta2 * ((n2 * p2 * exp(par.Vbi2/par.VT)) - (Nd * Na));
    
    % Recombination in the depletion region (SCR) current constant
    par.Jscr02 = par.ni2 * sqrt(2 * par.q * par.eps2 * ((1/Na) + (1/Nd)) * par.Vbi2 / (par.tn2 * par.tp2));
    par.Jscrd2 = sqrt(2 * par.q * par.eps2 * (Nd + Na) * par.Vbi2 / (par.tn2 * par.tp2));

    % Depletion region width
    par.W2 = sqrt(2 * par.eps2 * par.Vbi2 * ((1/Na) + (1/Nd)) / par.q);         % (cm)
end