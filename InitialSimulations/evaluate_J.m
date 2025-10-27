function F = evaluate_J(J, J_sc, J_0, V, A, R_s, R_sh, q, k_B, T)
F = J - J_sc + J_0*(exp(q*(V + J *A* R_s)/(k_B*T)) - 1) ...
    + (V + (J *A*R_s))/R_sh;
end