% Script to find the peak Maximum Power Point (MPP) and minimum cost per
% watt using an alternative method to the original optimisation script

% Method:
% Calculate the MPP for a range of values within the bounds set in the
% parameters file
% Find the peak MPP from that calculation and perform another set of MPP
% calculations around the previous peak
% Repeat the 'zooming in' until the desired precision has been achieved


%% Unpack the Parameters
tic;
par = parameters();

% Set the number of points per 'zoom in'
N = 5;

% Number of 'zoom in's
NTotal = par.N;

% Set the boundaries of the thicknesses
PVKBound = [par.thick1Min par.thick1Max];
SiBound = [par.thick2Min par.thick2Max];

% Thermal voltage
par.VT = par.k*par.T/par.q;

% Set fsolve to not display each calculation
options = optimoptions('fsolve', ...
    'Display', 'none', ...
    'FunctionTolerance', 1e-16, ...
    'OptimalityTolerance', 1e-16, ...
    'StepTolerance', 1e-16);



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



time1 = toc;
fprintf('Time to initialise = %f seconds\n', time1);
%% Calculate the MPP for a Range of Thicknesses
tic;
fprintf('Starting the calculation of the MPPs\n');

% Preallocate memory for storing the MPP calculations and associated
% thicknesses
MPP = zeros([NTotal N N]);
PVKThicknesses = zeros([NTotal N]);
SiThicknesses = zeros([NTotal N]);

% Create a temporary MPP matrix
MPPtemp = zeros([N 1]);
MPPtemp2 = zeros(N);

% Perform the MPP calculations
for iterTotal = 1:NTotal

    % Set the points to calculate the MPP for
    PVKRange = linspace(PVKBound(1), PVKBound(2), N);
    SiliconRange = linspace(SiBound(1), SiBound(2), N);
    
    % Begin the For loop to calculate MPP
    parfor iter = 1:N^2

        % Find the point to calculate the MPP for
        iter1 = floor((iter - 1)/N) + 1;
        iter2 = mod((iter - 1), N) + 1;

        % Calculate the short circuit current densities
        [Jsc1, Jsc2] = Methods.calculate_Jsc(par, spectrums, PVKRange(iter1), SiliconRange(iter2));

        % Create the power function
        P = @(j) -1*j*Methods.evaluate_V(j, Jsc1, Jsc2, PVKRange(iter1), par, options);
        
        % Use fminbnd to find the minimum negative power
        [Jmpp_res, MPP_res] = fminbnd(P, 0, min([Jsc1 Jsc2]));

        % Store the results
        MPPtemp(iter) = -1 * MPP_res;
    end

    % Reshape the MPPtemp matrix
    MPPtemp2 = reshape(MPPtemp, N, N);

    % Store the results in the MPP and thicknesses matrices
    MPP(iterTotal, :, :) = MPPtemp2;
    PVKThicknesses(iterTotal, :) = PVKRange;
    SiThicknesses(iterTotal, :) = SiliconRange;

    % Find where the max MPP is
    maxMPP = max(MPPtemp2, [], 'all');
    [MPPSiPos, MPPPVKPos] = find(MPPtemp2 == maxMPP, 1);

    % Set the bounds based on the max position
    if MPPPVKPos <= 1
        PVKBound(1) = PVKRange(1);
        PVKBound(2) = PVKRange(MPPPVKPos + 1);
    elseif MPPPVKPos >= N
        PVKBound(1) = PVKRange(MPPPVKPos - 1);
        PVKBound(2) = PVKRange(N);
    else
        PVKBound(1) = PVKRange(MPPPVKPos - 1);
        PVKBound(2) = PVKRange(MPPPVKPos + 1);
    end

    if MPPSiPos <= 1
        SiBound(1) = SiliconRange(1);
        SiBound(2) = SiliconRange(MPPSiPos + 1);
    elseif MPPSiPos >= N
        SiBound(1) = SiliconRange(MPPSiPos - 1);
        SiBound(2) = SiliconRange(N);
    else
        SiBound(1) = SiliconRange(MPPSiPos - 1);
        SiBound(2) = SiliconRange(MPPSiPos + 1);
    end

    fprintf('Loop %d complete\n', iterTotal)
end



time2 = toc;
fprintf('Time to calculate MPP = %f seconds\n', time2);
%% Surface Plots
fig1 = Plotting.SurfaceV2(PVKThicknesses, SiThicknesses, MPP, par);



%% Display the Results
% Find the MPP and its position
[maxMPP, linearPos] = max(MPP, [], 'all');
[iteration, MPPSiPos, MPPPVKPos] = ind2sub(size(MPP), linearPos);

% Find the corresponding thicknesses
MPPPVKThick = PVKThicknesses(iteration, MPPPVKPos);
MPPSiThick = SiThicknesses(iteration, MPPSiPos) * 1e6;

% Display the results
fprintf('\n<strong>Results:</strong>\n');
fprintf('Max MPP = %f mW\n', maxMPP);
fprintf('Occuring at:\n');
fprintf('Perovskite thickness = %f nm\n', MPPPVKThick);
fprintf('Silicon thickness = %f %cm\n', MPPSiThick, char(181));