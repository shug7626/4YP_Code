% Area plot showing the components of the voltage

function fig = V_Area(res, setting)
    % Clear figure 2 if already open
    clf(figure(2));

    % Set the axes numbers font sizes
    set(groot, 'defaultAxesFontSize', setting.axes_numbers);
    
    % Plot in figure 2
    fig = figure(2);
    Y = [(res.V1T.') (res.V2T.')];
    x = res.V;
    area(x, Y);

    % Add a bold line to show the sum of the voltages
    hold on;
    V_total = res.V1T + res.V2T;
    plot(x, V_total, 'k-', 'LineWidth', setting.line_width);

    % Add lines to show the open circuit voltage of the entire cell
    xline(res.Voc1 + res.Voc2, 'r');
    yline(res.Voc1 + res.Voc2, 'r');

    % Add a legend
    lgd = legend({'V1T','V2T','Total Voltage'});
    lgd.FontSize = setting.legend_font;

    % Tile and labels
    title('Voltage Contribution from the Two Layers', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.title_font);
    xlabel('Bias Voltage $\left(\mathrm{V}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    ylabel('Voltage Components $\left(\mathrm{V}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
end