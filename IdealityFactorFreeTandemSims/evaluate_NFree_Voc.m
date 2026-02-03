function F = evaluate_NFree_Voc(V, params)
    V1 = V(1);
    V2 = V(2);
    
    F(1) = params.Jsc1 - (params.J_diff01 + params.J_rad01)*(exp(V1/params.Vt) - 1) ...
        - params.J_scr01*(exp(V1/(2 * params.Vt)) - 1) + V1/params.Rsh1;
    
    F(2) = params.Jsc2 - (params.J_diff02 + params.J_rad02)*(exp(V2/params.Vt) - 1) ...
        - params.J_scr02*(exp(V2/(2 * params.Vt)) - 1) + V2/params.Rsh2;
end