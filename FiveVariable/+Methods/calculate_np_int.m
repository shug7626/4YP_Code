% Function to return the result to be integrated to find the generated
% current

function ret = calculate_np_int(x, L, S, D, W, a)
    % Unpack the input
    x1 = x(1) * 1e-2;               % (cm)
    x2 = x(2) * 1e-2;
    W = W * 1e-2;

    % Calculate the integral function
    ret = (cosh(x2 / L) - ...
        (((((S * L / D) * cosh(W / L)) + sinh(W / L)) ...
        / (((S * L / D) * sinh(W / L)) + cosh(W / L))) ...
        * sinh(x2 / L))) ...
        * exp(-1 * a * x1);
end