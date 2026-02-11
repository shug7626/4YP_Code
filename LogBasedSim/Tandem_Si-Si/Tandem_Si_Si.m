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


