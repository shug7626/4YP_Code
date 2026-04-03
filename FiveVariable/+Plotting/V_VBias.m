% Voltage across the various components for each applied voltage

function fig = V_VBias(res, setting)
    % Clear the figure if already open
    clf(figure(3));

    % Set the axes numbers font sizes
    set(groot, 'defaultAxesFontSize', setting.axes_numbers);

    % Plot in figure 3
    fig = figure(3);
    tiledlayout(1,3);

    % Plot the voltage across the PVK source
    ax1 = nexttile;
    plot(res.V, res.V1, 'LineWidth', setting.line_width);
    xline(0);
    yline(0);
    title('PSC Generation Voltage', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.title_font);
    xlabel('Bias Voltage $\left(\mathrm{V}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    ylabel('PSC Generaition Voltage $\left(\mathrm{V}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);

    % Plot the voltage across the Si source
    ax2 = nexttile;
    plot(res.V, res.V2, 'LineWidth', setting.line_width);
    xline(0);
    yline(0);
    title('Silicon Generation Voltage', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.title_font);
    xlabel('Bias Voltage $\left(\mathrm{V}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    ylabel('Silicon Generation Voltage $\left(\mathrm{V}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);

    % Plot the voltage across the series resistors
    ax3 = nexttile;
    plot(res.V, res.v_s, 'LineWidth', setting.line_width);
    xline(0);
    yline(0);
    title('Combined Series Resistor Voltage', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.title_font);
    xlabel('Bias Voltage $\left(\mathrm{V}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    ylabel('Combined Series Resistor Voltage $\left(\mathrm{V}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);

    % Link the axes
    linkaxes([ax1, ax2, ax3], 'x');
    linkaxes([ax1, ax2, ax3], 'y');
end