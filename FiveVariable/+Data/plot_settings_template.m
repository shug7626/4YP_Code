% Function to tell the main program which plots to produce

function set = plot_settings()
    % Options
    set.title = 0;
    
    % Plots font sizing
    set.title_font = 24;
    set.axes_font = 22;
    set.axes_numbers = 16;
    set.legend_font = 16;

    % Line Widths
    set.line_width = 2;
    set.small_line_width = 1.5;
    
    % J-V plots
    set.plot_j_v = 1;

    % Voltage area plot
    set.plot_V_area = 0;

    % Voltage - voltage plots
    set.plot_v_v = 0;

    % P-V plot
    set.plot_p_v = 0;

    % Spectrums plot
    set.plot_spectrum = 0;
    set.individual_spectrums = 1;
    set.total_spectrum = 0;

    % Absorption diagram plot
    set.plot_absorption = 0;
    set.absorption_N = 10000;

    % PSC internal potential drops plots
    set.plot_internal_PSC = 1;
end