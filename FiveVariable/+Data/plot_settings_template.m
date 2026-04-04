% Function to tell the main program which plots to produce

function set = plot_settings()
    % Plots font sizing
    set.title_font = 18;
    set.axes_font = 14;
    set.axes_numbers = 12;

    % Line Widths
    set.line_width = 2;
    set.small_line_width = 1.5;
    
    % J-V plots
    set.plot_j_v = 1;

    % Voltage area plot
    set.plot_V_area = 1;

    % Voltage - voltage plots
    set.plot_v_v = 1;

    % P-V plot
    set.plot_p_v = 1;

    % Spectrums plot
    set.plot_spectrum = 1;
    set.individual_spectrums = 1;
    set.total_spectrum = 0;
end