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

    % Cell 1 (PVK)
    par.Rs1 = 1e-4;
    par.Rsh1 = 1e4;
    par.ni1 = 1e10;
    par.Nd1 = 2e20;
    par.Na1 = 3e18;
    par.n1 = par.Nd1;
    par.p1 = par.Na1;
    par.Dn1 = 38.7;
    par.Dp1 = 11.61;
    par.tn1 = 30e-6;
    par.tp1 = 30e-6;
    par.Ln1 = sqrt(par.Dn1*par.tn1);
    par.Lp1 = sqrt(par.Dp1*par.tp1);
    par.beta1 = 0;
    par.eps1 = 11.7 * 8.854e-14;
    par.R1 = 0.05;
    par.a1 = 0.95;
    par.etac1 = 0.95;
    par.Eg1 = 1.7867;         % (eV)

    % Cell 2 (Si)
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
    par.a2 = 0.85;
    par.etac2 = 0.95;
    par.Eg2 = 1.11;
    
    % Total series resistance
    par.Rs = par.Rs1 + par.Rs2;

    % Constants
    par.q = 1.602e-19;
    par.k = 1.38e-23;
    par.h = 4.136e-15;          % (eV s)
    par.c = 2.998e8;            % (m s-1)
end


