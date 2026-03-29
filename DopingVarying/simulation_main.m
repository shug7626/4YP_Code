% Script to simulate a PVK-Si tandem cell

%% Feth the Parameters
par = parameters();



%% Calculate the Constants
% Calculate the thermal voltage
par.VT = par.k*par.T/par.q;

% Calculate the silicon constants
par = Methods.calculate_silicon_const(par.Na2, par.Nd2, par);

% Calculate the PVK constants
par = Methods.calculate_pvk_const(par);