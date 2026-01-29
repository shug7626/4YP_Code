% Simulation of an ideal pv, with no parasitic resistances

% Parameters (poly-Si from Green et al., 2001)
J_sc = 38.1;    % Short circuit current density (=38.1 for poly-Si)(mA/cm2)
V_oc = 0.654;   % Open circuit voltage (=0.654 for poly_Si)(V)
T = 300;        % Temperature (K)
n = 100;        % Number of voltages to calculate for

% Constants
q = 1.602e-19;  % Charge of an electron (C)
k_B = 1.38e-23; % Boltzmann constant (J/K)
VT = k_B * T / q;

% Variables
V = linspace(0, V_oc + 0.01, n);
J = zeros(1, n);
P = zeros(1, n);



%% Current Density Calculations
J_0 = J_sc * (exp((V_oc * q)/(k_B * T)) - 1)^-1;
J = J_sc - J_0*(exp((q * V)/(k_B * T)) - 1);



%% Maximum Power Point Calculation
P = J .* V;
% [MPP, index] = max(P);
% Vmpp = V(index);
% Jmpp = J(index);


% Finds the MPP numerically
PowFun = @(v) -1*idealPower(v, J_sc, J_0, VT);
options = optimoptions('fmincon', 'Display', 'off');
[Vmpp_num, MPP_num] = fmincon(PowFun, V_oc/2, [], [], [], [], 0, V_oc, [], options);
Jmpp_num = idealCurrent(Vmpp_num, J_sc, J_0, VT);
MPP_num = -1*MPP_num;


% Fill Factor calculation
FF = (Jmpp_num * Vmpp_num)/(J_sc * V_oc);



%% Plot
% J-V Plot
figure;
plot(V, J);
hold on;

% Add the maximum power point
plot(Vmpp_num, Jmpp_num, 'rs');
% text(Vmpp_num, Jmpp_num, 'MPP');
ax = gca;
plot([Vmpp_num, Vmpp_num], [ax.YLim(1), Jmpp_num], 'r-');
plot([ax.XLim(1), Vmpp_num], [Jmpp_num, Jmpp_num], 'r-');

hold off;

xlabel('Bias Voltage (V)');
ylabel('Current Density (mA/cm2)');
title('Plot of Current Density vs Bias Voltage for an ideal PV');

% P-V Plot
figure;
plot(V, P);
hold on;

% Add the maximum power point
plot(Vmpp_num, MPP_num, 'rs');
% text(Vmpp_num, MPP_num, 'MPP');
ax2 = gca;
plot([Vmpp_num, Vmpp_num], [ax2.YLim(1), MPP_num], 'r-');
plot([ax2.XLim(1), Vmpp_num], [MPP_num, MPP_num], 'r-');

hold off;

xlabel('Bias Voltage (V)');
ylabel('Power Density (mW/cm2)');
title('Plot of Power Density vs Bias Voltage for an ideal PV');



%% Functions
% % Minimisation setup
% function [c, ceq] = nonlinear_con(x)
%     J = x(1);
%     V = x(2);
%     c = 0;
%     ceq = J - current(V);
% end