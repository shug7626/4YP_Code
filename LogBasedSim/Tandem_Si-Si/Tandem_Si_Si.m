% Code based on the log form of the three diode model, with series and
% shunt resistors for a tandem semiconductor cell

% Cell 1 - Silicon
% Cell 2 - Silicon

% Units as in the Parameters Table
% Calculation parameters
N = 1000;        % Number of points to perform the calculation on

% Parameters
T = 300;
params.A = 1;

% Cell 1
Jsc1 = 38.1;
params.Rs1 = 1e-2;
params.Rsh1 = 1e4;
ni1 = 1.45e10;
Nd1 = 5e16;
Na1 = 1.5e15;
n1 = 1.4e5;
p1 = 1.5e15;
Dn1 = 38.7;
Dp1 = 11.61;
tn1 = 1000e-6;
tp1 = 1000e-6;
Ln1 = sqrt(Dn1*tn1);
Lp1 = sqrt(Dp1*tp1);
beta1 = 0;
eps1 = 11.7 * 8.854e-14;

% Cell 2
Jsc2 = 38.1;
params.Rs2 = 1e-2;
params.Rsh2 = 1e4;
ni2 = 1.45e10;
Nd2 = 5e16;
Na2 = 1.5e15;
n2 = 1.4e5;
p2 = 1.5e15;
Dn2 = 38.7;
Dp2 = 11.61;
tn2 = 1000e-6;
tp2 = 1000e-6;
Ln2 = sqrt(Dn2*tn2);
Lp2 = sqrt(Dp2*tp2);
beta2 = 0;
eps2 = 11.7 * 8.854e-14;

% Constants
q = 1.602e-19;
k = 1.38e-23;



%% Diode Constant Calculations
% Thermal voltage
params.VT = k*T/q;

% Built in voltage
params.Vbi1 = params.VT * log(Na1 * Nd1 / (ni1 ^ 2));
params.Vbi2 = params.VT * log(Na2 * Nd2 / (ni2 ^ 2));

% Diffusion current constant
Jdiff01 = q * (ni1^2) * ((Dn1 / (Na1 * Ln1)) + (Dp1 / (Nd1 * Lp1)));
params.Jdiffd1 = q * Nd1 * Na1 * ((Dn1 / (Na1 * Ln1)) + (Dp1 / (Nd1 * Lp1)));
Jdiff02 = q * (ni2^2) * ((Dn2 / (Na2 * Ln2)) + (Dp2 / (Nd2 * Lp2)));
params.Jdiffd2 = q * Nd2 * Na2 * ((Dn2 / (Na2 * Ln2)) + (Dp2 / (Nd2 * Lp2)));

% Radiative recombination current constant
Jrad01 = beta1 * ((n1 * p1) - (ni1 ^ 2));
params.Jradd1 = beta1 * ((n1 * p1 * exp(params.Vbi1/params.VT)) - (Nd1 * Na1));
Jrad02 = beta2 * ((n2 * p2) - (ni2 ^ 2));
params.Jradd2 = beta2 * ((n2 * p2 * exp(params.Vbi2/params.VT)) - (Nd2 * Na2));

% Recombination in the depletion region (SCR) current constant
Jscr01 = (ni1 ^ 2) * sqrt(2 * q * eps1 * ((1/Na1) + (1/Nd1)) * params.Vbi1 / (tn1 * tp1));
params.Jscrd1 = Nd1 * Na1 * sqrt(2 * q * eps1 * ((1/Na1) + (1/Nd1)) * params.Vbi1 / (tn1 * tp1)) ...
    * exp(-params.Vbi1 / (2 * params.VT));
Jscr02 = (ni2 ^ 2) * sqrt(2 * q * eps2 * ((1/Na2) + (1/Nd2)) * params.Vbi2 / (tn2 * tp2));
params.Jscrd2 = Nd2 * Na2 * sqrt(2 * q * eps2 * ((1/Na2) + (1/Nd2)) * params.Vbi2 / (tn2 * tp2)) ...
    * exp(-params.Vbi2 / (2 * params.VT));

% Illumination current
params.Jillum1 = Jsc1 + Jdiff01 + Jrad01 + Jscr01;
params.Jillum2 = Jsc2 + Jdiff02 + Jrad02 + Jscr02;



%% Calculate the open circuit voltage of the cell
% Set fsolve to not display each calculation
options = optimoptions('fsolve', 'Display', 'none');

% Set initial guess for Voc
v01 = 0.5;
v02 = 0.5;
v0 = [v01, v02];

% Find where the total current is zero
func = @(v) evaluate_tandem_si_si_Voc(v, params);
Voc_sol = fsolve(func, v0, options);
Voc1 = Voc_sol(1);
Voc2 = Voc_sol(2);



