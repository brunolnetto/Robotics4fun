clear all
close all
clc
% The 'real' statement on end is important
% for inner simplifications
syms u Q I Ip real;
syms L R C g real;

% Paramater symbolics of the system
sys.descrip.syms = [R, L, C];

% Paramater symbolics of the system
sys.descrip.model_params = [0.5, 19e-3, 25e-6];

% Gravity utilities
sys.descrip.gravity = [0; 0; 0];
sys.descrip.g = g;

% Body inertia
I_ = zeros(3, 3);

% Position relative to body coordinate system
L0 = zeros(3, 1);

% Bodies definition
T = {T3d(0, [0, 0, 1].', [Q; 0; 0])};

damper = build_damper(R, [0; 0; 0], [I; 0; 0]);
spring = build_spring(1/C, [0; 0; 0], [Q; 0; 0]);
block = build_body(L, I_, T, L0, damper, spring, ...
               Q, I,Ip, struct(''), []);

sys.descrip.bodies = block;

% Generalized coordinates
sys.kin.q = Q;
sys.kin.qp = I;
sys.kin.qpp = Ip;

% External excitations
sys.descrip.Fq = u;
sys.descrip.u = u;

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = Ip;

% State space representation
sys.descrip.states = [Q; I];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Decay time
m_num = sys.descrip.model_params(1);
b_num = sys.descrip.model_params(2);
T = m_num/b_num;

% Time [s]
tf = 0.05;
dt = 0.0001;
t = 0:dt:tf; 

% Initia conditions [m; m/s]
x0 = [0; 1];

% % System modelling
% sol = validate_model(sys, t, x0, 0);
% x = sol';
% 
% titles = {'', ''};
% xlabels = {'$t$ [s]', '$t$ [s]'};
% ylabels = {'$Q$ [C]', '$i$ [A]'};
% grid_size = [2, 1];
% 
% % Plot properties
% plot_info.titles = titles;
% plot_info.xlabels = xlabels;
% plot_info.ylabels = ylabels;
% plot_info.grid_size = grid_size;
% 
% [hfigs_states, hfig_energies] = plot_sysprops(sys, t, x, plot_info);
% 
% % Energies
% saveas(hfig_energies, '../images/energies.eps', 'epsc');
% 
% % States
% for i = 1:length(hfigs_states)
%    saveas(hfigs_states(i), ['../images/states', num2str(i), '.eps'], 'epsc'); 
% end
