function hfig = plot_constraints(sys, time, states)
    [m, ~] = size(sys.kin.A);
    
    n_q = length(sys.kin.q);
    n_p = length(sys.kin.p);
    
    n_t = length(time);
    unhol = zeros(n_t, n_p);
    
    q_s = sys.kin.q;
    qp_s = sys.kin.qp;
    
    syms = sys.descrip.syms;
    model_params = sys.descrip.model_params;
    
    [q, qp, p] = states_to_q_qp_p(sys, states);
    
    Aqps = sym([]);
    p_n_curr = p';
    
    for j = n_p:-1:1
        A_curr = sys.kin.A{j};
        
        if(j == 1)
            p_s_curr = qp_s;
        else
            p_s_curr = sys.kin.p{j-1};
        end
        
        C = sys.kin.C{j};
        
        Aqps = [Aqps; A_curr*p_s_curr];
        
        for i = 1:n_t
            q_n = q(i, :);

            p_n = vpa(subs(C*p_n_curr, [q_s', syms], [q_n, model_params]));
            
            qp_pars_s = [q_s; p_s_curr; syms.'];
            qp_pars_n = [q_n'; p_n(:, i); model_params'];
            consts = vpa(subs(A_curr*p_s_curr, ...
                              qp_pars_s, qp_pars_n));

            unhol(i, j) = double(consts);
        end
        
        p_n_curr = vpa(subs(C*p_n_curr, syms, model_params));
    end
        
    titles = {};
    xlabels = {};
    
    acc = 0;
    for i = 1:n_p 
        [m, ~] = size(sys.kin.A{j});
        
        for j = 1:m
            idx = acc + j;
            
            constraint = latex(Aqps(idx));
            
            titles{end+1} = sprintf('Constraint %d - $%s$', ...
                                    idx, constraint);
            xlabels{end+1} = '$t$ [s]';
        end
        
        acc = acc + m;
    end
        
    plot_info.titles = titles;
    plot_info.xlabels = xlabels;
    plot_info.ylabels = titles;
    plot_info.grid_size = [2, 1];
    
    hfig = my_plot(time, unhol, plot_info);
end