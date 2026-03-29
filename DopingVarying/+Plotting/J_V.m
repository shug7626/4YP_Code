% Current density - Voltage Plot

function fig = J_V(res, setting)
    % Clear data from the figure if already open
    clf(figure(1));

    % Set the axes numbers font sizes
    set(groot, 'defaultAxesFontSize', setting.axes_numbers);

    % Plot in figure 1
    fig = figure(1);
    tiledlayout(1, 3);

    % Plot the total cell J-V curve
    ax1 = nexttile;
    plot(res.V, res.J, 'LineWidth', setting.line_width);
    xline(0);
    yline(0);
    title('PVK-Si Tandem Cell Current Density - Voltage', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.title_font);
    xlabel('Bias Voltage (V)', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    ylabel('Current Density $\left(\mathrm{mA~cm}^{-1}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);

    % Plot cell 1's J-V curve
    ax2 = nexttile;
    plot(res.V1T, res.J, 'LineWidth', setting.line_width);
    xline(0);
    yline(0);
    title('Cell 1 J-V', 'Interpreter', 'latex', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.title_font);
    xlabel('Cell 1 Voltage (V)', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    ylabel('Cell 1 Current Density $\left(\mathrm{mA~cm}^{-1}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);

    % Plot cell 2's J-V curve
    ax3 = nexttile;
    plot(res.V2T, res.J, 'LineWidth', setting.line_width);
    xline(0);
    yline(0);
    title('Cell 2 J-V', 'Interpreter', 'latex', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.title_font);
    xlabel('Cell 2 Voltage (V)', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    ylabel('Cell 2 Current Density $\left(\mathrm{mA~cm}^{-1}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);

    % Set the y-axis to the same for all three plots
    linkaxes([ax1 ax2 ax3], 'y');
end