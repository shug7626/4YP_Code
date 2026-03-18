% Current - Voltage Plot

function fig = J_V(res)
    fig = figure(1);
    tiledlayout(1,3);

    ax1 = nexttile;
    plot(res.V,res.J);
    xline(0);
    yline(0);
    xlabel('Bias Voltage (V)');
    ylabel('Current Density (mA/cm2)')
    title('Tandem Si-Si Current Density - Voltage Plot');

    ax2 = nexttile;
    plot(res.V1T,res.J);
    xline(0);
    yline(0);
    xlabel('Cell 1 Voltage (V)');
    ylabel('Cell 1 Current Density (mA/cm2)');
    title('Cell 1 J - V');

    ax3 = nexttile;
    plot(res.V2T,res.J);
    xline(0);
    yline(0);
    xlabel('Cell 2 Voltage (V)');
    ylabel('Cell 2 Current Density (mA/cm2)');
    title('Cell 2 J - V');

    linkaxes([ax1, ax2, ax3], 'y');
end