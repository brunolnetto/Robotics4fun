function out1 = controlfun(p1,p2,p2_d,pp1_d,pp2_d,x1,x2,x1_d,x2_d)
%CONTROLFUN
%    OUT1 = CONTROLFUN(P1,P2,P2_D,PP1_D,PP2_D,X1,X2,X1_D,X2_D)

%    This function was generated by the Symbolic Math Toolbox version 6.2.
%    04-Sep-2019 07:33:32

out1 = p1.*-4.9749371855331+p2.*1.931491328626033e-2+p2_d.*4.95562227224684+pp1_d.*1.190121941870692+pp2_d.*1.190121941870692+x1.*1.794840369449168-x2.*7.99852932342548e-1+sign(p1.*-1.959698194110669e-1+p2.*3.804208905044948e-3+p2_d.*1.921656105060219e-1-x1.*9.798490970553345e-1-x2.*3.843312210120439e-2+x1_d.*9.798490970553345e-1+x2_d.*3.843312210120439e-2).*(abs(x1).*1.920770490071207+abs(x2).*1.046149509733627+1.0).*5.07724832373056;