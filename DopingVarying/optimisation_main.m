% Script to optimise the thickness of the PAL, and the doping
% concentrations of the silicon

% General Method:
% Over the range of input variables, calculate a variety of MPPs to find a
% starting point for the numerical solver. Then use fmincon, or
% alternative, to find the maximum MPP within the bounds set in the
% parameters file


%% Fetch and process the parameters
par = parameters();
set = plot_settings();

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

% Calculate the thermal voltage
par.VT = par.k*par.T/par.q;



%% Create the matrices from the boundaries set in the parameters file
% PVK PAL thicknesses
pvk_thicks = linspace(par.thick1Min, par.thick1Max, par.N2);

% Si doping concentrations
Nds = linspace(par.NdMin, par.NdMax, par.N2);
Nas = linspace(par.NaMin, par.NaMax, par.N2);

% Create the MPP matrix to store the results
MPPs = zeros(par.N2, par.N2, par.N2);