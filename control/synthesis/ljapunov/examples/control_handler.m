function u = control_handler(t, q_p, sestimation_info, ...
                             trajectory_info, control_info, sys_)

    xhat = source_estimation(t, q_p, sestimation_info, sys_);
    
    u = run_control_law(t, q_p, xhat, sestimation_info, ...
                        control_info, trajectory_info, sys_);
end