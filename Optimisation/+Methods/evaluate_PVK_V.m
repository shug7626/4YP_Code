% Function to be used to calculate the voltage of the PSC at a given
% voltage

function F = evaluate_PVK_V(v1, J, par, options)
    F = Methods.calculate_JPSC(par, v1, options) - (v1/(par.Rsh1 * par.A)) - J;
end