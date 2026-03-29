% Power density - Voltage Plot

function fig = P_V(res, setting)
    % Clear the previous power-voltage plot if open
    clf(figure(4));

    % Set the axes numbers font size
    set(groot, 'defaultAxesFontSize', setting.axes_numbers);
    
    % Plot in figure 4
    fig = figure(4);

    % Plot the total Power density - Voltage
    plot(res.V, res.J.*res.V, 'LineWidth', setting.line_width);
    xline(0);
    yline(0);
    title('PVK-Si Tandem Cell Power Density - Voltage', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.title_font);
    xlabel('Bias Voltage $\left(\mathrm{V}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    ylabel('Power Density $\left(\mathrm{mW~cm}^{-2}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
end