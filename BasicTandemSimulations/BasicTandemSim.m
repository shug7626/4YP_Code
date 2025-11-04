% Code to simulate two parasitic cells in tandem to produce the J-V
% relation

% Data from https://doi.org/10.1002/solr.202100311
% Cell 1 - Silicon
% Cell 2 - PVK

% Parameters
Rs1 = 1;        % Series resistance (Ohm/cm2)
Rs2 = 3;
params.Rsh1 = 10e3;    % Shunt (parallel) resistance (Ohm/cm2)
params.Rsh2 = 1e3;
params.J01 = 2e-12;    % A/cm2
params.J02 = 1e-15;
params.Voc1 = 0.654;   % Open circuit voltage (V)
params.Voc2 = 1.075;
params.N1 = 1.2;       % Ideality factor
params.N2 = 1.4;
params.A = 1;          % Area (cm2)
T = 300;        % Temperature (Kelvin)
n = 100;        % Number of points to calculate

% Constants
q = 1.602e-19;  % Charge of an electron (C)
k_B = 1.38e-23; % Boltzmann constant (J/K)

% Variables
V = linspace(0, params.Voc1 + params.Voc2, n);
V1 = zeros(size(V));
V2 = zeros(size(V));
J = zeros(0, n);


%% Constants Calculation
params.Rs = Rs1 + Rs2;
params.Vt = k_B * T/q;

params.Jsc1 = params.J01 * (exp(params.Voc1/params.Vt) - 1);
params.Jsc2 = params.J02 * (exp(params.Voc2/params.Vt) - 1);


%% Calculations
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


%% Plot
plot(V, J);
xlabel('Bias Volatge (V)');
ylabel('Current Density (mA/cm2)');