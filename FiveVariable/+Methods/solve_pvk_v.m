% Function to be solved by fsolve to determine the four voltages in the PVK

function F = solve_pvk_v(x, V, p, res)
    % Unpack inputs
    V1 = x(1);
    V2 = x(2);
    V3 = x(3);
    V4 = x(4);
    Q = x(5);
    
    % V1 equation
    % F(1) = (-res.omegaE * Q) - Methods.evaluate_Q(V1, p, res);
    F(1) = Methods.evaluate_Q(-V1, p, res) + (res.omegaE * Q);
    
    % V2 equation
    % F(2) = -Q - Methods.evaluate_Q(V2, p, res);
    F(2) = Methods.evaluate_Q(-V2, p, res) + Q;
    
    % V3 equation
    % F(3) = Q - Methods.evaluate_Q(V3, p, res);
    F(3) = Methods.evaluate_Q(V3, p, res) - Q;
    
    % V4 equation
    % F(4) = (-res.omegaH * Q) - Methods.evaluate_Q(V4, p, res);
    F(4) = Methods.evaluate_Q(-V4, p, res) + (res.omegaH * Q);
    
    % Total voltage
    F(5) = V1 + V2 + V3 + V4 - (res.Vbi1 - V);
end