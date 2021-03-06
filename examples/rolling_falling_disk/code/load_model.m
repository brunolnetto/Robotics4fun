if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

syms g f_psi f_phi f_th;

% Body 1
syms m R real;
syms x y th phi psi real;
syms xp yp thp phip psip real;
syms xpp ypp thpp phipp psipp real;

Is = sym('I', [3, 1], 'real');
I = diag(Is);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x; y; 0]);
T2 = T3d(th, [0; 0; 1], [0; 0; 0]);
T3 = T3d(psi, [1; 0; 0], [0; 0; 0]);
T4 = T3d(0, [0; 0; 1], [0; 0; R]);
T5 = T3d(phi, [0; -1; 0], [0; 0; 0]);
Ts = {T1, T2, T3, T4, T5};

% CG position relative to body coordinate system
L = [0; 0; 0];

% Generalized coordinates
sys.kin.q = [x; y; th; phi; psi];
sys.kin.qp = [xp; yp; thp; phip; psip];
sys.kin.qpp = [xpp; ypp; thpp; phipp; psipp];

% Previous body
previous = struct('');

wheel = build_body(m, I, Ts, L, {}, {}, ...
                   sys.kin.q, sys.kin.qp, sys.kin.qpp, ...
                   previous, []);
sys.descrip.bodies = {wheel};

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

sys.descrip.latex_origs = {{'xpp'}, ...
                           {'\mathrm{xp}'}, ...
                           {'x_pos'}, ...
                           {'ypp'}, ...
                           {'\mathrm{yp}'}, ...
                           {'y_pos'}, ...
                           {'thetapp'}, ...
                           {'thetap'}, ...
                           {'\mathrm{theta}'}, ...
                           {'\mathrm{phipp}'}, ...
                           {'\mathrm{phip}'}, ...
                           {'\mathrm{phi}'}, ...
                           {'\mathrm{p1}'}, ...
                           {'\mathrm{p2}'}, ...
                           {'\mathrm{p3}'}};

sys.descrip.latex_text = {'\ddot{x}', '\dot{x}', 'x', ...
                          '\ddot{y}', '\dot{y}', 'y', ...                          
                          '\ddot{\theta}', ...
                          '\dot{\theta}', ...
                          '\theta', ...
                          '\ddot{\phi}', ...
                          '\dot{\phi}', ...
                          '\phi', ...
                          '\, \mathrm{v}', ...
                          '\omega_{\theta}', ...
                          '\, \mathrm{\omega_{\phi}}'};

% Paramater symbolics of the system
sys.descrip.syms = [m, R, Is.', g];

% Penny data
% m_num = 2.5e-3;
% R_num = 9.75e-3;
m_num = 1;
R_num = 1;
sys.descrip.model_params = [m_num, R_num, ...
                            m_num*R_num^2/2, ...
                            m_num*R_num^2/4, ...
                            m_num*R_num^2/2, ...
                            9.8];

% External excitations
sys.descrip.Fq = [0; 0; f_th; f_phi; f_psi];
sys.descrip.u = [f_th; f_phi; f_psi];

% State space representation
sys.descrip.states = [x; y; th; phi; psi];

% Constraint condition
sys.descrip.is_constrained = true;

% Nonholonomic constraints
sys.descrip.unhol_constraints = xp*sin(th) - yp*cos(th);

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

A = [1, 0, -R, 0];
sys = constrain_system(sys, A);