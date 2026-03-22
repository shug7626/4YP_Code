% Function to calculate and return the silicon diode constants

function calculate_Si_const(par)
    % Built in voltage
    par.Vbi2 = par.VT * log(par.Na2 * par.Nd2 / (par.ni2 ^ 2));
    
    % Diffusion current constant
    par.Jdiff02 = par.q * (par.ni2^2) * ((par.Dn2 / (par.Na2 * par.Ln2)) + (par.Dp2 / (par.Nd2 * par.Lp2)));
    par.Jdiffd2 = par.q * par.Nd2 * par.Na2 * ((par.Dn2 / (par.Na2 * par.Ln2)) + (par.Dp2 / (par.Nd2 * par.Lp2)));
    
    % Radiative recombination current constant
    par.Jrad02 = par.beta2 * ((par.n2 * par.p2) - (par.ni2 ^ 2));
    par.Jradd2 = par.beta2 * ((par.n2 * par.p2 * exp(par.Vbi2/par.VT)) - (par.Nd2 * par.Na2));
    
    % Recombination in the depletion region (SCR) current constant
    par.Jscr02 = par.ni2 * sqrt(2 * par.q * par.eps2 * ((1/par.Na2) + (1/par.Nd2)) * par.Vbi2 / (par.tn2 * par.tp2));
    par.Jscrd2 = sqrt(2 * par.q * par.eps2 * (par.Nd2 + par.Na2) * par.Vbi2 / (par.tn2 * par.tp2));
end