% Voltage Area Plot

function fig = V_Area(res)
    fig = figure(2);
    Y = [(res.V1T.') (res.V2T.')];
    x = res.V;
    area(x, Y);

    % Add a bold line to show the sum
    hold on;
    V_Total = res.V1T + res.V2T;
    plot(x, V_Total, 'k-', 'LineWidth', 3);

    xline(res.Voc1 + res.Voc2, 'r');
    yline(res.Voc1 + res.Voc2, 'r');
    xlabel('Bias Voltage (V)');
    ylabel('Voltage Components');
    legend({'V1T','V2T','Total Voltage'});
end