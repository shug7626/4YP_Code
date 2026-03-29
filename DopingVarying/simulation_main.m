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

% Calculate the built in voltage of the silicon
res.Vbi2 = par.VT * log(par.Na2 * par.Nd2 / (par.ni2 ^ 2));

% Calculate the silicon depletion region width
res.W2 = sqrt(2 * par.eps2 * res.Vbi2 * ((1/par.Na2) + (1/par.Nd2)) / par.q);         % (cm)

% Calculate the short circuit current densities
res = Methods.calculate_Jsc(par, res);

% Calculate the silicon constants
res = Methods.calculate_silicon_const(par.Na2, par.Nd2, par, res);

% Calculate the PVK constants
res = Methods.calculate_pvk_const(res, par);