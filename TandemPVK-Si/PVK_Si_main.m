% Code based on the log form of the three diode model, with series and
% shunt resistors for a perovskite on silicon tandem cell

%% Fetch parameters and settings
params = parameters();
set = tandem_settings();



%% Calculate the short circuit current densities based on incident spectrum
% Import the spectrum data
spectrum_table = readmatrix("Spectrum.xlsx");
wavelengths = spectrum_table(:,1);
photon_flux = spectrum_table(:,2);

% Convert the wavelengths to photon energies (converting from nm to m)
E = params.h * params.c ./(wavelengths / 1e9);

% Evaluate Jsc1 by summing each valid discrete value
