function F = evaluate_tandem_pvk_si(x, V, params, options)
    % Unpack inputs
    J = x(1);
    V1 = x(2);
    V2 = x(3);
    
    % Cell 1 current
    F(1) = calculate_JPSC(params, V1, options) ...
        - (V1 / (params.A * params.Rsh1)) ...
        - J;
    
    % Cell 2 current
    F(2) = (((V2 - params.Vbi2)/params.VT) + log((params.Jdiffd2 + params.Jradd2) ...
        + params.Jscrd2 * exp(-(V2 - params.Vbi2)/(2*params.VT)))) ...
        - log(params.Jillum2 - (V2 / (params.A * params.Rsh2)) - J);
    
    % Total voltage
    F(3) = V - V1 - V2 + (J * params.A * params.Rs);
end