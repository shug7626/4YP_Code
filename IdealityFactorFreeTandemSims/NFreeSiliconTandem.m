% Code to simulate two semiconductor-based cells in tandem, considering
% parasitic resistances (shunt and series) and using modifiable material
% properties

% Cell 1 - Silicon
% Cell 2 - Silicon

% Data from https://doi.org/10.1016/j.matpr.2021.11.092

% Parameters
params.A = 1;           % Area (cm2)
T = 300;                % Temperature (Kelvin)

% Cell 1
Rs1 = 0;                % Series resistance (Ohm/cm2) (=5e-3)
params.Rsh1 = Inf;      % Shunt (parallel) resistance (Ohm/cm2) (=1e2)
params.Jsc1 = 38.1;     % (=12.33)
ni1 = 1e10;             % Intrinsic carrier concentration (cm-3)
n1 = 2e17;              % Electron concentration (cm-3)
p1 = 1e17;
Dn1 = 0;                % Electron diffusion coefficient
Dp1 = 0;
Ln1 = 1;                % Electron diffusion length (cm)
Lp1 = 1;
Na1 = 1;                % Acceptor doping concentration (cm-3)
Nd1 = 1;
wn1 = 150e-6;           % Width of n region (cm)
wp1 = 150e-6;
tn1 = 1e-3;             % Electron lifetime (s)
tp1 = 1e-3;
beta1 = 0;              % Bimolecular recombination rate (m3/s)

% Cell 2
Rs2 = 0;
params.Rsh2 = Inf;
params.Jsc2 = 38.1;     % (=13.03)
ni2 = 1e10;             % Intrinsic carrier concentration (cm-3)
n2 = 2e17;              % Electron concentration (cm-3)
p2 = 1e17;
Dn2 = 0;                % Electron diffusion coefficient
Dp2 = 0;
Ln2 = 1;                % Electron diffusion length (cm)
Lp2 = 1;
Na2 = 1;                % Acceptor doping concentration (cm-3)
Nd2 = 1;
wn2 = 150e-6;           % Width of n region (cm)
wp2 = 150e-6;
tn2 = 1e-3;             % Electron lifetime (s)
tp2 = 1e-3;
beta2 = 0;              % Bimolecular recombination rate (m3/s)

% Display parameters for modifying the range of voltage
N = 100;                % Number of points to calculate
V_dispadj = 0.003;      % Small change to the voltage for display purposes

% Constants
q = 1.602e-19;      % Charge of an electron (C)
kB = 1.38e-23;     % Boltzmann constant (J/K)



%% Display Settings
% Display J-V curves (figure 1)
disp_jv = true;



%% Constants Calculation
% Combine the series resistances into one variable
params.Rs = Rs1 + Rs2;

% Calculate the thermal voltage
params.Vt = kB * T/q;

% Calculate the diffusion, recombination, and radiative recombination
% currents
params.J_diff01 = q * ni1^2 * ((Dn1/(Na1*Ln1)) + (Dp1/(Nd1*Lp1)));
params.J_diff02 = q * ni2^2 * ((Dn2/(Na2*Ln2)) + (Dp2/(Nd2*Lp2)));

params.J_scr01 = q * ni1 * (wn1 + wp1) / sqrt(tn1 * tp1);
params.J_scr02 = q * ni2 * (wn2 + wp2) / sqrt(tn2 * tp2);

params.J_rad01 = beta1 * (n1*p1 - ni1^2);
params.J_rad02 = beta2 * (n2*p2 - ni2^2);



%% Calculate the Open Circuit Voltages of the two cells
% Set the fsolve options to not display
options = optimoptions('fsolve', 'Display', 'none');

% Set initial guesses for the voltages
v1_0 = 0.5;
v2_0 = 0.5;
v0 = [v1_0, v2_0];

% Find the point where the total cell current is zero
func = @(v) evaluate_NFree_Voc(v, params);
v_sol = fsolve(func, v0, options);
params.Voc1 = v_sol(1);
params.Voc2 = v_sol(2);

% Voltage range to perform the calculations over
V_calc = params.Voc1 + params.Voc2 + V_dispadj;



%% Variables to store the voltages and current density
V = linspace(0, V_calc, N);
V1 = zeros(size(V));
V2 = zeros(size(V));
J = zeros(size(V));



%% Calculate J, V1, V2
% Set initial guesses for the current density and voltages
J_guess = (params.Jsc1 + params.Jsc2) / 4;
V1_guess = params.Voc1;
V2_guess = params.Voc2;
x0 = [J_guess, V1_guess, V2_guess];

% Loop through the bias voltages to calculate for
for iter = 1:N
    fun = @(x)evaluate_NFree_tandem(x, V(iter), params);
    x_solution = fsolve(fun, x0, options);
    
    % Unpack
    J(iter) = x_solution(1);
    V1(iter) = x_solution(2);
    V2(iter) = x_solution(3);
end



%% Calculate Contribution of Each Cell to the Series Voltage
% Cell 1 series voltage
V1s = -params.A * Rs1 * J;

% Cell 2 series voltage
V2s = -params.A * Rs2 * J;

% Total contributions
V1T = V1 + V1s;
V2T = V2 + V2s;



%% Plot Results
if disp_jv
    figure(1);
    tiledlayout(1,3);

    % Plot the total current density - voltage
    ax1 = nexttile;
    plot(V, J);
    xline(0);
    yline(0);
    xlabel('Bias Voltage (V)');
    ylabel('Current Density (mA/cm2)');
    title('Tandem Cell Current Density - Voltage Plot');

    % Plot Cell 1 contribution
    ax2 = nexttile;
    plot(V1, J);
    xline(0);
    yline(0);
    xlabel('Cell 1 Voltage (V)');
    ylabel('Current Density (mA/cm2)');
    title('Cell 1 Current Density - Voltage Plot');

    % Plot Cell 2 contribution
    ax3 = nexttile;
    plot(V2, J);
    xline(0);
    yline(0);
    xlabel('Cell 2 Voltage (V)');
    ylabel('Current Density (mA/cm2)');
    title('Cell 2 Current Density - Voltage Plot');

    % Set Y axis equal
    linkaxes([ax1, ax2, ax3], 'y');
end
