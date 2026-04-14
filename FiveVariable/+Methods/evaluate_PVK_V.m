% Function to be used to calculate the voltage of the PSC at a given
% voltage

function F = evaluate_PVK_V(v1, J, thick1, par, res, options)
    [J_PSC,V] = Methods.calculate_JPSC(par, res, v1, thick1, options);
    F = J_PSC ...
        - (v1/(par.Rsh1 * par.A)) ...
        - J;
end