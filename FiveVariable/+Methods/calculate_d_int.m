% Function to return the function to be integrated to calculate the
% generation rate in the silicon depletion region

function ret = calculate_d_int(x, a)
    ret = exp(-1 * a * x);
end