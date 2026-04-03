% Function to be solved by fsolve to determine the four voltages in the PVK

function F = solve_pvk_v(x, V, p, res)
    % Unpack inputs
    V1 = x(1);
    V2 = x(2);
    V3 = x(3);
    V4 = x(4);
    Q = x(5);
    
    % V1 equation
    F(1) = (-res.omegaE * Q) - Methods.evaluate_Q(V1, p, res);
    
    % V2 equation
    F(2) = -Q - Methods.evaluate_Q(V2, p, res);
    
    % V3 equation
    F(3) = Q - Methods.evaluate_Q(V3, p, res);
    
    % V4 equation
    F(4) = (-res.omegaH * Q) - Methods.evaluate_Q(V4, p, res);
    
    % Total voltage
    F(5) = V1 + V2 + V3 + V4 - (res.Vbi1 - V);
end