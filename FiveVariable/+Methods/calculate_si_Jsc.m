% Function to return the photo generation current for the silicon cell

function Jsc = calculate_si_Jsc(bs2, par, res, spectrums)
    % Calculate the widths
    Wn = (par.thick2n * 1e-6) - (res.wn * 1e2);                 % (m)
    Wp = (par.thick2p * 1e-6) - (res.wp * 1e2);

    % Generate the array of integrations for the n-type
    n_func = @(a) integral(@(x) Methods.calculate_np_int([x, Wn - x], par.Lp2, par.Srear, par.Dp2, Wn, a), 0, Wn, 'ArrayValued', true);
    int_res_n = arrayfun(n_func, spectrums.Si(:,2));

    % % Calculate the array of integrations for the p-type
    % int_res_p = arrayfun(@(c) integral(@(x) Methods.calculate_np_int([x, x - Wn - res.wn - res.wp], par.Ln2, par.Sfront, par.Dn2, Wp, c), Wn + res.wn + res.wp, Wn + res.wn + res.wp + Wp, 'ArrayValued', true), spectrums.wavelengths);

    % % Calculate the array of integrations for the depletion region
    % int_res_d = arrayfun(@(c) integral(@(x) Methods.calculate_d_int(x, c), Wn, Wn + res.wn + res.wp, 'ArrayValued', true), spectrums.wavelengths);

    % Calculate the current due to the bulk n-type
    Jn = par.q * sum(bs2 .* spectrums.Si(:,2) .* int_res_n);

    % % Calculate the current due to the bulk p-type
    % Jp = par.q * sum(bs2 .* spectrums.Si(:,1) .* int_res_p);

    % % Calculate the current due to the depletion region
    % Jd = par.q * sum(bs2 .* spectrums.Si(:,1) .* int_res_d);

    % % Return the total current density
    % Jsc = Jn + Jd + Jp;
    Jsc = Jn;
end