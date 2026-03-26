% Parameters to be used in optimisation_main.m

% Cell 1 - Perovskite
% Cell 2 - Silicon

% Units as in the Parameters Table

function par = parameters()
    % Calculation parameters
    par.N = 12;        % Number of points to perform the initial calculation on

    % Parameters
    par.T = 300;
    par.A = 1;

    % Thickness Variables
    par.thick1Min = 300;                   % (nm)
    par.thick1Max = 800;
    par.thick2Min = 100e-6;                % (m)
    par.thick2Max = 250e-6;

    % Cost
    par.baselineCost = 0.01;             % Production cost per area (£/cm2)
    par.PVKCost = 20;                    % PVK cost per thickness per area (£/cm3)
    par.SiCost = 0.2;                     % Si cost per thickness per area (£/cm3)

    % Cell 1 (Top - PVK)
    par.Rs1 = 1e-3;
    par.Rsh1 = 1e4;
    par.beta = 10e-11;
    par.taun = 3e-11;
    par.taup = 3e-10;
    par.vnH = 30;
    par.vpE = 30;
    par.N0 = 1.6e25;
    par.dE = 5e24;
    par.dH = 5e24;
    par.gc = 8.1e24;
    par.gv = 5.8e24;
    par.gcE = 1e26;
    par.gvH = 1e26;
    par.Ec = -3.7;
    par.Ev = -5.4;
    par.EcE = -4.0;
    par.EvH = -5.1;
    par.epsA = 24.1;
    par.epsE = 10;
    par.epsH = 3;
    par.R1 = 0.05;
    par.a1 = 1.3e7;
    par.etac1 = 0.95;

    % Cell 2 (Bottom - Si)
    par.Rs2 = 1e-3;
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
    
    % Total series resistance
    par.Rs = par.Rs1 + par.Rs2;

    % Constants
    par.q = 1.602e-19;
    par.k = 1.38e-23;
    par.h = 4.136e-15;          % (eV s)
    par.c = 2.998e8;            % (m s-1)
    par.eps0 = 8.854e-12;
end


