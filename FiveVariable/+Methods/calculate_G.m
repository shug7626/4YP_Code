% Function to return the generation rate for a given input spectrum,
% absorptivity spectrum and depth, x

function G = calculate_G(x, a, in)
    G = sum(in .* (1 - exp(-1 * a * x)));
end