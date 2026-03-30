% Script to optimise the thickness of the PAL, and the doping
% concentrations of the silicon

% General Method:
% Over the range of input variables, calculate a variety of MPPs to find a
% starting point for the numerical solver. Then use fmincon, or
% alternative, to find the maximum MPP within the bounds set in the
% parameters file


%% Fetch and process the parameters
tic;
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



time.fetch = toc;
%% Create the matrices from the boundaries set in the parameters file
tic;
% PVK PAL thicknesses
pvk_thicks = linspace(par.thick1Min, par.thick1Max, N);

% Si doping concentrations
Nds = linspace(par.NdMin, par.NdMax, N);
Nas = linspace(par.NaMin, par.NaMax, N);

% Create the MPP matrix to store the results
MPPs = zeros(par.N2, par.N2, N);

% 1-dimension version of MPPs
MPP_temp = zeros(1, N^3);



time.matrix = toc;
%% Calculate the MPP over the Ranges
tic;
fprintf('Starting the calculation of the MPPs\n');

% Use a parfor loop to loop through each option
parfor iter = 1:N^3
    % Initialise a blank res structure
    res = struct();

    % Decode the iter number to find the specific variables
    pvk_thick = pvk_thicks(floor((iter - 1)/(N ^ 2)) + 1);
    Nd = Nds(floor((mod(iter - 1, N^2))/N) + 1);
    Na = Nas(mod((iter - 1), N) + 1);

    % Calculate the built in voltage of the silicon
    res.Vbi2 = par.VT * log(Na * Nd / (par.ni2 ^ 2));
    
    % Calculate the silicon depletion region width
    res.W2 = sqrt(2 * par.eps2 * res.Vbi2 * ((1/Na) + (1/Nd)) / par.q);         % (cm)
    
    % Calculate the short circuit current densities
    res = Methods.calculate_Jsc(par, res, pvk_thick);
    
    % Calculate the silicon constants
    res = Methods.calculate_silicon_const(Na, Nd, par, res);
    
    % Calculate the PVK constants
    res = Methods.calculate_pvk_const(pvk_thick, res, par, options);

    % Create the negative power function
    P = @(j) -1*j*Methods.evaluate_V(j, pvk_thick, res, par, options);

    % Use fminbnd to find the minimum negative power
    [Jmpp_res, MPP_res] = fminbnd(P, 0, min([res.Jsc1 res.Jsc2]));
    
    % Store the result
    MPP_temp(iter) = -1 * MPP_res;
end



time.initial = toc;
fprintf('MPP Calculation Complete in %f seconds\n', time.initial);
%% Write the Result of the Initial Calculation to the Command Window
tic;
% Find the max MPP
maxMPP = max(MPP_temp, [], 'all');
MPPpos = find(MPP_temp == maxMPP, 1);
MPPpvkThick = pvk_thicks(floor((MPPpos - 1)/(N ^ 2)) + 1);
MPPnd = Nds(floor((mod(MPPpos - 1, N^2))/N) + 1);
MPPna = Nas(mod((MPPpos - 1), N) + 1);

% Display results
fprintf('<strong>Results from the Initial Calculations:</strong>\n');
fprintf('Maximum MPP = %f mW\n', maxMPP * par.A);
fprintf('Occuring at:\n');
fprintf('PVK PAL Thickness = %f nm\n', MPPpvkThick);
fprintf('Silicon Donor Concentration = %e cm%c%c\n', MPPnd, char(8315), char(179));
fprintf('Silicon Acceptor Concentration = %e cm%c%c\n', MPPna, char(8315), char(179));



time.disp_init = toc;
fprintf('\nTotal Time = %f seconds\n', sum(structfun(@(x) sum(x(:)), time)));