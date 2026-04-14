% Area plots of the internal potential drops in the PSC

function figs = V_PSC_internal(res, setting)
    % Set the axes numbers font sizes
    set(groot, 'defaultAxesFontSize', setting.axes_numbers);
    
    %% Sum
    % Clear figure 7 if open
    clf(figure(7));

    % Plot in figure 7
    fig1 = figure(7);
    Y = [res.V_internal(4,:)' res.V_internal(3,:)' res.V_internal(2,:)' res.V_internal(1,:)'];
    x = res.V1;
    area(x(2:end), Y(2:end,:));

    % Add lines to show built-in voltage
    yline(res.Vbi1, 'LineWidth', setting.line_width);
    xline(res.Vbi1, 'LineWidth', setting.line_width);
    xline(0);

    % Add a legend
    legend({'$V_4$','$V_3$','$V_2$','$V_1$','Built-in Voltage'}, ...
        'Interpreter', 'latex', ...
        'FontSize', setting.legend_font);
    % lgd1.FontSize = setting.legend_font;

    % Title and labels
    if setting.title
        title('PSC Internal Potential Drops', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.title_font);
    end
    xlabel('PSC Voltage $\left(\mathrm{V}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    ylabel('Potential drops $\left(\mathrm{V}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    
    %% Proportion
    % Clear figure 8 if open
    clf(figure(8));

    % Plot in figure 8
    fig2 = figure(8);
    Y_sum = sum(Y, 2);
    Y = Y ./ Y_sum;
    area(x(2:end),Y(2:end,:));

    % Add lines to show built-in voltage
    % yline(res.Vbi1, 'LineWidth', setting.line_width);
    xline(res.Vbi1, 'LineWidth', setting.line_width);

    % Add a legend
    legend({'$V_4$','$V_3$','$V_2$','$V_1$','Built-in Voltage'}, ...
        'Interpreter', 'latex', ...
        'FontSize', setting.legend_font);

    % Title and labels
    if setting.title
        title('Proportion of PSC Internal Potential Drops', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.title_font);
    end
    xlabel('PSC Voltage $\left(\mathrm{V}\right)$', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    ylabel('Proportion of total drop', ...
        'Interpreter', 'latex', ...
        'FontSize', setting.axes_font);
    

    figs = [fig1, fig2];
end