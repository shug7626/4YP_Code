% Function to return the photo generation current for the silicon cell

function [Jsc, res] = calculate_si_Jsc(bs2, par, res, spectrums)
    % Calculate the widths
    res.Wn = (par.thick2n * 1e-6) - (res.wn * 1e-2);                 % (m)
    res.Wp = (par.thick2p * 1e-6) - (res.wp * 1e-2);

    % Generate the array of integrations for the p-type (front)
    p_func = @(a) integral(@(x) Methods.calculate_front_int(x, par, res.Wp, a), 0, res.Wp, 'ArrayValued', true);
    res.int_res_p = arrayfun(p_func, spectrums.Si(:, 2));

    % Calculate the array of integrations for the n-type (rear)
    n_func = @(a) integral(@(x) Methods.calculate_rear_int(x, res.Wn, res.Wp, par, res, a), 0, res.Wn, 'ArrayValued', true);
    res.int_res_n = arrayfun(n_func, spectrums.Si(:, 2));

    % Calculate the array of integrations for the depletion region
    d_func = @(a) integral(@(x) Methods.calculate_d_int(x, a), res.Wp, res.Wp + ((res.wp + res.wn)*1e2), 'ArrayValued', true);
    res.int_res_d = arrayfun(d_func, spectrums.Si(:, 2));

    % Calculate the current due to the bulk p-type
    Jp = par.q * sum(bs2 .* spectrums.Si(:,2) .* res.int_res_p);        % (A cm-2)

    % Calculate the current due to the bulk n-type
    Jn = par.q * sum(bs2 .* spectrums.Si(:,2) .* res.int_res_n);

    % Calculate the current due to the depletion region
    Jd = par.q * sum(bs2 .* spectrums.Si(:,2) .* res.int_res_d);

    % % Return the total current density
    Jsc = Jp + Jn + Jd;
end