function j = idealCurrent(v, J_sc, J_0, VT)
    j = J_sc - J_0*(exp(v/VT) - 1);
end