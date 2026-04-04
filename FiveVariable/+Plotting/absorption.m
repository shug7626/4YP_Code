% Function to plot an absorption diagram

function fig = absorption(res, par, s, setting)
    % Clear data from the figure if already open
    clf(figure(6));

    % Set the axes numbers font sizes
    set(groot, 'defaultAxesFontSize', setting.axes_numbers);

    % Plot in figure 6
    fig = figure(6);



    %% Calculate the solar cell structure
    thicks = [par.thick1*1e-3, res.Wp*1e6, res.wp*1e4, res.wn*1e4, res.Wn*1e6]; % (um)
    depths = cumsum(thicks);

    % Layer depth vector
    depth = linspace(0, sum(thicks), setting.absorption_N);
    
    
    
    %% Plot the spectrum through the cell layers
    yyaxis right;
    
    % Create a spectrum vector
    spectrum = zeros(size(depth));

    % Find the positions of the layers in the depth vector
    layer_pos = sum(depth' <= depths, 1);

    % Plot the total incident spectrum
    yline(sum(s.bs), ...
            'DisplayName', 'Cumulative Incident Spectrum', ...
            'LineWidth', setting.line_width);
    hold on;

    % Calculate the spectrum at the top of the PVK
    bs_pvk_front = s.bs .* (1 - s.PVK(:, 3));
    % yline(sum(bs_pvk_front));

    % Create a function for the spectrum through the PVK
    spectrum_pvk_func = @(x) sum(bs_pvk_front .* exp(-1 .* s.PVK(:, 2) * 1e-4 .* x));
    % Loop through the pvk depths
    for iter = 1:layer_pos(1)
        spectrum(iter) = spectrum_pvk_func(depth(iter));
    end

    % % Plot the spectrum at the bottom of the pvk
    % a1 = 1 - exp(-s.PVK(:,2) * par.thick1 * 1e-7);
    % bs_pvk_rear = bs_pvk_front .* (1 - a1);
    % yline(sum(bs_pvk_rear));

    % % Plot the spectrum at the top of the silicon
    % yline(sum(res.bs2));

    % Create a function for the spectrum through the silicon
    spectrum_si_func = @(x) sum(res.bs2 .* exp(-1 * s.Si(:, 2) * 1e-4 .* (x - depth(layer_pos(1)))));
    % Loop through the si depths
    for iter = layer_pos(1) + 1:layer_pos(end)
        spectrum(iter) = spectrum_si_func(depth(iter));
    end

    % Plot the spectrum
    plot(depth, spectrum, ...
            'DisplayName', 'Cumulative Spectrum', ...
            'LineWidth', setting.line_width);

    % Right y-axis label
    ylabel('Cumulative Spectrum', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);



    %% Plot the absorption through the cell layers
    yyaxis left;

    % Create an absorption vector
    absorption = zeros(size(depth));

    % Calculate the PVK electron generation (all absorbed photons)
    absorption(1:layer_pos(1)-1) = spectrum(1:layer_pos(1)-1) - spectrum(2:layer_pos(1));

    % Calculate the bulk p-type generation
    bulk_p_func = @(x) ((spectrum(x) - spectrum(x+1)) ...
        * Methods.collect_prob((depth(layer_pos(2)) - depth(x))*1e-4, par.Sfront, par.Ln2, par.Dn2, res.Wp*1e2));
    for iter = layer_pos(1)+1:layer_pos(2)
        absorption(iter) = bulk_p_func(iter);
    end

    % Calculate the Si depletion region generation (all absorbed)
    absorption(layer_pos(2):layer_pos(4)-1) = ...
        spectrum(layer_pos(2):layer_pos(4)-1) - ...
        spectrum(layer_pos(2)+1:layer_pos(4));

    % Calculate the bulk n-type generation
    bulk_n_func = @(x) ((spectrum(x) - spectrum(x+1)) ...
        * Methods.collect_prob((depth(layer_pos(4)) + depth(x))*1e-4, par.Srear, par.Lp2, par.Dp2, res.Wn*1e2));
    for iter = layer_pos(4):length(depth)-1
        absorption(iter) = bulk_n_func(iter);
    end

    % Plot the absorption
    plot(depth, absorption, ...
            'DisplayName', 'Electrons Generated', ...
            'LineWidth', setting.line_width);
    
    % Left y-axis label
    ylabel('Electrons Generated', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);



    %% Title and xlabel
    title('Absorption Through the Solar Cell Layers', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.title_font);
    xlabel('Solar Cell Layer Depth $\left(\mu\mathrm{m}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    
    % Add a legend
    legend();
    


    %% Plot the Cell Structure
    % xline(0);
    xline(depths, 'HandleVisibility', 'off');
    hold off;
end