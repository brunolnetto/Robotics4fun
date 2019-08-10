% Author: Bruno Peixoto
% Date: 08/01/19

clear all
close all
clc

syms g u;

% Body 1
syms m R real;
syms x y th phi real;
syms xp yp thp phip real;
syms xpp ypp thpp phipp real;

Is = sym('I', [3, 1], 'real');
I = diag(Is);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x; y; 0]);
T2 = T3d(th, [0; 0; 1], [0; 0; 0]);
T3 = T3d(phi, [0; -1; 0], [0; 0; 0]);
T4 = T3d(0, [0; 0; 1], [0; 0; R]);
Ts = {T1, T2, T3, T4};

% Friction between current and previous body
is_friction_linear1 = false;

% CG position relative to body coordinate system
L = [0; 0; 0];

% Generalized coordinates
sys.q = [x; y; th; phi];
sys.qp = [xp; yp; thp; phip];
sys.qpp = [xpp; ypp; thpp; phipp];

% Previous body
previous = struct('');

wheel = build_body(m, I, Ts, L, {}, {}, ...
                   sys.q, sys.qp, sys.qpp, ...
                   previous, []);
sys.bodies = wheel;

% Gravity utilities
sys.gravity = [0; 0; -g];
sys.g = g;

% Paramater symbolics of the system
sys.syms = [m, R, Is.', g];

% Penny data
m_num = 2.5e-3;
R_num = 9.75e-3;
sys.model_params = [2.5e-3, 9.75e-3, ...
                    m_num*R_num^2/2, ...
                    m_num*R_num^2/4, ...
                    m_num*R_num^2/2, ...
                    9.8];

% External excitations
sys.Fq = [0; 0; 0; 0];
sys.u = u;

% State space representation
sys.states = [x; y; th; phi];

% Constraint condition
sys.is_constrained = true;

% Nonholonomic constraints
sys.unhol_constraints = xp*sin(th) - yp*cos(th);

% Kinematic and dynamic model
sys = kinematic_model(sys);

% Mere simplification due ill-formed column
% It may appear depending of the system
sys.C(:, 1) = sin(th)*sys.C(:, 1);

sys = dynamic_model(sys);

% Time [s]
dt = 0.1;
tf = 5;
t = 0:dt:tf; 

% Initial conditions [m; m/s]
x0 = ones(size(sys.dyn.f));

% System modelling
sol = validate_model(sys, t, x0, 0);

x = sol.x.';
y = sol.y.';
y = [y(:, 1), y(:, 4), ...
     y(:, 2), y(:, 5), ...
     y(:, 3), y(:, 6)];

% Plot configuration properties
plot_info.titles = {'$x$', '$\dot x$', ...
                    '$y$', '$\dot y$', ...
                    '$\theta$', '$\dot \theta$', ...
                    '$\phi$', '$\dot \phi$'};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$x$', '$\dot x$', ...
                    '$y$', '$\dot y$', ...
                    '$\theta$', '$\dot \theta$', ...
                    '$\phi$', '$\dot \phi$'};
plot_info.grid_size = [4, 2];

% States and energies plot
hfigs_states = my_plot(x, y, plot_info);
hfig_energies = plot_energies(sys, x, y);

% Energies
saveas(hfig_energies, '../images/energies', 'epsc');

for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../images/states', num2str(i)], 'epsc'); 
end