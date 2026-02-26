% Code based on the log form of the three diode model, with series and
% shunt resistors for a perovskite on silicon tandem cell

%% Fetch parameters and settings
params = parameters();
set = tandem_settings();



%% Calculate the short circuit current densities based on incident spectrum
% Import the spectrum data
spectrum_table = readtable("Spectrum.xlsx");
wavelengths = spectrum_table(:,1);
photon_flux = spectrum_table(:,2);