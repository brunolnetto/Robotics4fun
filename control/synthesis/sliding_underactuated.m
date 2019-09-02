function u = sliding_underactuated(sys, etas, poles, params_lims)    
    params_hat_n = sys.descrip.model_params';
    [n, m] = size(sys.dyn.Z);
    
    for i = 1:m
        param_lims = params_lims(i, 1:2);
        param_hat = params_hat_n(i);
        
        if((param_hat >= param_lims(1)) || (param_hat <= param_lims(2)))
            continue;
        else
            error('Estimation parameters MUST be within interval!');
        end
    end
    
    % Matrices size
    [n, m] = size(sys.dyn.Z);
        
    params_s = sys.descrip.syms.';
    params_hat_s = add_symsuffix(params_s, '_hat');
        
    [alpha_a, alpha_u, lambda_a, lambda_u] = alpha_lambda(poles, m, n);
    [Ms_s, fs_s] = Ms_fs(sys, alpha_a, alpha_u);
    [s, sr, sr_p] = s_sr_srp(sys, alpha_a, alpha_u, lambda_a, lambda_u);
    
    % Parameter limits
    params_min = params_lims(1, :);
    params_max = params_lims(2, :);
    
    fs_hat_s = subs(fs_s, params_s, params_hat_s);
    Ms_hat_s = subs(Ms_s, params_s, params_hat_s);
    
    q_p = [sys.kin.q; sys.kin.p];

    % Dynamics uncertainties
    Fs = dynamics_uncertainties(fs_s, fs_hat_s, q_p, params_s, ...
                                params_hat_s, params_lims);
                            
    % Mass matrix uncertainties
    [D, D_tilde] = mass_uncertainties(Ms_s, Ms_hat_s, q_p, params_s, ...
                                      params_hat_s, params_lims);
    
    % Gains
    k = simplify_(inv(eye(m) - D_tilde)*(Fs + ...
                  D*abs(sr_p + fs_hat_s) + etas));
    k = subs(k, params_hat_s, params_hat_n);
    
    K = vpa(diag(k));
        
    Ms_hat_n = subs(Ms_hat_s, params_hat_s, params_hat_n);
    fs_hat_n = subs(fs_hat_s, params_hat_s, params_hat_n);
    
    % Control output
    u_control = -inv(Ms_hat_n)*(fs_hat_n + sr_p + K*sign(s));
    u.output = vpa(u_control);
    
    % Manifold parameters
    u.lambda = lambda_n;
    u.alpha = alpha_n;
    
    u.C = C;
    
    % Dynamics approximations
    u.Ms_s = Ms_s;
    u.Ms_hat_n = Ms_hat_n;
    
    u.fs = fs_s;
    u.fs_hat = fs_hat_s;
    
    % Maximum and minimum of mass matrix and dynamic vector
    u.D = D;
    u.D_tilde = D_tilde;
    u.Fs = Fs;
    
    % Sliding surface
    u.s = s;
       
    u.sr = sr;
    u.sr_p = sr_p;
        
    u.params = params_s;
    u.params_hat = params_hat_s;
    
    u.eta = etas;
end

