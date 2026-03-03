% Power - Voltage Plot

function fig = P_V(res)
    fig = figure(4);
    plot(res.V, res.J.*res.V);
    xline(0);
    yline(0);
    xlabel('Bias Voltage (V)');
    ylabel('Power Density (mW/cm2)');
    title('Tandem Si-Si Power Density - Voltage Plot');
end