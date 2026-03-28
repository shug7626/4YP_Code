% Function to be used to calculate the voltage of the PSC at a given
% voltage

function F = evaluate_PVK_V(v1, J, Jsc1, thick1, par, options)
    F = Methods.calculate_JPSC(par, v1, Jsc1, thick1, options) ...
        - (v1/(par.Rsh1 * par.A)) ...
        - J;
end