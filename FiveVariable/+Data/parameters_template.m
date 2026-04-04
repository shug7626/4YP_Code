% Parameters to be used in the individual simulation and optimisation
% programs

% Cell 1 - Perovskite
% Cell 2 - Silicon

% Units as in the Parameters Table

function par = parameters()
    % Calculation parameters
    par.N = 100;           % Number of points to perform the simulation for
    par.N2 = 3;             % Number of loops to be performed for optimisation

    % Parameters
    par.T = 300;
    par.A = 1;

    %% Optimisation Variables
    % PVK PAL thicknesses (nm)
    par.thick1Min = 100;
    par.thick1Max = 800;

    % Si n-type thicknesses (um)
    par.thick2nMin = 100;
    par.thick2nMax = 300;

    % Si p-type thicknesses (um)
    par.thick2pMin = 100;
    par.thick2pMax = 300;

    % Si doping concentrations (cm-3)
    par.NdMin = 1e14;
    par.NdMax = 1e16;
    par.NaMin = 1e18;
    par.NaMax = 1e20;

    % Cost
    par.baselineCost = 0.01;            % Production cost per area (£/cm2)
    par.PVKCost = 10;                   % PVK cost per thickness per area (£/cm3)
    par.SiCost = 0.2;                   % Si cost per thickness per area (£/cm3)

    %% Cell 1 (Top - PVK)
    par.thick1 = 800;                   % PAL thickness (nm)
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

    %% Cell 2 (Bottom - Si)
    par.thick2n = 150;                  % (um)
    par.thick2p = 0.5;
    par.Rs2 = 1e-3;
    par.Rsh2 = 1e5;
    par.ni2 = 1e10;
    par.Nd2 = 1e15;                     % (cm-3)
    par.Na2 = 1e20;
    par.Dn2 = 38.7;
    par.Dp2 = 11.61;
    par.tn2 = 30e-6;
    par.tp2 = 30e-6;
    par.Ln2 = sqrt(par.Dn2*par.tn2);
    par.Lp2 = sqrt(par.Dp2*par.tp2);
    par.Sfront = 5;                     % (cm s-1)
    par.Srear = 10;
    par.beta2 = 0;
    par.eps2 = 11.7 * 8.854e-14;        % (F cm-2)
    par.Eg2 = 1.12;

    %% Constants
    par.q = 1.602e-19;
    par.k = 1.38e-23;
    par.h = 4.136e-15;          % (eV s)
    par.c = 2.998e8;            % (m s-1)
    par.eps0 = 8.854e-12;       % (F m-1)
end