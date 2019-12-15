function u = ljapunov_based(t, q_p, x_hat, Q, P, x, xhat, sys)
    is_positive(Q);
    is_positive(P);

    H = sys.dyn.H;
    h = sys.dyn.h;
    Z = sys.dyn.Z;
    
    C = sys.kin.C;
    
    p = sys.kin.p{end};
    q = sys.kin.q;
    
    model_params = sys.descrip.model_params;
    syms_plant = sys.descrip.syms;

    Hp = dmatdt(H, q, C*p);

    omega_T = p.'*Z;
    omega = omega_T.';
    
    x_hat_s = sym('xhat_', size(x));
    
    x_tilde = x - x_hat;
    x_q = jacobian(x, q);
    
    alpha = simplify_((1/2*omega_T*omega)*(p.'*(H + 2*Hp)*p + ...
            x_tilde.'*(Q*x_tilde - 2*P*x_q*C*p) ...
            - 2*p.'*h));
    
    u = -alpha*omega;
    
    syms_params = [q.', p.', x_hat_s.', syms_plant];
    num_params = [q_p', x_hat', model_params];
    
    u = double(subs(u, syms_params, num_params));
end