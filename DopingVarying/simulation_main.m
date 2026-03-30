% Script to simulate a PVK-Si tandem cell

%% Fetch the Parameters
par = parameters();

% Set the numerical solver settings
options = optimoptions('fsolve', ...
    'Display', 'none', ...
    'FunctionTolerance', 1e-16, ...
    'OptimalityTolerance', 1e-16, ...
    'StepTolerance', 1e-16);

powOptions = optimoptions('fmincon', ...
    'StepTolerance', 1e-10, ...
    'OptimalityTolerance', 1e-10, ...
    'Display', 'iter', ...
    'UseParallel', true);



%% Calculate the Constants
% Calculate the thermal voltage
par.VT = par.k*par.T/par.q;

% Calculate the built in voltage of the silicon
res.Vbi2 = par.VT * log(par.Na2 * par.Nd2 / (par.ni2 ^ 2));

% Calculate the silicon depletion region width
res.W2 = sqrt(2 * par.eps2 * res.Vbi2 * ((1/par.Na2) + (1/par.Nd2)) / par.q);         % (cm)

% Calculate the short circuit current densities
res = Methods.calculate_Jsc(par, res, par.thick1);

% Calculate the silicon constants
res = Methods.calculate_silicon_const(par.Na2, par.Nd2, par, res);

% Calculate the PVK constants
res = Methods.calculate_pvk_const(par.thick1, res, par, options);



%% Set the Range of Values to Calculate the Voltages for
J_negative = logspace(-4, log10(min([res.Jsc1 res.Jsc2])), par.N);
J = min([res.Jsc1 res.Jsc2]) - J_negative;
V1 = zeros(size(J));
V2 = zeros(size(J));
V = zeros(size(J));
v_s = zeros(size(J));



%% Calculate V, V1, V2, Vs for a given J
% Calculate constants to be used in the initial guesses
n_estimate = 1.1;
jd01 = res.Jsc1 / exp((res.Voc1 - res.Vbi1) / (n_estimate * par.VT));
jd02 = res.Jsc2 / exp((res.Voc2 - res.Vbi2) / (n_estimate * par.VT));

% Loop throught J to calculate the voltages
parfor iter = 2:par.N
    % Set the initial guesses
    v01 = res.Vbi1 + (n_estimate * par.VT * log((res.Jsc1 - J(iter))/jd01));
    v02 = res.Vbi2 + (n_estimate * par.VT * log((res.Jsc2 - J(iter))/jd02));

    % Initialise the functions to be used
    pvk_V_func = @(v1) Methods.evaluate_PVK_V(v1, J(iter), par.thick1, par, res, options);
    si_V_func = @(v2) Methods.evaluate_Si_V(v2, J(iter), par, res);

    % Use fzero to solve
    V1(iter) = fzero(pvk_V_func, v01);
    V2(iter) = fzero(si_V_func, v02);

    % Calculate the total cell voltage
    v_s(iter) = -J(iter) * (par.Rs1 + par.Rs2) * par.A;
    V(iter) = V1(iter) + V2(iter) + v_s(iter);
end



%% Add the Voltages at V=0, J=Jsc
if res.Jsc1 == min([res.Jsc1 res.Jsc2])
    % Set the initial guess
    v02 = V2(2);

    % Initialise the function
    si_V_func = @(v2) Methods.evaluate_Si_V(v2, res.Jsc1, par, res);

    % Use fzero to solve
    V2(1) = fzero(si_V_func, v02);
else
    % Set the initial guess
    v01 = V1(2);

    % Initialise the function
    pvk_V_func = @(v1) Methods.evaluate_PVK_V(v1, res.Jsc2, par.thick1, par, res, options);

    % Use fzero to solve
    V1(1) = fzero(pvk_V_func, v01);
end

% Include the series resistances voltage
v_s(1) = -J(1) * (par.Rs1 + par.Rs2) * par.A;

% Calculate the total voltage at Jsc
V(1) = V1(1) + V2(1) + v_s(1);

% Unpack the results
res.V = V;
res.J = J;
res.V1 = V1;
res.V2 = V2;
res.v_s = v_s;



%% Calculate Contribution of Each Cell to the Series Resistor Voltage
% Cell 1 series resistor voltage
res.Vs1 = -res.J * par.A * par.Rs1;

% Cell 2 series resistor voltage
res.Vs2 = -res.J * par.A * par.Rs2;

% Total cell contributions
res.V1T = res.V1 + res.Vs1;
res.V2T = res.V2 + res.Vs2;



%% Calculate the Efficiency
% Incident photon power (converting to (mW cm-2) from (W cm-2))
Pin = sum(res.spectrums.bs .* res.spectrums.E) * par.q * 1e3;
Pout = max(res.J .* res.V);
Efficiency = Pout / Pin * 100;

% Print the efficiency
fprintf('Efficiency: %5.3f%%\n', Efficiency);



%% Plots
% Fetch the settings
set = plot_settings();

% Plot the J_V plots
if set.plot_j_v
    fig1 = Plotting.J_V(res, set);
end

% Plot the voltage area plot
if set.plot_V_area
    fig2 = Plotting.V_Area(res, set);
end

% Plot the voltage - volage plots
if set.plot_v_v
    fig3 = Plotting.V_VBias(res, set);
end

% Plot the P-V plot
if set.plot_p_v
    fig4 = Plotting.P_V(res, set);
end

% Plot the spectrum data
if set.plot_spectrum
    fig5 = Plotting.spectrum(res.spectrums, set, par, res);
end