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