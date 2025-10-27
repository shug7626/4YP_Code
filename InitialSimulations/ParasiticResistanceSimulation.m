% Simulation of a non-ideal pv, with parasitic resistances

% Parameters (poly-Si from Green et al., 2001)
J_sc = 38.1;    % Short circuit current density (=38.1 for poly-Si)(mA/cm2)
V_oc = 0.654;   % Open circuit voltage (=0.654 for poly_Si)(V)
A = 1;          % Area (cm2)
R_s = [0, 2e-3, 5e-3, 1e-2];        % Series resistance (Ohm)
R_sh = [Inf, 1e-1, 5e-2, 3e-2];     % Parallel (shunt) resistance (Ohm)
T = 300;        % Temperature (K)
n = 100;        % Number of points to calculate for

V_dispadj = 0.003;      % Small change to the voltage for display purposes

% Constants
q = 1.602e-19;  % Charge of an electron (C)
k_B = 1.38e-23; % Boltzmann constant (J/K)

% Variables
V = linspace(0, (V_oc + V_dispadj), n);
J = zeros((length(R_s) + length(R_sh)), n);
P = zeros(size(J));



%% Current Density Calculation
% Using the expression for J_0 from the ideal case
J_0 = J_sc * (exp((V_oc * q)/(k_B * T)) - 1)^-1;

% Use fsolve to find J in the various series resistor values
J_guess = J_sc/2;
options = optimoptions('fsolve', 'Display', 'none');
for i = 1:length(R_s)
    for j = 1:n
        fun = @(J_temp)evaluate_J(J_temp, J_sc, J_0, V(j), A, R_s(i), R_sh(1), q, k_B, T);
        J(i, j) = fsolve(fun, J_guess, options);
    end
end

% Use fsolve to find J in the various shunt resistor values
for i = 1:length(R_sh)
    for j = 1:n
        fun = @(J_temp)evaluate_J(J_temp, J_sc, J_0, V(j), A, R_s(1), R_sh(i), q, k_B, T);
        J((i + length(R_s)), j) = fsolve(fun, J_guess, options);
    end
end



%% Power Calculations
P = J .* V;



%% Plot Results
tiledlayout(2, 2);
ax1_1 = nexttile;
hold on
for i = 1:length(R_s)
    plot(V, J(i, :));
end
xlabel('Bias Voltage (V)');
ylabel('Current Density (mA/cm2)');
title('Current Density vs Bias Voltage for a Variety of Series Resistances');
xline(0);
yline(0);
hold off

ax1_2 = nexttile;
hold on
for i = 1:length(R_sh)
    plot(V, J((i + length(R_s)), :));
end
xlabel('Bias Voltage (V)');
ylabel('Current Density (mA/cm2)');
title('Current Density vs Bias Voltage for a Variety of Shunt Resistances');
xline(0);
yline(0);
hold off

% Set the Y-axes of the two current densities to be the same
linkaxes([ax1_1, ax1_2], 'y');

ax2_1 = nexttile;
hold on
for i = 1:length(R_s)
    plot(V, P((i), :));
end
xlabel('Bias Voltage (V)');
ylabel('Power Density (mW/cm2)');
title('Power Density vs Bias Voltage for a Variety of Series Resistances');
xline(0);
yline(0);
hold off

ax2_2 = nexttile;
hold on
for i = 1:length(R_sh)
    plot(V, P((i + length(R_s)), :));
end
xlabel('Bias Voltage (V)');
ylabel('Power Density (mW/cm2)');
title('Power Density vs Bias Voltage for a Variety of Shunt Resistances');
xline(0);
yline(0);
hold off

% Set the Y-axes of the two power densities to be the same
linkaxes([ax2_1, ax2_2], 'y');