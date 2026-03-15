% File for storing settings needed to run the main script incl. displaying
% certain plots

function s = plot_settings()
    % Plot the J-V curves for the total device and cell 1 and 2
    s.plot1 = 1;
    
    % Plot the voltage area plot
    s.plot2 = 0;
    
    % Plot the voltage - bias voltage plots
    s.plot3 = 0;
    
    % Plot the power - voltage plot
    s.plot4 = 1;
    
    % Plot the spectrums
    s.plot5 = 1;
    s.individual_spectrums = 1;
    s.total_spectrum = 0;
end