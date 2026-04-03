% Script to calculate the PVK constants

function res = calculate_pvk_const(thick1, res, par, options)
    % Built-in voltage (V) (converting the energies from eV to J)
    res.Vbi1 = (par.EcE - par.EvH) + par.VT*log((par.dH * par.dE)/(par.gvH * par.gcE));
    
    % nb and pb
    res.nb = (par.dE * par.gc / par.gcE) * exp((par.EcE - par.Ec)/par.VT);
    res.pb = (par.dH * par.gv / par.gvH) * exp((par.Ev - par.EvH)/par.VT);
    
    % Debye length (m)
    res.LD = sqrt((par.epsA * par.eps0 * par.VT)/(par.q * par.N0));
    res.omegaE = sqrt((par.epsA * par.eps0 * par.N0)/(par.epsE * par.eps0 * par.dE));
    res.omegaH = sqrt((par.epsA * par.eps0 * par.N0)/(par.epsH * par.eps0 * par.dH));
    
    % Intrinsic carrier concentration
    res.ni2 = par.gc * par.gv * exp(-(par.Ec - par.Ev)/(par.k * par.T));
    
    % Q(V) pre-multiplier
    res.Q0 = sqrt(2 * par.q * par.N0 * par.epsA * par.eps0 * par.VT);

    % Calculate PVK Voc by finding the voltage for J = 0
    Voc0 = res.Vbi1 * 0.9;
    pvk_Voc_func = @(v) Methods.calculate_JPSC(par, res, v, thick1, options);
    res.Voc1 = fzero(pvk_Voc_func, Voc0);
end