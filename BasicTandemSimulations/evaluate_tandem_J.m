function F = evaluate_tandem_J(x, V, params)
    % Unpack variables
    J = x(1);
    V1 = x(2);
    V2 = x(3);
    
    % Equation 2 (cell 1)
    F(1) = J - params.Jsc1 + params.J01*(exp(V1/(params.N1 * params.Vt)) - 1) ...
        + V1/params.Rsh1;
    
    % Equation 3 (cell 2)
    F(2) = J - params.Jsc2 + params.J02*(exp(V2/(params.N2 * params.Vt)) - 1) ...
        + V2/params.Rsh2;
    
    % Equation 5 (total voltage and series resistor)
    F(3) = V - (V1 + V2 - J*params.A*params.Rs);
end