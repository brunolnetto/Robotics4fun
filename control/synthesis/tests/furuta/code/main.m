clear all
close all
clc

run('~/github/Robotics4fun/examples/furuta_pendulum/code/main.m');

% Params and parameters estimation
perc = 10/100;

model_params = sys.descrip.model_params.';
imprecision = zeros(length(sys.descrip.model_params));

params_lims = [(1-imprecision).*model_params, ...
               (1+imprecision).*model_params];

rel_qqbar = sys.kin.q(1);

n = length(sys.kin.q);
m = length(sys.descrip.u);

% Control action
eta = ones(m, 1);
poles = -ones(m, 1);
u = sliding_underactuated(sys, eta, poles, params_lims, rel_qqbar, false);

len_params = length(sys.descrip.model_params);

% Initial values
x0 = [0; 0; 0; 0];

% Saturation parameter
phi = 1;

% Tracking values
q_p_ref_fun = @(t) [0; 0; 0; 0; 0; 0];

% Initial conditions
tf = 0.01;
dt = 1e-5;
tspan = 0:dt:tf;
df_h = @(t, x) df_sys(t, x, q_p_ref_fun, u, sys, tf);
sol = my_ode45(df_h, tspan, x0);

[m, ~] = size(sys.dyn.Z);

% Plot part
img_path = '../imgs/';

x = sol(1:end, :);

t_len = length(tspan);

q_p_s = [sys.kin.q; sys.kin.p];
q_p_d_s = add_symsuffix([q_p_s; sys.kin.pp], '_d');

[~, m] = size(sys.dyn.Z);

u_n = zeros(t_len, m);

q_p = [sys.kin.q; sys.kin.p];
n = length(q_p);

% States plot
plot_config.titles = repeat_str('', n);
plot_config.xlabels = repeat_str('t [s]', n);
plot_config.ylabels = {'$Q$ [C]', '$i$ [A]'};
plot_config.grid_size = [1, 2];

hfigs_x = my_plot(tspan, x', plot_config);

% Input plot
plot_config.titles = {'', ''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u$ [V]'};
plot_config.grid_size = [1, 1];

t = linspace(0, tf, length(u_control));
hfigs_u = my_plot(t, u_control, plot_config);

% Sliding function plot
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'Sliding function $s$'};
plot_config.grid_size = [1, 1];

s = [];

alpha_ = u.alpha;
lambda = u.lambda;

t = linspace(0, tf, length(sliding_s));
hfigs_s = my_plot(t, sliding_s, plot_config);

% States
saveas(hfigs_x, '../imgs/x.eps', 'epsc');

% States
saveas(hfigs_u, '../imgs/u.eps', 'epsc');

% Sliding function
saveas(hfigs_s, '../imgs/s.eps', 'epsc');