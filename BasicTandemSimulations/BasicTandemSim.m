% Code to simulate two parasitic cells in tandem to produce the J-V
% relation

% Data from https://doi.org/10.1002/solr.202100311
% Cell 1 - Silicon
% Cell 2 - PVK

% Parameters
Rs1 = 5e-3;        % Series resistance (Ohm/cm2) (=1)
Rs2 = 5e-3;        % (=3)
params.Rsh1 = 1e3;     % Shunt (parallel) resistance (Ohm/cm2) (=10e3)
params.Rsh2 = 1e3;      % (=1e3)
params.J01 = 1e-10;    % A/cm2 (=2e-12)
params.J02 = 1e-10;    % (=1e-15)
params.Voc1 = 0.654;   % Open circuit voltage (V) (=0.72)
params.Voc2 = 0.654;   % (=1.11)
params.N1 = 1.0;       % Ideality factor (=1.2)
params.N2 = 1.0;       % (=1.4)
params.A = 1;          % Area (cm2)
T = 300;        % Temperature (Kelvin)
n = 100;        % Number of points to calculate

V_dispadj = 0.003;      % Small change to the voltage for display purposes
V_calc = params.Voc1 + params.Voc2 + V_dispadj;

% Constants
q = 1.602e-19;  % Charge of an electron (C)
k_B = 1.38e-23; % Boltzmann constant (J/K)

% Variables
V = linspace(0, V_calc, n);
V1 = zeros(size(V));
V2 = zeros(size(V));
J = zeros(0, n);


%% Constants Calculation
params.Rs = Rs1 + Rs2;
params.Vt = k_B * T/q;

params.Jsc1 = params.J01 * (exp(params.Voc1/(params.Vt * params.N1)) - 1);
params.Jsc2 = params.J02 * (exp(params.Voc2/(params.Vt * params.N2)) - 1);
% params.Jsc1 = 38.1;        % (=12.33)
% params.Jsc2 = 38.1;        % (=13.03)

%% J, V1, V2 Calculations
options = optimoptions('fsolve', 'Display', 'none');

% Set initial guesses
J_guess = (params.Jsc1 + params.Jsc2)/4;
V1_guess = params.Voc1;
V2_guess = params.Voc2;
x0 = [J_guess, V1_guess, V2_guess];

for i = 1:n
    fun = @(x)evaluate_tandem_J(x, V(i), params);
    x_sol = fsolve(fun, x0, options);
    J(i) = x_sol(1);
    V1(i) = x_sol(2);
    V2(i) = x_sol(3);
end


%% Calculate Contribution of Each Cell to the Series Voltage
% Cell 1 series voltages
V1s = params.A * Rs1 * J;

% Cell 2 series voltages
V2s = params.A * Rs2 * J;

Vs = V1s + V2s;

% Set the cell voltages
V1T = V1 - V1s;
V2T = V2 - V2s;


%% Plot
figure(1);
tiledlayout(1, 3);

% Plot total current density output
ax1 = nexttile;
plot(V, J);
xlabel('Bias Volatge (V)');
ylabel('Current Density (mA/cm2)');
title('System J-V');
xline(0);
yline(0);

% Plot Cell 2 contribution
ax2 = nexttile;
plot(V2T, J);
xlabel('Cell 2 Voltage (V)');
ylabel('J (ma/cm2)');
title('Cell 2 J-V Contribution');
xline(0);
yline(0);
xline(params.Voc2);

% Plot Cell 1 contribution
ax3 = nexttile;
plot(V1T, J);
xlabel('Cell 1 Voltage (V)');
ylabel('J (mA/cm2)');
title('Cell 1 J-V Contribution');
xline(0);
yline(0);
xline(params.Voc1);

% Set Y axis
linkaxes([ax1, ax2, ax3], 'y');


%% Area Plot
% A plot to show the contributions of the various voltages (V1, V2, Vs)
figure(2);
Y = [(V1.') (V2.') (Vs.')];
x = V;
area(x, Y);
xline(params.Voc1 + params.Voc2, 'r');
yline(params.Voc1 + params.Voc2, 'r');
xlabel('Bias Voltage (V)');
ylabel('Voltage Components');
legend({'V1','V2','Vs'});


%% Separate Voltage Plots
figure(3);
tiledlayout(1,3);
ax4 = nexttile;
plot(V, V1);
xlabel('Bias Voltage (V)');
ylabel('V1 (V)');
title('Cell 1 Voltage');
yline(0);

ax5 = nexttile;
plot(V, V2);
xlabel('Bias Voltage (V)');
ylabel('V2 (V)');
title('Cell 2 Voltage');
yline(0);

ax6 = nexttile;
plot(V, Vs);
xlabel('Bias Voltage (V)');
ylabel('Vs (V)');
title('Combined Series Resistor Voltage');
yline(0);

linkaxes([ax4, ax5, ax6], 'y');
