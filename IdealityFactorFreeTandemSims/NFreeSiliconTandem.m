% Code to simulate two semiconductor-based cells in tandem, considering
% parasitic resistances (shunt and series) and using modifiable material
% properties

% Cell 1 - Silicon
% Cell 2 - Silicon

% Parameters
params.A = 1;           % Area (cm2)
T = 300;                % Temperature (Kelvin)

% Cell 1
Rs1 = 0;             % Series resistance (Ohm/cm2) (=5e-3)
params.Rsh1 = Inf;      % Shunt (parallel) resistance (Ohm/cm2) (=1e2)
params.Voc1 = 0.654;    % Open circuit voltage (V)
params.Jsc1 = 38.1;     % (=12.33)
ni1 = 0;                % Intrinsic carrier concentration (cm-3)
n1 = 0;                 % Electron concentration (cm-3)
p1 = 0;
Dn1 = 0;                % Electron diffusion coefficient
Dp1 = 0;
Ln1 = 0;                % Electron diffusion length (cm)
Lp1 = 0;
Na1 = 0;                % Acceptor doping concentration (cm-3)
Nd1 = 0;
wn1 = 0;                % Width of n region (cm)
wp1 = 0;
tn1 = 0;                % Electron lifetime (s)
tp1 = 0;
beta1 = 0;              % Bimolecular recombination rate (m3/s)

% Cell 2
Rs2 = 0;
params.Rsh2 = Inf;
params.Voc2 = 0.654;
params.Jsc2 = 38.1;     % (=13.03)
ni2 = 0;                % Intrinsic carrier concentration (cm-3)
n2 = 0;                 % Electron concentration (cm-3)
p2 = 0;
Dn2 = 0;                % Electron diffusion coefficient
Dp2 = 0;
Ln2 = 0;                % Electron diffusion length (cm)
Lp2 = 0;
Na2 = 0;                % Acceptor doping concentration (cm-3)
Nd2 = 0;
wn2 = 0;                % Width of n region (cm)
wp2 = 0;
tn2 = 0;                % Electron lifetime (s)
tp2 = 0;
beta2 = 0;              % Bimolecular recombination rate (m3/s)



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



%% Constants Calculation
% Combine the series resistances
params.Rs = Rs1 + Rs2;

% Calculate the thermal voltage
params.Vt = k_B * T/q;

% Calculate the diffusion, recombination, and radiative recombination
% currents
params.J_diff01 = q * ni1^2 * ((Dn1/(Na1*Ln1)) + (Dp1/(Nd1*Lp1)));
params.J_diff02 = q * ni2^2 * ((Dn2/(Na2*Ln2)) + (Dp2/(Nd2*Lp2)));

params.J_scr01 = q * ni1 * (wn1 + wp1) / sqrt(tn1 * tp1);
params.J_scr02 = q * ni2 * (wn2 + wp2) / sqrt(tn2 * tp2);

params.J_rad01 = beta1 * (n1*p1 - ni1^2);
params.J_rad02 = beta2 * (n2*p2 - ni2^2);


