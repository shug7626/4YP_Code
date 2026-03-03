% Main script for simulating a single PVK cell at steady-state

% Fetch parameters
par = parameters();



%% Calculate the short circuit current from the incident spectrum
% Import the spectrum
spectrum_table = readmatrix("Spectrum_full.xlsx");
spectrums.wavelengths = spectrum_table(:,1);
spectrums.bs_cumulative = spectrum_table(:,2);