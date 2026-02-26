% Code based on the log form of the three diode model, with series and
% shunt resistors for a perovskite on silicon tandem cell

%% Fetch parameters and settings
params = parameters();
set = tandem_settings();



%% Calculate the short circuit current densities based on incident spectrum
% Import the spectrum data
spectrum_table = readmatrix("Spectrum_full.xlsx");
wavelengths = spectrum_table(:,1);
bs = spectrum_table(:,2);

% Convert the wavelengths to photon energies (converting from nm to m)
E = params.h * params.c ./(wavelengths / 1e9);

% Find each valid discrete value of energy
validE1 = E(:) >= params.Eg1;
validE2 = E(:) >= params.Eg2;

% Create vectors for the reflectivity, absorptivity, and probability
R1 = validE1 * params.R1;
R2 = validE2 * params.R2;
a1 = validE1 * params.a1;
a2 = validE2 * params.a2;
etac1 = validE1 * params.etac1;
etac2 = validE2 * params.etac2;

% Calculate the spectrum seen by cell 2
bs2 = (ones(size(R1))-R1) .* (ones(size(R2))-R2) .* (ones(size(a1))-a1) .* bs;

% Evaluate Jsc1 and Jsc2
Jsc1 = params.q * sum(etac1 .* (ones(size(R1))-R1) .* a1 .* (bs .* validE1));
Jsc2 = params.q * sum(etac2 .* (ones(size(R2))-R2) .* a2 .* (bs2 .* validE2));


