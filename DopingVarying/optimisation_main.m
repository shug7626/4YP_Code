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

% Set the number of MPPs to calculate
N = par.N2;

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
pvk_thicks = linspace(par.thick1Min, par.thick1Max, N);

% Si doping concentrations
Nds = linspace(par.NdMin, par.NdMax, N);
Nas = linspace(par.NaMin, par.NaMax, N);

% Create the MPP matrix to store the results
MPPs = zeros(par.N2, par.N2, N);

% 1-dimension version of MPPs
MPP_temp = zeros(1, N^3);



%% Calculate the MPP over the Ranges
fprintf('Starting the calculation of the MPPs\n');

% Temporary for checking dimensions
pvk_thicks = linspace(0, N^3 - N^2, N);
Nds = linspace(0, N^2 - N, N);
Nas = linspace(1, N, N);

% Use a parfor loop to loop through each option
for iter = 1:N^3
    pvk_thick = pvk_thicks(floor((iter - 1)/(N ^ 2)) + 1);
    % Nd = Nds(mod(floor((iter)/N), N) + 1);
    Nd = Nds(floor((mod(iter - 1, N^2))/N) + 1);
    Na = Nas(mod((iter - 1), N) + 1);

    MPP_temp(iter) = sum([pvk_thick Nd Na]);
end

fprintf('MPP Calculation Complete\n');