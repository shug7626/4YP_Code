% Simulation of a non-ideal pv, with parasitic resistances

% Parameters (poly-Si from Green et al., 2001)
J_sc = 38.1;    % Short circuit current density (=38.1 for poly-Si)(mA/cm2)
V_oc = 0.654;   % Open circuit voltage (=0.654 for poly_Si)(V)
A = 1;          % Area (cm2)
T = 300;        % Temperature (K)
n = 100;        % Number of voltages to calculate for

% Constants
q = 1.602e-19;  % Charge of an electron (C)
k_B = 1.38e-23; % Boltzmann constant (J/K)
R_s = [0, 1, 2];        % Series resistance (Ohm)
R_sh = [Inf, 1e5, 1e4]; % Parallel (shunt) resistance (Ohm)

% Variables
V = linspace(0, V_oc, n);
J = zeros(length(R_s), n);
P = zeros(1, n);



%% Current Density Calculation
% Using the expression for J_0 from the ideal case
J_0 = J_sc * (exp((V_oc * q)/(k_B * T)) - 1)^-1;

% Current density for the ideal case
J_i = J_sc - J_0*(exp((q * V)/(k_B * T)) - 1);

% Rearanging eq1.11, J = (Ji Rsh - V)/(A Rs + Rsh)
for i = 1:length(R_s)
    J(i,:) = ((J_i * R_sh(i)) - V)./((A * R_s(i)) + R_sh(1));
end