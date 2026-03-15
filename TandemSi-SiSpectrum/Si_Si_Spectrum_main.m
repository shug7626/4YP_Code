% Code based on the log form of the three diode model, with series and
% shunt resistors for a silicon on silicon tandem cell

%% Fetch parameters and settings
par = parameters();
set = plotting_settings();



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
par.validE1 = E >= par.Eg1;
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
par.validE1(last1 + 1) = (E(last1) - par.Eg1)/(E(last1) - E(last1 + 1));
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
Jsc2 = Jsc2 * 1e3;



%% Diode Constant Calculations
% Thermal voltage
par.VT = par.k*par.T/par.q;

% Built in voltage
par.Vbi1 = par.VT * log(par.Na1 * par.Nd1 / (par.ni1 ^ 2));
par.Vbi2 = par.VT * log(par.Na2 * par.Nd2 / (par.ni2 ^ 2));

% Diffusion current constant
Jdiff01 = par.q * (par.ni1^2) * ((par.Dn1 / (par.Na1 * par.Ln1)) + (par.Dp1 / (par.Nd1 * par.Lp1)));
par.Jdiffd1 = par.q * par.Nd1 * par.Na1 * ((par.Dn1 / (par.Na1 * par.Ln1)) + (par.Dp1 / (par.Nd1 * par.Lp1)));
Jdiff02 = par.q * (par.ni2^2) * ((par.Dn2 / (par.Na2 * par.Ln2)) + (par.Dp2 / (par.Nd2 * par.Lp2)));
par.Jdiffd2 = par.q * par.Nd2 * par.Na2 * ((par.Dn2 / (par.Na2 * par.Ln2)) + (par.Dp2 / (par.Nd2 * par.Lp2)));

% Radiative recombination current constant
Jrad01 = par.beta1 * ((par.n1 * par.p1) - (par.ni1 ^ 2));
par.Jradd1 = par.beta1 * ((par.n1 * par.p1 * exp(par.Vbi1/par.VT)) - (par.Nd1 * par.Na1));
Jrad02 = par.beta2 * ((par.n2 * par.p2) - (par.ni2 ^ 2));
par.Jradd2 = par.beta2 * ((par.n2 * par.p2 * exp(par.Vbi2/par.VT)) - (par.Nd2 * par.Na2));

% Recombination in the depletion region (SCR) current constant
Jscr01 = par.ni1 * sqrt(2 * par.q * par.eps1 * ((1/par.Na1) + (1/par.Nd1)) * par.Vbi1 / (par.tn1 * par.tp1));
par.Jscrd1 = sqrt(2 * par.q * par.eps1 * (par.Nd1 + par.Na1) * par.Vbi1 / (par.tn1 * par.tp1));
Jscr02 = par.ni2 * sqrt(2 * par.q * par.eps2 * ((1/par.Na2) + (1/par.Nd2)) * par.Vbi2 / (par.tn2 * par.tp2));
par.Jscrd2 = sqrt(2 * par.q * par.eps2 * (par.Nd2 + par.Na2) * par.Vbi2 / (par.tn2 * par.tp2));


% Illumination current (mA m-2)
par.Jillum1 = Jsc1 + Jdiff01 + Jrad01 + Jscr01;
par.Jillum2 = Jsc2 + Jdiff02 + Jrad02 + Jscr02;



%% Calculate the open circuit voltage of the cell
% Set fsolve to not display each calculation
options = optimoptions('fsolve', 'Display', 'none');

% Set initial guess for Voc
v01 = 0.5;
v02 = 0.5;
v0 = [v01, v02];

% Find where the total current is zero
func = @(v) evaluate_tandem_si_si_Voc(v, par);
Voc_sol = fsolve(func, v0, options);
res.Voc1 = Voc_sol(1);
res.Voc2 = Voc_sol(2);



%% Set range of voltages and vectors to store results
res.V = linspace(0, (res.Voc1 + res.Voc2), par.N);
res.V1 = zeros(size(res.V));
res.V2 = zeros(size(res.V));
res.J = zeros(size(res.V));



%% Calculate J for each V
% Set initial guess
j0 = (Jsc1 + Jsc2) / 2;
v01 = res.Voc1/2;
v02 = res.Voc2/2;
x0 = [j0, v01, v02];

for iter = 1:par.N
    % Solve
    fun = @(x)evaluate_tandem_si_si(x, res.V(iter), par);
    x_sol = fsolve(fun, x0, options);
    
    % Unpack output
    res.J(iter) = real(x_sol(1));
    res.V1(iter) = real(x_sol(2));
    res.V2(iter) = real(x_sol(3));
end



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


