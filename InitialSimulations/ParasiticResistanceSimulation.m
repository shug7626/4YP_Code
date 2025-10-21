% Simulation of a non-ideal pv, with parasitic resistances

% Parameters (poly-Si from Green et al., 2001)
J_sc = 38.1;    % Short circuit current density (=38.1 for poly-Si)(mA/cm2)
V_oc = 0.654;   % Open circuit voltage (=0.654 for poly_Si)(V)
A = 1;          % Area (cm2)
R_s = [0, 1, 2];        % Series resistance (Ohm)
R_s0 = 0;
R_sh = [Inf, 1e5, 1e4]; % Parallel (shunt) resistance (Ohm)
R_sh0 = Inf;
T = 300;        % Temperature (K)
n = 100;        % Number of voltages to calculate for

% Constants
q = 1.602e-19;  % Charge of an electron (C)
k_B = 1.38e-23; % Boltzmann constant (J/K)

% Variables
V = linspace(0, V_oc, n);
J_s = zeros(length(R_s), n);
J_sh = zeros(length(R_sh), n);
P = zeros(1, n);



%% Current Density Calculation
% Using the expression for J_0 from the ideal case
J_0 = J_sc * (exp((V_oc * q)/(k_B * T)) - 1)^-1;

% Using fsolve to find J in the various series resistor values
i = 1;
fun = @(J_s)calculate_Js(J_s, J_sc, J_0, V, A, R_s, R_sh0, q, k_B, T, i);
J0 = 35;
J_s = fsolve(fun, J0);