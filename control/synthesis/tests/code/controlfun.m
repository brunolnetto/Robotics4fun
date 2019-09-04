function out1 = controlfun(u)
%CONTROLFUN
%    OUT1 = CONTROLFUN(P1,P2,P2_D,PP1_D,PP2_D,X1,X2,X1_D,X2_D)

%    This function was generated by the Symbolic Math Toolbox version 6.2.
%    04-Sep-2019 10:00:04

x1_d = u(1);
x2_d = u(2);
p1_d = u(3);
p2_d = u(4);
pp1_d = u(5);
pp2_d = u(6);

x1 = u(7);
x2 = u(8);
p1 = u(9);
p2 = u(10);

out1 = p1.*-3.196117556349771-p2.*7.844702253990846e-1+...
       p2_d.*4.980587781748856+pp1_d.*1.196117556349771+...
       pp2_d.*1.196117556349771+x1.*1.803882443650229-...
       x2.*8.038824436502288e-1-...
       sign(0.1959698194110668922895968080411*p1 - ...
       0.0038042089050449481683890962102623*p2 - ...
       0.1959698194110668922895968080411*p1_d + ...
       0.0038042089050449481683890962102623*p2_d + ...
       0.97984909705533451695913527146331*x1 + ...
       0.038433122101204394244115641433587*x2 - ...
       0.97984909705533451695913527146331*x1_d - ...
       0.038433122101204394244115641433587*x2_d).*5.102826562810659;
