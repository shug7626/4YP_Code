% Script to simulate a single PVK-Si tandem solar cell

%% Import Data
tic;
% Material parameters
par = Data.parameters();

% Import spectrum data
spectrums = Methods.calculate_spectrums(par);



time.init = toc;
fprintf('Import complete in %f seconds\n', time.init);