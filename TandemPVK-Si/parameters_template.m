% Parameters to be used in PVK_Si_main.m

% Cell 1 - Perovskite
% Cell 2 - Silicon

% Units as in the Parameters Table

function par = parameters()
    % Calculation parameters
    par.N = 1000;        % Number of points to perform the calculation on

    % Parameters
    par.T = 300;
    par.A = 1;

    % Cell 1 (Top - PVK)
    par.Rs1 = 1e-4;
    par.Rsh1 = 1e4;
    p.beta = 10e-11;
    p.taun = 3e-11;
    p.taup = 3e-10;
    p.vnH = 30;
    p.vpE = 30;
    p.thick1 = 400e-9;
    p.N0 = 1.6e25;
    p.dE = 5e24;
    p.dH = 5e24;
    p.gc = 8.1e24;
    p.gv = 5.8e24;
    p.gcE = 1e26;
    p.gvH = 1e26;
    p.Ec = -3.7;
    p.Ev = -5.4;
    p.EcE = -4.0;
    p.EvH = -5.1;
    p.epsA = 24.1;
    p.epsE = 10;
    p.epsH = 3;
    p.R1 = 0.05;
    p.a1 = 1.3e7;
    p.etac1 = 0.95;

    % Cell 2 (Bottom - Si)
    par.Rs2 = 1e-4;
    par.Rsh2 = 1e4;
    par.ni2 = 1e10;
    par.Nd2 = 2e20;
    par.Na2 = 3e18;
    par.n2 = par.Nd2;
    par.p2 = par.Na2;
    par.Dn2 = 38.7;
    par.Dp2 = 11.61;
    par.tn2 = 30e-6;
    par.tp2 = 30e-6;
    par.Ln2 = sqrt(par.Dn2*par.tn2);
    par.Lp2 = sqrt(par.Dp2*par.tp2);
    par.beta2 = 0;
    par.eps2 = 11.7 * 8.854e-14;
    par.R2 = 0.08;
    par.a2 = 2.1e4;
    par.etac2 = 0.95;
    par.Eg2 = 1.11;
    par.thick2 = 180e-6;
    
    % Total series resistance
    par.Rs = par.Rs1 + par.Rs2;

    % Constants
    par.q = 1.602e-19;
    par.k = 1.38e-23;
    par.h = 4.136e-15;          % (eV s)
    par.c = 2.998e8;            % (m s-1)
end


