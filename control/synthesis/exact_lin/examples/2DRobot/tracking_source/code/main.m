clear all
close all
clc

run('~/github/Robotics4fun/examples/2D_unicycle/code/main.m');

clearvars -except sys
clear_inner_close_all(pwd);

% Initial conditions
x0 = [1; 1; 0; 1; 1; 1];

T_cur = 0.1;
T_traj = 0.5;
lambda = 1;
nu = 2;
zeta = 1;
sigma = 0.5;
xhat_0 = x0(1:2);

% Source estimation parameters
sestimation_info.xhat_0 = x0(1:2);
sestimation_info.nu = nu;
sestimation_info.zeta = zeta;
sestimation_info.sigma = sigma;
sestimation_info.oracle = @(x) x(1)^2 + x(2)^2;
sestimation_info.source_reference = sys.kin.q(1:2);
sestimation_info.lambda = lambda;
sestimation_info.T_cur = T_cur;

% Trajectory planning
trajectory_info.T_traj = T_traj;
trajectory_info.dt = 0.001;

mu = 25;
poles_ = {-mu*ones(3, 1), ...
          -mu*ones(3, 1)};

n_tf = 20;
tf = n_tf*T_cur;
dt = trajectory_info.dt;
time = 0:dt:tf;

traj_type = 'line';
[t, simOut] = sim('control_law.slx');


%     % Trajectory generation
%     traj_type = traj_types{i};
%     T = T_cur;
% 
%     n_diff = 3;
%     alphaA = 0.5;
%     alphaB = 0.5;
%     trajectory_info.gentraj_fun = ...
%         @(t, P0, P1, theta0) traj_t(t, T, P0, P1, theta0, traj_type, sys);
% 
%     % n_Ts = 5;
%     % options.Ts = n_Ts*trajectory_info.dt;
%     options.sigma_noise = 0.5;
%     % 
%     % n_f = 2;
%     % frequency = 2*pi/(n_f*T_cur);
%     % amplitude = 1;
%     % 
%     % options = struct('frequency', frequency, ...
%     %                  'amplitude', amplitude);
%     % 
%     % options = struct('');
% 
%     % Control law arguments
%     control_info.control_fun = ...
%         @(t, q_p, refs, qp_symbs, refs_symbs) ...
%         compute_control(t, q_p, refs, qp_symbs, refs_symbs, sys, poles_, options);
% 
%     % System modelling
%     u_func = @(t, q_p) ...
%         control_handler(t, q_p, sestimation_info, ...
%                         trajectory_info, control_info, sys);
%     
%     n_tf = 20;
%     tf = n_tf*T_cur;
%     dt = trajectory_info.dt;
%     time = 0:dt:tf;
%     sol = validate_model(sys, time, x0, u_func, true);
%     time = time';
%     sol = sol';
% 
%     run('plot_simulation.m')
%     wb_.update_waitbar(i, length(traj_types));