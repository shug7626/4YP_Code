% Script to optimise the thickness of the PAL, and the doping
% concentrations of the silicon

% General Method:
% Over the range of input variables, calculate a variety of MPPs to find a
% starting point for the numerical solver. Then use fmincon, or
% alternative, to find the maximum MPP within the bounds set in the
% parameters file