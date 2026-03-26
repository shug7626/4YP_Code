% Script to find the peak Maximum Power Point (MPP) and minimum cost per
% watt using an alternative method to the original optimisation script

% Method:
% Calculate the MPP for a range of values within the bounds set in the
% parameters file
% Find the peak MPP from that calculation and perform another set of MPP
% calculations around the previous peak
% Repeat the 'zooming in' until the desired precision has been achieved


%% Unpack the Parameters
tic;
par = parameters();

% Number of 'zoom in's
N = par.N;

% Thermal voltage
par.VT = par.k*par.T/par.q;

% Set fsolve to not display each calculation
options = optimoptions('fsolve', ...
    'Display', 'none', ...
    'FunctionTolerance', 1e-16, ...
    'OptimalityTolerance', 1e-16, ...
    'StepTolerance', 1e-16);



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



time1 = toc;
fprintf('Time to initialise = %f seconds\n', time1);