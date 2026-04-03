% Function to return the result to be integrated to find the generated
% current in the rear bulk (n-type)

function ret = calculate_rear_int(x, Wn, Wp, par, res, a)
    % Unpack the input
    x = x * 1e-2;               % (cm)
    Wn = Wn * 1e-2;
    Wp = Wp * 1e-2;

    % Calculate the integral function
    ret = (cosh(x / par.Lp2) - ...
        (((((par.Srear * par.Lp2 / par.Dp2) * cosh(Wn / par.Lp2)) + sinh(Wn / par.Lp2)) ...
        / (((par.Srear * par.Lp2 / par.Dp2) * sinh(Wn / par.Lp2)) + cosh(Wn / par.Lp2))) ...
        * sinh(x / par.Lp2))) ...
        * exp(-1 * a * (x + Wp + res.wp + res.wn));
end