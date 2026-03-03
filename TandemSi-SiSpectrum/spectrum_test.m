% Import the spectrum data
spectrum_table = readmatrix("Spectrum_full.xlsx");
wavelengths = spectrum_table(:,1);
bs_cumulative = spectrum_table(:,2);                   % (photons cm-2 s-1)

cumulative_spec = 0;
bs = zeros(size(bs_cumulative));
for i = 1:length(wavelengths)
    bs(i) = bs_cumulative(i) - cumulative_spec;
    cumulative_spec = cumulative_spec + bs(i);
end

%% Plot spectums
figure(1);
% plot(wavelengths, bs_cumulative);
% hold on;
plot(wavelengths, bs);