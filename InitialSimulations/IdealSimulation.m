% Simulation of an ideal pv, with no parasitic resistances

% Parameters (poly-Si from Green et al., 2001)
J_sc = 38.1;    % Short circuit current density (=38.1 for poly-Si)(mA/cm2)
V_oc = 0.654;   % Open circuit voltage (=0.654 for poly_Si)(V)
T = 300;        % Temperature (K)

% Constants
q = 1.602e-19;  % Charge of an electron (C)
k_B = 1.38e-23; % Boltzmann constant (J/K)

% Variables
V = linspace(0, V_oc, 100);
J = zeros(1, 100);


%% Current Density Calculations
J_0 = J_sc * (exp((V_oc * q)/(k_B * T)) - 1)^-1;
J = J_sc - J_0*(exp((q * V)/(k_B * T)) - 1);


%% Plot
figure;
plot(V, J);
xlabel('Bias Voltage (V)');
ylabel('Current Density (mA/cm2)');