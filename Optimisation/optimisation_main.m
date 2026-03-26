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
fig2 = Plotting.Cost_Surface(PVKRange, SiliconRange, MPP, par);



%% Display Initial Results
% Find the max MPP and its associated thicknesses
maxMPP = max(MPP, [], 'all');
[SiPos, PVKPos] = find(MPP == maxMPP);
MPP_PVK_Thick = PVKRange(PVKPos);
MPP_Si_Thick = SiliconRange(SiPos) * 1e6;

% Display MPP
fprintf('Maximum Discrete MPP = %f mW\n', maxMPP);
fprintf('Occuring at PVK Thickness %f nm \n', MPP_PVK_Thick);
fprintf('and Silicon Thickness %f %cm \n',  MPP_Si_Thick, char(181));