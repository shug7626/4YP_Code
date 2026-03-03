% Function to be solved by fsolve to determine the four voltages in the PVK

function F = solve_pvk_v(x, V, p)
    % Unpack inputs
    V1 = x(1);
    V2 = x(2);
    V3 = x(3);
    V4 = x(4);
    Q = x(5);
    
    % V1 equation
    F(1) = (-p.OmegaE * Q) - evaluate(V1);
    
    % V2 equation
    F(2) = -Q - evaluate(V2);
    
    % V3 equation
    F(3) = Q - evaluate(V3);
    
    % V4 equation
    F(4) = (-p.OmegaH * Q) - evaluate(V4);
    
    % Total voltage
    F(5) = V1 + V2 + V3 + V4 - (p.Vbi - V);
end