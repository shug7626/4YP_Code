% Parameters (poly-Si from Green et al., 2001)
J_sc = 38.1;    % Short circuit current density (=38.1 for poly-Si)(mA/cm2)
V_oc = 0.654;   % Open circuit voltage (=0.654 for poly_Si)(V)
A = 1;          % Area
R_s = 1e-3;        % Series resistance (Ohm)
R_sh = Inf;     % Parallel (shunt) resistance (Ohm)
T = 300;        % Temperature (K)
n = 100;        % Number of voltages to calculate for

% Constants
q = 1.602e-19;  % Charge of an electron (C)
k_B = 1.38e-23; % Boltzmann constant (J/K)

% Variables
V = linspace(0, V_oc, n);
J = zeros(1, n);


%% Current Density Calculation
% Using the expression for J_0 from the ideal case
J_0 = J_sc * (exp((V_oc * q)/(k_B * T)) - 1)^-1;

% Define the function to calculate the current
J_guess = 30;
options = optimoptions('fsolve', 'Display', 'none');
for i = 1:n
    fun = @(J_temp)evaluate_J(J_temp, J_sc, J_0, V(i), A, R_s, R_sh, q, k_B, T);
    J(i) = fsolve(fun, J_guess, options);
end

plot(V, J);