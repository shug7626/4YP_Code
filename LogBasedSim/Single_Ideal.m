% Code based on the log form of the three diode model

% Units as in the Parameters Table
% Parameters
T = 300;

% Cell Properties
Jsc = 38.1;
ni = 1e10;
Nd = 2e17;
Na = 1e17;
n = 2e17;
p = 1e17;
Dn = 0;
Dp = 0;
Ln = 1;
Lp = 1;
tn = 1e-3;
tp = 1e-3;
beta = 0;
eps = 1;

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


