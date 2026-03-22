% Function to calculate the perovskite constants

function par = calculate_PVK_const(par)
    % Built-in voltage (V) (converting the energies from eV to J)
    par.Vbi1 = (par.EcE - par.EvH) + par.VT*log((par.dH * par.dE)/(par.gvH * par.gcE));
    
    % nb and pb
    par.nb = (par.dE * par.gc / par.gcE) * exp((par.EcE - par.Ec)/par.VT);
    par.pb = (par.dH * par.gv / par.gvH) * exp((par.Ev - par.EvH)/par.VT);
    
    % Debye length (m)
    par.LD = sqrt((par.epsA * par.eps0 * par.VT)/(par.q * par.N0));
    par.omegaE = sqrt((par.epsA * par.eps0 * par.N0)/(par.epsE * par.eps0 * par.dE));
    par.omegaH = sqrt((par.epsA * par.eps0 * par.N0)/(par.epsH * par.eps0 * par.dH));
    
    % Intrinsic carrier concentration
    par.ni2 = par.gc * par.gv * exp(-(par.Ec - par.Ev)/(par.k * par.T));
    
    % Q(V) pre-multiplier
    par.Q0 = sqrt(2 * par.q * par.N0 * par.epsA * par.eps0 * par.VT);
end