function F = evaluate_single_non_ideal(x, V, params)
    % Unpack input
    J = x(1);
    V1 = x(2);

    % Current equation
    F(1) = (((V1 - params.Vbi)/params.VT) * log((params.Jdiffd + params.Jradd) ...
        + params.Jscrd * exp(-(V1 - params.Vbi)/(2*params.VT)))) ...
        - log(params.Jillum - (V1 / (params.A * params.Rsh)) - J);
    
    % Voltage equation
    F(2) = V + (J * params.A * params.Rs) - V1;
end