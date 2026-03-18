% Function to calculate the voltage across the silicon current source and
% shunt resistor

function F = evaluate_Si_V(v2, J, par)
    F = ((v2 - par.Vbi2) / par.VT) ...
        + log((par.Jdiffd2 + par.Jradd2) + (par.Jscrd2 * exp(-(v2-par.Vbi2)/2*par.VT))) ...
        - log(par.Jillum2 - (v2/(par.A * par.Rsh2)) - J);
end