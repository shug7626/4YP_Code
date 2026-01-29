function jv = idealPower(v, J_sc, J_0, VT)
    j = idealCurrent(v, J_sc, J_0, VT);
    jv = j * v;
end