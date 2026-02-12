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
Rs1 = 1e-3;
params.Rsh1 = 1e6;
ni1 = 1.45e10;
% params.Vbi1 = 0.65;
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
Rs2 = 0;
params.Rsh2 = Inf;
ni2 = 1.45e10;
% params.Vbi2 = 0.65;
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

params.Rs = Rs1 + Rs2;

% Constants
q = 1.602e-19;
k = 1.38e-23;



%% Diode Constant Calculations
% Thermal voltage
params.VT = k*T/q;

% Built in voltage
params.Vbi1 = params.VT * log(Na1 * Nd1 / (ni1 ^ 2));
params.Vbi2 = params.VT * log(Na2 * Nd2 / (ni2 ^ 2));
% ni1 = sqrt(exp(-params.Vbi1 / params.VT) * Na1 * Nd1);
% ni2 = sqrt(exp(-params.Vbi2 / params.VT) * Na2 * Nd2);

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
Jscr01 = ni1 * sqrt(2 * q * eps1 * ((1/Na1) + (1/Nd1)) * params.Vbi1 / (tn1 * tp1));
params.Jscrd1 = sqrt(2 * q * eps1 * (Nd1 + Na1) * params.Vbi1 / (tn1 * tp1));
Jscr02 = ni2 * sqrt(2 * q * eps2 * ((1/Na2) + (1/Nd2)) * params.Vbi2 / (tn2 * tp2));
params.Jscrd2 = sqrt(2 * q * eps2 * (Nd2 + Na2) * params.Vbi2 / (tn2 * tp2));


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



%% Set range of voltages and vectors to store results
V = linspace(0, (Voc1 + Voc2), N);
V1 = zeros(size(V));
V2 = zeros(size(V));
J = zeros(size(V));



%% Calculate J for each V
% Set initial guess
j0 = (Jsc1 + Jsc2) / 2;
v01 = Voc1/2;
v02 = Voc2/2;
x0 = [j0, v01, v02];

for iter = 1:N
    % Solve
    fun = @(x)evaluate_tandem_si_si(x, V(iter), params);
    x_sol = fsolve(fun, x0, options);
    
    % Unpack output
    J(iter) = x_sol(1);
    V1(iter) = x_sol(2);
    V2(iter) = x_sol(3);
end



%% Calculate Contribution of Each Cell to the Series Resistor Voltage
% Cell 1 series resistor voltage
Vs1 = -J * params.A * Rs1;

% Cell 2 series resistor voltage
Vs2 = -J * params.A * Rs2;

% Sum of series resistor voltages
Vs = Vs1 + Vs2;

% Total cell contributions
V1T = V1 + Vs1;
V2T = V2 + Vs2;



%% Plot
% Current - Voltage Plot
figure(1);
tiledlayout(1,3);

ax1 = nexttile;
plot(V,J);
xline(0);
yline(0);
xlabel('Bias Voltage (V)');
ylabel('Current Density (mA/cm2)')
title('Tandem Si-Si Current Density - Voltage Plot');

ax2 = nexttile;
plot(V1T,J);
xline(0);
yline(0);
xlabel('Cell 1 Voltage (V)');
ylabel('Current Density (mA/cm2)');
title('Cell 1 Current Density - Voltage Plot');

ax3 = nexttile;
plot(V2T,J);
xline(0);
yline(0);
xlabel('Cell 2 Voltage (V)');
ylabel('Cell 2 Current Density - Votlage Plot');
title('Cell 2 Current Density - Voltage Plot');

% ax4 = nexttile;
% plot(Vs,J);
% xline(0);
% yline(0);
% xlabel('Series Resistor Voltage (V)');
% ylabel('Series Resistor Current Density - Voltage Plot');
% title('Series Resistors Current Density - Voltage Plot');

linkaxes([ax1, ax2, ax3], 'y');



%% Voltage Area Plot
figure(2);
Y = [(V1T.') (V2T.')];
x = V;
area(x, Y);

% Add a bold line to show the sum
hold on;
V_Total = V1T + V2T;
plot(x, V_Total, 'k-', 'LineWidth', 3);

xline(Voc1 + Voc2, 'r');
yline(Voc1 + Voc2, 'r');
xlabel('Bias Voltage (V)');
ylabel('Voltage Components');
legend({'V1T','V2T','Total Voltage'});



%% Power - Voltage Plot
figure(3);
plot(V, J.*V);
xline(0);
yline(0);
xlabel('Bias Voltage (V)');
ylabel('Power Density (mW/cm2)');
title('Tandem Si-Si Power Density - Voltage Plot');



%% Current Contribution Plot
% figure(4);



