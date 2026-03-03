% Script to calculate the the dark current density constant and the
% potential barrier function and then calculate the current through the
% PSC

% Input V is the internal voltages V1-4

function J = calculate_JPSC(par, Vin, options)
    % Set the initial conditions
    V0 = (par.Vbi - Vin)/4;
    Q0 = evaluate_Q(V0, par);
    x0 = [V0, V0, V0, V0, Q0];
    
    % Solve for the internal voltages V1-4
    Vfunc = @(x) solve_pvk_v(x, Vin, par);
    V = fsolve(Vfunc, x0, options);

    % Calculate n and p concentrations
    n = par.nb * exp(-(V(1) + V(2))/par.VT);
    p = par.pb * exp(-(V(3) + V(4))/par.VT);
    
    % Calculate n- and p+ concentrations
    nn = par.nb * exp(-(V(1) + V(2) + V(3))/par.VT);
    pp = par.nb * exp(-(V(2) + V(3) + V(4))/par.VT);
    
    % Calculate the recominbation rates
    R = zeros(1,5);
    R(1) = par.beta * n * p;
    R(2) = p / par.taup;
    R(3) = n / par.taun;
    R(4) = par.vpE * pp;
    R(5) = par.vnH * nn;
    
    % Calculate the dark current constants (converting b from nm to m)
    Jd = zeros(1,5);
    Jd(1) = par.q * par.b * par.beta * par.ni2 * exp(par.Vbi/par.VT) * 1e-9;
    Jd(2) = (par.q * par.b * par.dH * par.gv / (par.taup * par.gvH)) ...
        * exp((par.Ev - par.EvH)/(par.VT)) * 1e-9;
    Jd(3) = (par.q * par.b * par.dE * par.gc / (par.taun * par.gcE)) ...
        * exp(-(par.Ec - par.EcE)/(par.VT)) * 1e-9;
    Jd(4) = (par.q * par.vpE * par.dH * par.gv / par.gvH) ...
        * exp((par.Ev - par.EvH)/(par.VT));
    Jd(5) = (par.q * par.vnH * par.dE * par.gc / par.gcE) ...
        * exp(-(par.Ec - par.EcE)/(par.VT));
    
    % Calculate the potential barrier functions
    F = zeros(1,5);
    F(1) = V(1) + V(2) + V(3) + V(4);
    F(2) = V(3) + V(4);
    F(3) = V(1) + V(2);
    F(4) = V(2) + V(3) + V(4);
    F(5) = V(1) + V(2) + V(3);
    
    % Find the position of the maximum recombination rate and return the
    % corresponding Jd and F
    [maxR, maxI] = max(R);
    Jd_sol = Jd(maxI);
    F_sol = F(maxI);
    
    fprintf('R chosen: %f\n', maxI);
    fprintf('Jd_sol: %f\n', Jd_sol);
    fprintf('F_sol: %f\n', F_sol);
    
    % Calculate the current density through the PSC current source
    J = par.Jsc - Jd_sol * exp(-F_sol/par.VT);
end