% Code to simulate two parasitic cells in tandem to produce the J-V
% relation

% Data from https://doi.org/10.1002/solr.202100311
% Cell 1 - Silicon
% Cell 2 - PVK

% Parameters
Rs1 = 1;        % Series resistance (Ohm/cm2)
Rs2 = 3;
Rsh1 = 10e3;    % Shunt (parallel) resistance (Ohm/cm2)
Rsh2 = 1e3;
J01 = 2e-12;    % A/cm2
J02 = 1e-15;
N1 = 1.2;       % Ideality factor
N2 = 1.4;
A = 1;          % Area (cm2)
T = 300;        % Temperature (Kelvin)
n = 100;        % Number of points to calculate

% Constants
q = 1.602e-19;  % Charge of an electron (C)
k_B = 1.38e-23; % Boltzmann constant (J/K)

% Variables
V = zeros(0, n);
V1 = zeros(0, n);
V2 = zeros(0, n);
J = zeros(0, n);


%% Constants Calculation
Rs = Rs1 + Rs2;
Vt = k_B * T/q;