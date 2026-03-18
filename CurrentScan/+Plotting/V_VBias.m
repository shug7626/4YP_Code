% Voltage - Bias Voltage Plot

function fig = V_VBias(res)
    fig = figure(3);
    tiledlayout(1,3);
    ax1 = nexttile;
    plot(res.V, res.V1);
    xlabel('Bias Voltage (V)');
    ylabel('V1 (V)');
    title('Cell 1 Voltage');
    yline(0);

    ax2 = nexttile;
    plot(res.V, res.V2);
    xlabel('Bias Voltage (V)');
    ylabel('V2 (V)');
    title('Cell 2 Voltage');
    yline(0);

    ax3 = nexttile;
    plot(res.V, res.Vs);
    xlabel('Bias Voltage (V)');
    ylabel('Vs (V)');
    title('Combined Series Resistor Voltage');
    yline(0);

    linkaxes([ax1, ax2, ax3], 'y');
end