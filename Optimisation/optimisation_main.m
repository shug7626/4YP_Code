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

% Set the range of values to calculate the MPP for
PVKRange = linspace(par.thick1Min, par.thick1Max, par.N);
SiliconRange = linspace(par.thick2Min, par.thick2Max, par.N);