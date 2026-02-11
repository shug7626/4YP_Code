function F = evaluate_tandem_si_si_Voc(v, params)
    % Unpack inputs
    V1 = v(1);
    V2 = v(2);
    
    % Cell 1
    F(1) = ((V1 - params.Vbi1) / params.VT) * log((params.Jdiffd1 + params.Jradd1) ...
        + (params.Jscrd1 * exp(-(V1 - params.Vbi1)/(2 * params.VT)))) ...
        - log(params.Jillum1 - (V1 / (params.A * params.Rsh1)));
    
    % Cell 2
    F(2) = ((V2 - params.Vbi2) / params.VT) * log((params.Jdiffd2 + params.Jradd2) ...
        + (params.Jscrd2 * exp(-(V2 - params.Vbi2)/(2 * params.VT)))) ...
        - log(params.Jillum2 - (V2 / (params.A * params.Rsh2)));
end