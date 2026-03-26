% Function to calculate the cost per watt for a set of thicknesses

function cost_watt = evaluate_cost_watt(x, par, spectrums, options)
    % Unpack input variables
    PVKThick = x(1);
    SiThick = x(2);

    % Calculate the MPP
    MPP = Methods.evaluate_MPP(x, par, spectrums, options);

    % Calculate the cost
    cost = par.baselineCost + ... 
        ((par.PVKCost * PVKThick * 1e-6)' * (par.SiCost * SiThick * 1e3));
    
    % Return the cost/watt
    cost_watt = (cost / MPP) * 1e3;
end