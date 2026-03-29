% Script to simulate a PVK-Si tandem cell

%% Fetch the Parameters
par = parameters();

% Set the numerical solver settings
options = optimoptions('fsolve', ...
    'Display', 'none', ...
    'FunctionTolerance', 1e-16, ...
    'OptimalityTolerance', 1e-16, ...
    'StepTolerance', 1e-16);

powOptions = optimoptions('fmincon', ...
    'StepTolerance', 1e-10, ...
    'OptimalityTolerance', 1e-10, ...
    'Display', 'iter', ...
    'UseParallel', true);



%% Calculate the Constants
% Calculate the thermal voltage
par.VT = par.k*par.T/par.q;

% Calculate the silicon constants
par = Methods.calculate_silicon_const(par.Na2, par.Nd2, par);

% Calculate the PVK constants
par = Methods.calculate_pvk_const(par);