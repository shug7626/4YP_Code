% Code to simulate two parasitic cells in tandem to produce the J-V
% relation

% Data from https://doi.org/10.1002/solr.202100311
% Cell 1 - Silicon
% Cell 2 - PVK

% Parameters
Rs1 = 5e-3;        % Series resistance (Ohm/cm2) (=1)
Rs2 = 5e-3;        % (=3)
params.Rsh1 = 1e2;     % Shunt (parallel) resistance (Ohm/cm2) (=10e3)
params.Rsh2 = 1e2;      % (=1e3)
params.J01 = 1e-10;    % A/cm2 (=2e-12)
params.J02 = 1e-10;    % (=1e-15)
params.Voc1 = 0.654;   % Open circuit voltage (V) (=0.72)
params.Voc2 = 0.654;   % (=1.11)
params.A = 1;          % Area (cm2)
T = 300;        % Temperature (Kelvin)
n = 100;        % Number of points to calculate

% Variables to change in the surface plot
N1 = linspace(1, 2, n);       % Ideality factor (=1.2)
N2 = linspace(1, 2, n);       % (=1.4)

V_dispadj = 0.003;      % Small change to the voltage for display purposes
V_calc = params.Voc1 + params.Voc2 + V_dispadj;

% Constants
q = 1.602e-19;  % Charge of an electron (C)
k_B = 1.38e-23; % Boltzmann constant (J/K)

% Variables
V = linspace(0, V_calc, n);
V1 = zeros(n);
V2 = zeros(n);
J = zeros(n);


%% Constants and J, V1, V2 Calculation
params.Rs = Rs1 + Rs2;
params.Vt = k_B * T/q;
options = optimoptions('fsolve', 'Display', 'none');

% Vary the ideality factors separately
for j = 1:length(N1)
    params.N1 = N1(j);
    for k = 1:length(N2)
        params.N2 = N2(k);
        params.Jsc1 = params.J01 * (exp(params.Voc1/(params.Vt * params.N1)) - 1);
        params.Jsc2 = params.J02 * (exp(params.Voc2/(params.Vt * params.N2)) - 1);

        % Set initial guesses
        J_guess = (params.Jsc1 + params.Jsc2)/4;
        V1_guess = params.Voc1;
        V2_guess = params.Voc2;
        x0 = [J_guess, V1_guess, V2_guess];

        % Calculate the maximum current density and separate voltages
        fun = @(x)evaluate_tandem_J(x, V(1), params);
        x_sol = fsolve(fun, x0, options);
        J(j, k) = x_sol(1);
        V1(j, k) = x_sol(2);
        V2(j, k) = x_sol(3);
    end
end


%% Calculate Contribution of Each Cell to the Series Voltage
% % Cell 1 series voltages
% V1s = -params.A * Rs1 * J;
% 
% % Cell 2 series voltages
% V2s = -params.A * Rs2 * J;
% 
% Vs = V1s + V2s;
% 
% % Set the cell voltages
% V1T = V1 + V1s;
% V2T = V2 + V2s;


%% Plot
figure(4);
surf(N1, N2, J);
xlabel('N1');
ylabel('N2');
zlabel('J (mA/cm2) @ V=0');

