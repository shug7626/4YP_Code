% Function to return the result to be integrated to find the generated
% current in the front bulk (p-type)

function ret = calculate_front_int(x, par, W, a)
    % Unpack the input
    x = x * 1e-2;               % (cm)
    W = W * 1e-2;

    % Calculate the integral function
    ret = (cosh(x / par.Ln2) - ...
        (((((par.Sfront * par.Ln2 / par.Dn2) * cosh(W / par.Ln2)) + sinh(W / par.Ln2)) ...
        / (((par.Sfront * par.Ln2 / par.Dn2) * sinh(W / par.Ln2)) + cosh(W / par.Ln2))) ...
        * sinh(x / par.Ln2))) ...
        * exp(-1 * a * (W - x));
end