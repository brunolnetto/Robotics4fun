function u_struct = control_calc(sys, control_info)
    V_degree = control_info.V_degree;
    P = control_info.P;
    W = control_info.W;
    eta = control_info.eta;

    is_positive(W);
    is_diagonal(W);
    
    % Main dynamic matrices
    p = sys.kin.p{end};
    q = sys.kin.q;
    H = sys.dyn.H;
    C = sys.kin.C;
    x = sys.kin.q(1:2);
    h = sys.dyn.h;
    u = sys.descrip.u;
    Z = sys.dyn.Z;
    
    n_q = length(q);
    n_u = length(u);
    n_p = length(p);
    
    % Control utils
    q_hat = sym('qhat_', [n_q, 1]);
    p_hat = sym('phat_', [n_p, 1]);
    qp_hat = sym('qphat_', [n_q, 1]);
    pp_hat = sym('pphat_', [n_p, 1]);
    
    f = [C*p; -inv(H)*h];
    G = [zeros(n_q, n_u); inv(H)*Z];
    
    % x and p errors
    e_q = q - q_hat;
    e_p = p - p_hat;

    % Ljapunov function and its derivative
    V = e_p.'*H*e_p + e_q.'*P*e_q;
    Vp = -eta*V;
    
    L_f_v = lie_diff(f, V, [q; p]);
    L_G_v = lie_diff(G, V, [q; p]);

    model_params = sys.descrip.model_params;
    syms_plant = sys.descrip.syms;

    u_struct.L_f_v = simplify_(vpa(subs(L_f_v, syms_plant, model_params)));
    u_struct.L_G_v = simplify_(vpa(subs(L_G_v, syms_plant, model_params)));
    u_struct.Vp = simplify_(vpa(subs(Vp, syms_plant, model_params)));
    u_struct.W = W;
end