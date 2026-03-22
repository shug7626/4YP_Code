% Script to perform an optimisation of a PVK-on-Si Tandem cell

% Parameters to be optimised/varied:
% PVK Active Layer (PAL) thickness
% Silicon total thickness

% General Method:
% Within the limits set, compute the Maximum Power Point (MPP) for a range
% of values.
% Starting with the maximum of those values, use a numerical method to find
% the true MPP in the set range.


%% Unpack the Parameters
par = parameters();

% Set the range of values to calculate the MPP for
PVKRange = linspace(par.thick1Min, par.thick1Max, par.N);
SiliconRange = linspace(par.thick2Min, par.thick2Max, par.N);

% Thermal voltage
par.VT = par.k*par.T/par.q;

% Set fsolve to not display each calculation
options = optimoptions('fsolve', 'Display', 'none', 'FunctionTolerance', 1e-16, 'OptimalityTolerance', 1e-16, 'StepTolerance', 1e-16);



%% Process the Spectrum
% Import the spectrum data
spectrum_table = readmatrix("Spectrum_full.xlsx");
spectrums.wavelengths = spectrum_table(:,1);
spectrums.bs_cumulative = spectrum_table(:,2);      % (photons cm-2 s-1)

% Switch from the cumulative spectrum to the photon flux density
spectrums.bs = zeros(size(spectrums.bs_cumulative));
spectrums.bs(1) = spectrums.bs_cumulative(1);
spectrums.bs(2:end) = spectrums.bs_cumulative(2:end) - spectrums.bs_cumulative(1:end-1);

% Convert the spectrums.wavelengths to photon energies (converting from nm to m)
spectrums.E = par.h * par.c ./(spectrums.wavelengths / 1e9);  % (eV)



%% Calculate the Silicon and PVK constants
par = Methods.calculate_Si_const(par);
par = Methods.calculate_PVK_const(par);



%% Calculate the Short Circuit Current Densities
[Jsc1, Jsc2] = Methods.calculate_Jsc(par, spectrums, PVKRange(20), SiliconRange(20));