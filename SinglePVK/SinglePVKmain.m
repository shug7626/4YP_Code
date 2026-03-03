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
Jsc = par.q * sum(etac .* (ones(size(R)) - R) .* a .* (spectrums.bs .* par.validE));

% Convert to mA
Jsc = Jsc * 1e3;



%% Calculate constants
% Thermal voltage (V)
par.VT = par.k * par.T / par.q;

% Built-in voltage (V) (converting the energies from eV to J)
par.Vbi = (par.EcE - par.EvH) + par.VT*log((par.dH * par.dE)/(par.gvH * par.gcE));

% Debye length (m)
par.LD = sqrt((par.epsA * par.VT)/(par.q * par.N0));
par.omegaE = sqrt((par.epsA * par.N0)/(par.epsE * par.dE));
par.omegaH = sqrt((par.epsA * par.N0)/(par.epsH * par.dH));

% Intrinsic carrier concentration
par.ni2 = par.gc * par.gv * exp(-(par.Ec - par.Ev)/(par.k * par.T));

% Q(V) pre-multiplier
par.Q0 = sqrt(2 * par.q * par.N0 * par.epsA * par.VT);


