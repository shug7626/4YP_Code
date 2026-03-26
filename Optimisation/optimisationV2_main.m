% Script to find the peak Maximum Power Point (MPP) and minimum cost per
% watt using an alternative method to the original optimisation script

% Method:
% Calculate the MPP for a range of values within the bounds set in the
% parameters file
% Find the peak MPP from that calculation and perform another set of MPP
% calculations around the previous peak
% Repeat the 'zooming in' until the desired precision has been achieved