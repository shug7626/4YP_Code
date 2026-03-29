% Current density - Voltage Plot

function fig = J_V(res)
    % Clear data from the figure if already open
    clf(figure(1));

    % Plot in figure 1
    fig = figure(1);
    tiledlayout(1, 3);

    % Plot the total cell J-V curve
    ax1 = nexttile;
    plot(res.V, res.J);
    xline(0);
    yline(0);
    title('PVK-Si Tandem Cell Current Density - Voltage');
    xlabel('Bias Voltage (V)', 'Interpreter', 'latex');
    ylabel('Current Density (mA $\text{cm}^{-1}$)', 'Interpreter', 'latex');

    % Plot cell 1's J-V curve
    ax2 = nexttile;
    plot(res.V1T, res.J);
    xline(0);
    yline(0);
    title('Cell 1 J-V');
    xlabel('Cell 1 Voltage (V)', 'Interpreter', 'latex');
    ylabel('Cell 1 Current Density (mA $\text{cm}^{-1}$)', 'Interpreter', 'latex');

    % Plot cell 2's J-V curve
    ax3 = nexttile;
    plot(res.V2T, res.J);
    xline(0);
    yline(0);
    title('Cell 2 J-V');
    xlabel('Cell 2 Voltage (V)', 'Interpreter', 'latex');
    ylabel('Cell 2 Current Density (mA $\text{cm}^{-1}$)', 'Interpreter', 'latex');

    % Set the y-axis to the same for all three plots
    linkaxes([ax1 ax2 ax3], 'y');
end