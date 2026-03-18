% Main script for simulating a PVK-on-Si tandem cell at steady-state

%% Fetch parameters
par = parameters();



%% Calculate the short circuit current densities based on incident spectrum
% Import the spectrum data
spectrum_table = readmatrix("Spectrum_full.xlsx");
spectrums.wavelengths = spectrum_table(:,1);
spectrums.bs_cumulative = spectrum_table(:,2);      % (photons cm-2 s-1)

% Switch from the cumulative spectrum to the photon flux density
cumulative_spec = 0;
spectrums.bs = zeros(size(spectrums.bs_cumulative));
spectrums.bs(1) = spectrums.bs_cumulative(1);
spectrums.bs(2:end) = spectrums.bs_cumulative(2:end) - spectrums.bs_cumulative(1:end-1);

% Convert the spectrums.wavelengths to photon energies (converting from nm to m)
E = par.h * par.c ./(spectrums.wavelengths / 1e9);  % (eV)

% Find each valid discrete value of energy
par.validE1 = E >= (par.Ec - par.Ev);
par.validE2 = E >= par.Eg2;

% Convert the energy masks to doubles
par.validE1 = double(par.validE1);
par.validE2 = double(par.validE2);

% Add interpolation to the mask
% Find the index of the last suitable energy
indices1 = find(par.validE1);
last1 = indices1(end);
indices2 = find(par.validE2);
last2 = indices2(end);
% Find the fraction between the last full and next photon energy
par.validE1(last1 + 1) = (E(last1) - (par.Ec - par.Ev))/(E(last1) - E(last1 + 1));
par.validE2(last2 + 1) = (E(last2) - par.Eg2)/(E(last2) - E(last2 + 1));

% Create vectors for the reflectivity, absorptivity, and probability
R1 = par.validE1 * par.R1;
R2 = par.validE2 * par.R2;
a1 = par.validE1 * (1 - exp(-par.a1 * par.thick1));
a2 = par.validE2 * (1 - exp(-par.a2 * par.thick2));
etac1 = par.validE1 * par.etac1;
etac2 = par.validE2 * par.etac2;

% Calculate the spectrum seen by cell 2
spectrums.bs2 = (ones(size(R1))-R1) .* (ones(size(R2))-R2) .* (ones(size(a1))-a1) .* spectrums.bs;

% Evaluate Jsc1 and Jsc2
Jsc1 = par.q * sum(etac1 .* (ones(size(R1))-R1) .* a1 .* (spectrums.bs .* par.validE1));  % (A cm-2)
Jsc2 = par.q * sum(etac2 .* (ones(size(R2))-R2) .* a2 .* (spectrums.bs2 .* par.validE2));

% Convert to (mA cm-2)
Jsc1 = Jsc1 * 1e3;
par.Jsc1 = Jsc1;
Jsc2 = Jsc2 * 1e3;



%% Silicon Diode Constant Calculations
% Thermal voltage
par.VT = par.k*par.T/par.q;

% Built in voltage
par.Vbi2 = par.VT * log(par.Na2 * par.Nd2 / (par.ni2 ^ 2));

% Diffusion current constant
Jdiff02 = par.q * (par.ni2^2) * ((par.Dn2 / (par.Na2 * par.Ln2)) + (par.Dp2 / (par.Nd2 * par.Lp2)));
par.Jdiffd2 = par.q * par.Nd2 * par.Na2 * ((par.Dn2 / (par.Na2 * par.Ln2)) + (par.Dp2 / (par.Nd2 * par.Lp2)));

% Radiative recombination current constant
Jrad02 = par.beta2 * ((par.n2 * par.p2) - (par.ni2 ^ 2));
par.Jradd2 = par.beta2 * ((par.n2 * par.p2 * exp(par.Vbi2/par.VT)) - (par.Nd2 * par.Na2));

% Recombination in the depletion region (SCR) current constant
Jscr02 = par.ni2 * sqrt(2 * par.q * par.eps2 * ((1/par.Na2) + (1/par.Nd2)) * par.Vbi2 / (par.tn2 * par.tp2));
par.Jscrd2 = sqrt(2 * par.q * par.eps2 * (par.Nd2 + par.Na2) * par.Vbi2 / (par.tn2 * par.tp2));


% Illumination current (mA m-2)
par.Jillum2 = Jsc2 + Jdiff02 + Jrad02 + Jscr02;



%% Calculate PVK Constants
% Built-in voltage (V) (converting the energies from eV to J)
par.Vbi1 = (par.EcE - par.EvH) + par.VT*log((par.dH * par.dE)/(par.gvH * par.gcE));

% nb and pb
par.nb = (par.dE * par.gc / par.gcE) * exp((par.EcE - par.Ec)/par.VT);
par.pb = (par.dH * par.gv / par.gvH) * exp((par.Ev - par.EvH)/par.VT);

