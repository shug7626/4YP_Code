% Simulation of a non-ideal pv, with parasitic resistances
% Ideal shown in blue, non-ideal in red

% Parameters (poly-Si from Green et al., 2001)
J_sc = 38.1;    % Short circuit current density (=38.1 for poly-Si)(mA/cm2)
V_oc = 0.654;   % Open circuit voltage (=0.654 for poly_Si)(V)
A = 1;          % Area (cm2)
R_s = 5e-3;        % Series resistance (Ohm)
R_sh = 5e-2;     % Parallel (shunt) resistance (Ohm)
T = 300;        % Temperature (K)
n = 100;        % Number of points to calculate for

V_dispadj = 0.003;      % Small change to the voltage for display purposes

% Constants
q = 1.602e-19;  % Charge of an electron (C)
k_B = 1.38e-23; % Boltzmann constant (J/K)

% Variables
V = linspace(0, (V_oc + V_dispadj), n);
J = zeros(1, n);
J_ideal = zeros(size(J));
P = zeros(size(J));
P_ideal = zeros(size(J));



%% Current Density Calculation
% Using the expression for J_0 from the ideal case
J_0 = J_sc * (exp((V_oc * q)/(k_B * T)) - 1)^-1;

% Use fsolve to find J in the various series resistor values
J_guess = J_sc/2;
options = optimoptions('fsolve', 'Display', 'none');
for i = 1:n
        fun = @(J_temp)evaluate_J(J_temp, J_sc, J_0, V(i), A, R_s, R_sh, q, k_B, T);
        J(i) = fsolve(fun, J_guess, options);
end

% Ideal solution
J_ideal = J_sc - J_0*(exp((q * V)/(k_B * T)) - 1);


%% Power Calculations
P = J .* V;
P_ideal = J_ideal .* V;


%% Plot Results
figure(1);
tiledlayout(1, 2);
nexttile;

plot(V, J_ideal, 'b');
hold on
plot(V, J, 'r');

xlabel('Bias Voltage (V)');
ylabel('Current Density (mA/cm2)');
title('Current Density vs Bias Voltage for a PV Cell with Parasitic Resistances');
xline(0);
yline(0);
hold off

nexttile;

plot(V, P_ideal, 'b');
hold on
plot(V, P, 'r');

xlabel('Bias Voltage (V)');
ylabel('Power Density (mW/cm2)');
title('Power Density vs Bias Voltage for a PV Cell with Parasitic Resistances');
xline(0);
yline(0);
hold off

