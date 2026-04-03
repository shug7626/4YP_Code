% Script to store the fuction which returns the value of Q(nu)

function Q = evaluate_Q(nu, p, res)
    Q = res.Q0 * sign(nu) * sqrt(exp(nu/p.VT) - (nu/p.VT) - 1);
end