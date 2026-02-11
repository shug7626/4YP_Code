% Code based on the log form of the three diode model, with series and
% shunt resistors

% Units as in the Parameters Table
% Calculation parameters
N = 100;        % Number of points to perform the calculation on

% Parameters
T = 300;

Jsc = 38.1;
params.Rs = 0;
params.Rsh = Inf;
ni = 1.45e10;
Nd = 5e16;
Na = 1.5e15;
n = 1.4e5;
p = 1.5e15;
Dn = 38.7;
Dp = 11.61;
tn = 1000e-6;
tp = 1000e-6;
Ln = sqrt(Dn*tn);
Lp = sqrt(Dp*tp);
beta = 0;
eps = 11.7 * 8.854e-14;

% Constants
q = 1.602e-19;
k = 1.38e-23;



%% Diode Constant Calculations
% Thermal voltage
params.VT = k*T/q;

% Built in voltage
params.Vbi = params.VT * log(Na * Nd / (ni ^ 2));

% Diffusion current constant
Jdiff0 = q * (ni^2) * ((Dn / (Na * Ln)) + (Dp / (Nd * Lp)));
params.Jdiffd = q * Nd * Na * ((Dn / (Na * Ln)) + (Dp / (Nd * Lp)));

% Radiative recombination current constant
Jrad0 = beta * ((n * p) - (ni ^ 2));
params.Jradd = beta * ((n * p * exp(params.Vbi/params.VT)) - (Nd * Na));

% Recombination in the depletion region (SCR) current constant
Jscr0 = (ni ^ 2) * sqrt(2 * q * eps * ((1/Na) + (1/Nd)) * params.Vbi / (tn * tp));
params.Jscrd = Nd * Na * sqrt(2 * q * eps * ((1/Na) + (1/Nd)) * params.Vbi / (tn * tp)) ...
    * exp(-params.Vbi / (2 * params.VT));

% Illumination current
params.Jillum = Jsc + Jdiff0 + Jrad0 + Jscr0;



