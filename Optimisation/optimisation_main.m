% Script to perform an optimisation of a PVK-on-Si Tandem cell

% Parameters to be optimised/varied:
% PVK Active Layer (PAL) thickness
% Silicon total thickness

% General Method:
% Within the limits set, compute the Maximum Power Point (MPP) for a range
% of values.
% Starting with the maximum of those values, use a numerical method to find
% the true MPP in the set range.


%% Unpack the Parameters
par = parameters();

% Number of points
N = par.N;

% Set the range of values to calculate the MPP for
PVKRange = linspace(par.thick1Min, par.thick1Max, N);
SiliconRange = linspace(par.thick2Min, par.thick2Max, N);

% Thermal voltage
par.VT = par.k*par.T/par.q;

% Set fsolve to not display each calculation
options = optimoptions('fsolve', 'Display', 'none', 'FunctionTolerance', 1e-16, 'OptimalityTolerance', 1e-16, 'StepTolerance', 1e-16);



%% Process the Spectrum
% Import the spectrum data
spectrum_table = readmatrix("Spectrum_full.xlsx");
spectrums.wavelengths = spectrum_table(:,1);
spectrums.bs_cumulative = spectrum_table(:,2);      % (photons cm-2 s-1)

% Switch from the cumulative spectrum to the photon flux density
spectrums.bs = zeros(size(spectrums.bs_cumulative));
spectrums.bs(1) = spectrums.bs_cumulative(1);
spectrums.bs(2:end) = spectrums.bs_cumulative(2:end) - spectrums.bs_cumulative(1:end-1);

% Convert the spectrums.wavelengths to photon energies (converting from nm to m)
spectrums.E = par.h * par.c ./(spectrums.wavelengths / 1e9);  % (eV)



%% Calculate the Silicon and PVK constants
par = Methods.calculate_Si_const(par);
par = Methods.calculate_PVK_const(par);



%% Calculate the MPP for a Range of Thicknesses
% Preallocate memory for the storage of the MPPs
MPP = zeros(N);

% % Set the fmincon settings
% powOptions = optimoptions('fmincon', 'Display','none');

% Perform the MPP calculations
parfor iter1 = 1:N
    for iter2 = 1:N
        % Calculate the short circuit current densities
        [Jsc1, Jsc2] = Methods.calculate_Jsc(par, spectrums, PVKRange(iter1), SiliconRange(iter2));
        
        % Create the power function
        P = @(j) -1*j*Methods.evaluate_V(j, Jsc1, Jsc2, PVKRange(iter1), par, options);

        % % Use fmincon to find the minimum negative power
        % [Jmpp_res, MPP_res] = fmincon(P, min([Jsc1 Jsc2])*0.95, [], [], [], [], 0, min([Jsc1 Jsc2]), [], powOptions);
        
        % Use fminbnd to find the minimum negative power
        [Jmpp_res, MPP_res] = fminbnd(P, 0, min([Jsc1 Jsc2]));

        % Store the results
        MPP(iter1, iter2) = -1 * MPP_res;
    end
end



%% Surface Plots
fig1 = Plotting.Surface(PVKRange, SiliconRange, MPP);
[fig2, cost] = Plotting.Cost_Surface(PVKRange, SiliconRange, MPP, par);



%% Display Initial Results
% Find the max MPP and its associated thicknesses
maxMPP = max(MPP, [], 'all');
[MPPSiPos, MPPPVKPos] = find(MPP == maxMPP);
MPP_PVK_Thick = PVKRange(MPPPVKPos);
MPP_Si_Thick = SiliconRange(MPPSiPos) * 1e6;

% Display MPP
fprintf('Maximum Discrete MPP = %f mW\n', maxMPP);
fprintf('Occuring at PVK Thickness %f nm \n', MPP_PVK_Thick);
fprintf('and Silicon Thickness %f %cm \n',  MPP_Si_Thick, char(181));

% Find the min Cost per Watt and associated thicknesses
minCost = min(cost, [], 'all');
[CostSiPos, CostPVKPos] = find(cost == minCost);
Cost_PVK_Thick = PVKRange(CostPVKPos);
Cost_Si_Thick = SiliconRange(CostSiPos) * 1e6;

% Display min cost
fprintf('\nMinimum Discrete Cost per Watt = %f £/W \n', minCost);
fprintf('Occuring at PVK Thickness %f nm \n', Cost_PVK_Thick);
fprintf('and Silicon Thickness %f %cm \n', Cost_Si_Thick, char(181));



%% Add the Initial Results to the Surface Plots
ax = fig1.CurrentAxes;
hold(ax, 'on');
plot3(ax, MPP_PVK_Thick, MPP_Si_Thick, maxMPP, 'r*');
text(ax, MPP_PVK_Thick, MPP_Si_Thick, maxMPP, 'Discrete MPP');

ax = fig2.CurrentAxes;
hold(ax, 'on');
plot3(ax, Cost_PVK_Thick, Cost_Si_Thick, minCost, 'r*');
text(ax, Cost_PVK_Thick, Cost_Si_Thick, minCost, 'Discrete Min Cost per Watt');



%% Calculate the Optimal Thicknesses Numerically
% Set the fmincon settings
powOptions = optimoptions('fmincon', ...
    'StepTolerance', 1e-10, ...
    'OptimalityTolerance', 1e-10, ...
    'Display', 'iter', ...
    'UseParallel', true);

% Start a parallel pool if one doesn't already exist
if isempty(gcp('nocreate'))
    parpool;
end

% Set the MPP negative power function
negMPP = @(x) -1*Methods.evaluate_MPP(x, par, spectrums, options);

% Define the boundaries
lowerBounds = [PVKRange(1), SiliconRange(1)];
upperBounds = [PVKRange(end), SiliconRange(end)];

% Set the initial guesses as the max of the discrete calculations
x0 = [MPP_PVK_Thick, MPP_Si_Thick / 1e6];

% Use fmincon to find the optimal thicknesses for MPP
fprintf('Finding maximum MPPthicknesses using fmincon\n');
[MPP_thicknesses, min_negMPP] = fmincon(negMPP, x0, [], [], [], [], lowerBounds, upperBounds, [], powOptions);

% Store results
MPP_PVK_Thick = MPP_thicknesses(1);
MPP_Si_Thick = MPP_thicknesses(2) * 1e6;
maxMPP = -1 * min_negMPP;


% Set the Cost/Watt function
cost_watt = @(x) Methods.evaluate_cost_watt(x, par, spectrums, options);

% Set the intitial guesses from the discrete calculation
x0 = [Cost_PVK_Thick, Cost_Si_Thick / 1e6];

% Use fmincon to find the optimal thicknesses
fprintf('Finding minimum cost per watt using fmincon\n');
[cost_watt_thicknesses, minCost] = fmincon(cost_watt, x0, [], [], [], [], lowerBounds, upperBouds, [], powOptions);

% Store results
Cost_PVK_Thick = cost_watt_thicknesses(1);
Cost_Si_Thick = cost_watt_thicknesses(2) * 1e6;



% Display Numerical Results
fprintf('Maximum Numerical MPP = %f mW\n', maxMPP);
fprintf('Occuring at PVK Thickness %f nm \n', MPP_PVK_Thick);
fprintf('and Silicon Thickness %f %cm \n',  MPP_Si_Thick, char(181));

% Display min cost
fprintf('\nMinimum Discrete Cost per Watt = %f £/W \n', minCost);
fprintf('Occuring at PVK Thickness %f nm \n', Cost_PVK_Thick);
fprintf('and Silicon Thickness %f %cm \n', Cost_Si_Thick, char(181));