% Debye length (m)
par.LD = sqrt((par.epsA * par.eps0 * par.VT)/(par.q * par.N0));
par.omegaE = sqrt((par.epsA * par.eps0 * par.N0)/(par.epsE * par.eps0 * par.dE));
par.omegaH = sqrt((par.epsA * par.eps0 * par.N0)/(par.epsH * par.eps0 * par.dH));

% Intrinsic carrier concentration
par.ni2 = par.gc * par.gv * exp(-(par.Ec - par.Ev)/(par.k * par.T));

% Q(V) pre-multiplier
par.Q0 = sqrt(2 * par.q * par.N0 * par.epsA * par.eps0 * par.VT);



%% Calculate the open circuit voltage of the cell
% Set fsolve to not display each calculation
options = optimoptions('fsolve', 'Display', 'none', 'FunctionTolerance', 1e-16, 'OptimalityTolerance', 1e-16, 'StepTolerance', 1e-16);

% Set initial guess for the silicon Voc
v0 = par.Vbi2 / 2;

% Find where the silicon current is zero
si_Voc_func = @(v) evaluate_si_Voc(v, par);
res.Voc2 = fzero(si_Voc_func, v0);

% Calculate PVK Voc by finding the voltage for J = 0
Voc0 = par.Vbi1 * 0.9;
pvk_Voc_func = @(v) calculate_JPSC(par, v, options);
res.Voc1 = fzero(pvk_Voc_func, Voc0);



%% Set range of voltages and vectors to store results
J = linspace(0, min([Jsc1 Jsc2]), par.N);
V1 = zeros(size(J));
V2 = zeros(size(J));
V = zeros(size(J));



%% Calculate V, V1, V2 for a given J
% Find the constants to be used for the initial guesses
n_estimate = 1.1;
jd02 = Jsc2 / (exp((res.Voc2 - par.Vbi2) / (n_estimate * par.VT)));

for iter = 1:(par.N - 1)
    % Set the initial guess
    v02 = par.Vbi2 + (n_estimate * par.VT * log((Jsc2 - J(iter))/jd02));
    if abs(v02) > res.Voc2
        v02 = res.Voc2;
    end

    % Initialise the functions to be used
    si_V_func = @(v2) evaluate_Si_V(v2, J(iter), par);

    % Use fzero to find the corresponding voltage
    V2(iter) = fzero(si_V_func, v02);
end

% Add the final voltages
V2(end) = 0;


% %% Calculate J for each V
% % Find the dark current constant to be used for the current initial guess
% n_estimate = 1.1;
% jd0 = min([Jsc1 Jsc2]) / (exp((res.Voc1 + res.Voc2)/(n_estimate * par.VT)) - 1);
% 
% % % Pre-allocate
% % V = res.V;
% % J = res.J;
% % V1 = res.V1;
% % V2 = res.V2;
% 
% parfor iter = 1:par.N
%     % Set the initial guesses
%     j0 = min([Jsc1 Jsc2]) - jd0 * (exp(V(iter)/(n_estimate * par.VT)) - 1);
%     v0 = V(iter)/2;
%     x0 = [j0, v0, v0];
% 
%     % Solve
%     fun = @(x)evaluate_tandem_pvk_si(x, V(iter), par, options);
%     x_sol = fsolve(fun, x0, options);
% 
%     % Unpack output
%     J(iter) = real(x_sol(1));
%     V1(iter) = real(x_sol(2));
%     V2(iter) = real(x_sol(3));
% end
% 
% Unpack the results
res.V = V;
res.J = J;
res.V1 = V1;
res.V2 = V2;



%% Calculate Contribution of Each Cell to the Series Resistor Voltage
% Cell 1 series resistor voltage
res.Vs1 = -res.J * par.A * par.Rs1;

% Cell 2 series resistor voltage
res.Vs2 = -res.J * par.A * par.Rs2;

% Sum of series resistor voltages
res.Vs = res.Vs1 + res.Vs2;

% Total cell contributions
res.V1T = res.V1 + res.Vs1;
res.V2T = res.V2 + res.Vs2;



%% Calculate the Efficiency
% Incident photon power (converting to (mW cm-2) from (W cm-2))
Pin = sum(spectrums.bs .* E) * par.q * 1e3;
Pout = max(res.J .* res.V);
Efficiency = Pout / Pin * 100;

% Print the efficiency
fprintf('Efficiency: %5.3f%%\n', Efficiency);



%% Plots
% Fetch plotting settings
set = plot_settings();

% Current - Voltage Plot
if set.plot1
    fig1 = Plotting.J_V(res);
end

% Voltage area plot
if set.plot2
    fig2 = Plotting.V_Area(res);
end

% Voltage - Voltage Bias plot
if set.plot3
    fig3 = Plotting.V_VBias(res);
end

% Power - Voltage plot
if set.plot4
    fig4 = Plotting.P_V(res);
end

% Spectrum Plot
if set.plot5
    [fig5, spectrums] = Plotting.spectrum(spectrums, par, set);
end