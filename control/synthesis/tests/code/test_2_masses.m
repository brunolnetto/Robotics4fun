clear all
close all
clc

run('~/github/Robotics4fun/examples/2_masses/code/main.m');

% Params and parameters estimation
model_params = sys.descrip.model_params.';
perc = 0;
imprecision = perc*ones(size(sys.descrip.syms))';
params_lims = [(1-imprecision).*model_params, ...
               (1+imprecision).*model_params];

% Control action
eta = 1;
poles = [-5, -5];
u = sliding_underactuated(sys, eta, poles, params_lims);

len_params = length(sys.descrip.model_params);

% Initial values
x0 = [0; 0; 0; 0];

% Tracking values
x_xp_d = [1; 1; 0; 0];
xpp_d = [0; 0];

x_d = [x_xp_d; xpp_d];

alpha_ = u.alpha;
lambda = u.lambda;

G = [alpha_, lambda];

error = x0 - x_xp_d;

s0 = G*error;
x_s_0 = [x0; s0];

% Initial conditions
tf = 5;
tspan = [0, tf];
df_h = @(t, x) df_sys(t, x, x_d, u, sys, tf);

sol = ode45(df_h, tspan, x_s_0);

% mdlname = 'sliding_mode_MIMO';
% tf = 3;
% tf = num2str(tf);
% 
% simOut = sim(mdlname, 'SaveOutput','on','OutputSaveName','sim_out', ...
%                       'SimulationMode','normal','AbsTol','1e-5', ...
%                       'StopTime', tf, 'FixedStep','0.01');
% 
% % Plot part
% img_path = '../imgs/';
% 
% xref = simOut.get('x_ref');
% x = simOut.get('x');
% u_ = simOut.get('u');
% s = simOut.get('s');
% 
% q_p = [sys.kin.q; sys.kin.p];
% n = length(q_p);
% 
% % Reference plot
% plot_config.titles = repeat_str('', n + n/2);
% plot_config.xlabels = repeat_str('', n + n/2);
% plot_config.ylabels = {'$x_1^d$ [m]', '$\dot{x}_1^d$ [m/s]', ...
%                        '$\ddot{x}_1^d$ [m/$s^2$]', ...
%                        '$x_2^d$ [m]', '$\dot{x}_2^d$ [m/s]', ...
%                        '$\ddot{x}_2^d$ [m/$s^2$]'};
% plot_config.grid_size = [2, 3];
% 
% t = xref.time;
% xref_ = xref.signals.values;
% xref_ = [xref_(:, 1), xref_(:, 3), xref_(:, 5), ...
%         xref_(:, 2), xref_(:, 4), xref_(:, 6)];
% 
% hfigs_xref = my_plot(t, xref_, plot_config);
% 
% % Input plot 
% plot_config.titles = {''};
% plot_config.xlabels = {'t [s]'};
% plot_config.ylabels = {'$u$ [N]'};
% plot_config.grid_size = [1, 1];
% 
% control_ = u_.signals.values;
% 
% hfigs_u = my_plot(t, control_, plot_config);
% 
% % States plot
% plot_config.titles = repeat_str('', n);
% plot_config.xlabels = repeat_str('t [s]', n);
% plot_config.ylabels = {'$x_1$ [m]', '$\dot{x}_1$ [m/s]', ...
%                        '$x_2$ [m]', '$\dot{x}_2$ [m/s]'};
% plot_config.grid_size = [2, 2];
% 
% t = x.time;
% x_ = x.signals.values;
% x_ = [x_(:, 1), x_(:, 3), x_(:, 2), x_(:, 4)];
% 
% hfigs_x = my_plot(t, x_, plot_config);
% 
% % Sliding function plot
% plot_config.titles = {''};
% plot_config.xlabels = {'t [s]'};
% plot_config.ylabels = {'Sliding function s'};
% plot_config.grid_size = [1, 1];
% 
% t = s.time;
% sliding  = s.signals.values;
% 
% hfigs_s = my_plot(t, sliding, plot_config);
% 
% close all
% 
% x = [sys.kin.q; sys.kin.p];
% x_d = add_symsuffix([sys.kin.q; sys.kin.p; sys.kin.pp], '_d');
% 
% x_xd = [x; x_d];


% % Reference
% saveas(hfigs_xref, '../imgs/xref.eps', 'eps');
% 
% % States
% saveas(hfigs_x, '../imgs/x.eps', 'eps');
% 
% % States
% saveas(hfigs_u, '../imgs/u.eps', 'eps');
% 
% % Sliding function
% saveas(hfigs_s, '../imgs/s.eps', 'eps');