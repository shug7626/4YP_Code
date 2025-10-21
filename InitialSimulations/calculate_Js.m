function F = calculate_Js(J_s, J_sc, J_0, V, A, R_s, R_sh0, q, k_B, T, i)
F = J_s(i) - J_sc + J_0*(exp(q*(V + J_s(i) *A* R_s(i))/(k_B*T)) - 1) + (V + (J_s(i) *A*R_s(i)))/R_sh0;
end