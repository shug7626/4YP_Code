% Function to return the cost per watt for given input variables

function cost_watt = evaluate_cost_watt(x, par, options)
    % Unpack the input variables
    pvk_thick = x(1);
    Nd = x(2);
    Na = x(3);

    % Calculate the MPP
    MPP = Methods.evaluate_MPP(x, par, options);

    % Calculate the silicon depletion region width
    Vbi2 = par.VT * log(Na * Nd / (par.ni2 ^ 2));
    W2 = sqrt(2 * par.eps2 * Vbi2 * ((1/Na) + (1/Nd)) / par.q);         % (cm)

    % Calculate a minimum silicon cell thickness
    si_thick = W2 * par.SiThickScale;

    % Calculate the cost
    cost = par.baselineCost ...
        + (pvk_thick * par.PVKCost) ...
        + (si_thick * par.SiCost);

    % Return the cost per watt
    cost_watt = cost / MPP;
end