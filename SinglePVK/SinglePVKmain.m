% Main script for simulating a single PVK cell at steady-state

% Fetch parameters
par = parameters();



%% Calculate the short circuit current from the incident spectrum
% Import the spectrum
spectrum_table = readmatrix("Spectrum_full.xlsx");
spectrums.wavelengths = spectrum_table(:,1);
spectrums.bs_cumulative = spectrum_table(:,2);

% Switch from the cumulative spectrum to the spectrum density
spectrums.bs = zeros(size(spectrums.bs_cumulative));
spectrums.bs(1) = spectrums.bs_cumulative(1);
spectrums.bs(2:end) = spectrums.bs_cumulative(2:end) - spectrums.bs_cumulative(1:end-1);

% Convert the wavelengths to energy (eV) and converting from nm to m
E = par.h * par.c ./ (spectrums.wavelengths / 1e9);

% Create a mask of valid energies
par.validE = E >= (par.Ec - par.Ev);

% Create vectors for the reflectivity, absorptivity, and probability of
% electron collection
R = par.validE * par.R;
a = par.validE * par.a;
etac = par.validE * par.etac;

% Evaluate the short circuit current (A cm-2)
par.Jsc = par.q * sum(etac .* (ones(size(R)) - R) .* a .* (spectrums.bs .* par.validE));

% Convert to mA
par.Jsc = par.Jsc * 1e3;



%% Calculate constants
% Thermal voltage (V)
par.VT = par.k * par.T / par.q;

% Built-in voltage (V) (converting the energies from eV to J)
par.Vbi = (par.EcE - par.EvH) + par.VT*log((par.dH * par.dE)/(par.gvH * par.gcE));

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



%% Calculate the open circuit voltage
% Set the fsolve options
options = optimoptions('fsolve', 'Display', 'none');

V = linspace(0, 0.725, 20);
J = zeros(size(V));

for iter = 1:20
    % Calculate J
    J(iter) = calculate_JPSC(par, V(iter), options);
end

plot(V, J);




