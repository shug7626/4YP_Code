% Code to simulate two semiconductor-based cells in tandem, considering
% parasitic resistances (shunt and series) and using modifiable material
% properties

% Cell 1 - Silicon
% Cell 2 - Silicon

% Parameters
Rs1 = 0;             % Series resistance (Ohm/cm2) (=5e-3)
Rs2 = 0;
params.Rsh1 = Inf;      % Shunt (parallel) resistance (Ohm/cm2) (=1e2)
params.Rsh2 = Inf;
params.Voc1 = 0.654;    % Open circuit voltage (V)
params.Voc2 = 0.654;
params.A = 1;           % Area (cm2)
ni = 0;                 % Intrinsic carrier concentration (cm-3)
n = 0;                  % Electron concentration (cm-3)
p = 0;
Dn = 0;                 % Electron diffusion coefficient
Dp = 0;
Ln = 0;                 % Electron diffusion length (cm)
Lp = 0;
Na = 0;                 % Acceptor doping concentration (cm-3)
Nd = 0;
wn = 0;                 % Width of n region (cm)
wp = 0;
tn = 0;                 % Electron lifetime (s)
tp = 0;
beta = 0;               % Bimolecular recombination rate (m3/s)


T = 300;        % Temperature (Kelvin)


% Display parameters for modifying the range of voltage
N = 100;                % Number of points to calculate
V_dispadj = 0.003;      % Small change to the voltage for display purposes
V_calc = params.Voc1 + params.Voc2 + V_dispadj;


% Constants
q = 1.602e-19;      % Charge of an electron (C)
kB = 1.38e-23;     % Boltzmann constant (J/K)


% Variables
V = linspace(0, V_calc, N);
V1 = zeros(size(V));
V2 = zeros(size(V));
J = zeros(1, N);



