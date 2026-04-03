% Function to calculate the voltage across the silicon current source and
% shunt resistor

function F = evaluate_Si_V(v2, J, par, res)
    F = ((v2 - res.Vbi2) / par.VT) ...
        + log(res.Jdiffd2 + res.Jradd2 + (res.Jscrd2 * exp(-(v2-res.Vbi2)/(2*par.VT)))) ...
        - log(res.Jillum2 - (v2/(par.A * par.Rsh2)) - J);
end