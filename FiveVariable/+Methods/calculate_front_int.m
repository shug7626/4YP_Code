% Function to return the result to be integrated to find the generated
% current in the front bulk (p-type)

function ret = calculate_front_int(x, L, S, D, W, a)
    % Unpack the input
    x = x * 1e-2;               % (cm)
    W = W * 1e-2;

    % Calculate the integral function
    ret = (cosh(x / L) - ...
        (((((S * L / D) * cosh(W / L)) + sinh(W / L)) ...
        / (((S * L / D) * sinh(W / L)) + cosh(W / L))) ...
        * sinh(x / L))) ...
        * exp(-1 * a * (W - x));
end