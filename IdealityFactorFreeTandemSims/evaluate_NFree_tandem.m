function F = evaluate_NFree_tandem(x, V, params)
    % Unpack variables
    J = x(1);
    V1 = x(2);
    V2 = x(3);
    
    % Using the equations from Jenny Nelson's 'The Physics of Solar Cells'
    % Cell 1 Voltage
    F(1) = J - (params.Jsc1 - (params.J_diff01 + params.J_rad01)*(exp(V1/params.Vt) - 1) ...
        - params.J_scr01*(exp(V1/(2 * params.Vt)) - 1) ...
        + V1/(params.Rsh1 * params.A));
    
    % Cell 2 Voltage
    F(2) = J - (params.Jsc2 - (params.J_diff02 + params.J_rad02)*(exp(V2/params.Vt) - 1) ...
        - params.J_scr02*(exp(V2/(2 * params.Vt)) - 1) ...
        + V2/(params.Rsh2 * params.A));
    
    % Total Voltage
    F(3) = V - (V1 + V2 - J*params.A*params.Rs);
end