% Function to return the photo generation current for the silicon cell

function [Jsc, res] = calculate_si_Jsc(bs2, par, res, spectrums)
    % Calculate the widths
    Wn = (par.thick2n * 1e-6) - (res.wn * 1e2);                 % (m)
    Wp = (par.thick2p * 1e-6) - (res.wp * 1e2);

    % Generate the array of integrations for the p-type (front)
    p_func = @(a) integral(@(x) Methods.calculate_front_int(x, par, Wp, a), 0, Wp, 'ArrayValued', true);
    int_res_p = -1 * arrayfun(p_func, spectrums.Si(:, 2));

    % Calculate the array of integrations for the n-type (rear)
    n_func = @(a) integral(@(x) Methods.calculate_rear_int(x, Wn, Wp, par, res, a), 0, Wn, 'ArrayValued', true);
    int_res_n = -1 * arrayfun(n_func, spectrums.Si(:, 2));

    % Calculate the array of integrations for the depletion region
    d_func = @(a) integral(@(x) Methods.calculate_d_int(x, a), Wp, (Wp + (res.wp + res.wn)*1e2), 'ArrayValued', true);
    int_res_d = arrayfun(d_func, spectrums.Si(:, 2));

    % Calculate the current due to the bulk p-type
    Jp = par.q * sum(bs2 .* spectrums.Si(:,2) .* int_res_p);

    % Calculate the current due to the bulk n-type
    Jn = par.q * sum(bs2 .* spectrums.Si(:,2) .* int_res_n);

    % Calculate the current due to the depletion region
    Jd = par.q * sum(bs2 .* spectrums.Si(:,2) .* int_res_d);

    % % Return the total current density
    Jsc = Jp + Jn + Jd;
end