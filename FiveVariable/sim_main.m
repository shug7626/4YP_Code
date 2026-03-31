% Script to simulate a single PVK-Si tandem solar cell

%% Import Data
tic;
% Material parameters
par = Data.parameters();

% Import spectrum data
spectrums = Methods.calculate_spectrums(par);

% Set the numerical solver settings
options = optimoptions('fsolve', ...
    'Display', 'none', ...
    'FunctionTolerance', 1e-16, ...
    'OptimalityTolerance', 1e-16, ...
    'StepTolerance', 1e-16);



time.init = toc;
fprintf('Import complete in %f seconds\n', time.init);
%% Calculate Constants
tic;
% Calculate the thermal voltage
par.VT = par.k*par.T/par.q;

% Create a variables variables as input
vars = [par.thick1, par.thick2n, par.thick2p, par.Nd2, par.Na2];

% Calculate the constants to be used for the voltage calculations
res = Methods.calculate_const(vars, par, spectrums);



time.const = toc;
fprintf('Constants calculated in %f seconds\n', time.const);