function Y_rcpnd=COP_Ycpnd2_fruitfly3(alpha)
%% (1) 针对旋转轴气动力矩——求解净压心的无量纲位置Y_cpnd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R=16.0148-0.88=15.1348;
% 当 r_nd∈(0.88/15.1348,13.4427/15.1348)
% clear all; clc;
R_wingeff=3.004;    %有效翅膀长度(mm) 
xr=0.3289;                     % x-root offset  \mm
xr_nd=xr/R_wingeff;      % x-root offset  无量纲展向偏置距离
C_avereff=0.8854;         % mm    
% yr=0.73;                     % RJ Wood设计的翅膀—\mm
yr=0;                              % 扭转轴通过翅根与翅尖的连线—\mm
yr_nd=yr/C_avereff;       % y-root offset  无量纲弦向偏置距离 yr_nd = 0.0214;
% % 翅根-偏离-坐标系原点的距离
% R_proximal=xr;                                               % xr=3.19;     %RJ Wood设计的翅膀—\mm
% R_distal=R_wingeff+xr;                                   % yr=0.73;    %RJ Wood设计的翅膀—\mm
% x=linspace(R_proximal,R_distal,200);
% yr_lead=-0.08249*x.^6+0.9167*x.^5-4.04*x.^4+8.872*x.^3-10.06*x.^2+5.674*x-0.413;  
% yr_trail=-0.0333*x.^6+0.504*x.^5-2.795*x.^4+7.258*x.^3-8.769*x.^2+3.739*x+0.1282;
syms r_nd
% 下面是翅前缘函数——针对扭转轴的位置不同需要进行分段函数处理
yr_leadnd=(-0.08249*r_nd^6+0.9167*r_nd^5-4.04*r_nd^4+8.872*r_nd^3-10.06*r_nd^2+5.674*r_nd-0.413)/C_avereff; 
% 无量纲弦长分布为6阶多项式
Cr_nd2 =-40.827*r_nd^6+87.2061*r_nd^5-59.4281*r_nd^4+11.8648*r_nd^3-3.75417*r_nd^2+4.938*r_nd-0.0000578229;
C_nd=Cr_nd2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wing_kenimatics=kenimatics_wing_and_AoA();        %调用函数kenimatics_wing_and_AoA
% % size(wing_kenimatics)     %  (400*16)
% alpha=wing_kenimatics(:,4);
d_cprnd=0.82*abs(alpha)/pi+0.05;                  %旋转轴气动力矩的弦向压心位置;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yr_cpnd=yr_nd+yr_leadnd-C_nd*d_cprnd;
fx2=(r_nd+xr_nd)^2*C_nd;                  % 无量纲气动力F_nd的原始被积函数
fx4=expand(fx2);
F_nd=double(int(fx4,r_nd,0,1));           % Result: F_nd=0.46392
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 无量纲气动力分量(nondimention_aerodynamic_component)的求解——F_nd
% 注意——该段程序切记不得修改，前提只要保证输入正确的无量纲弦长分布即可。
%以下的公式应使用合理的无量纲的弦长分布公式C_nd
% R2nd2=double(int(r_nd^2*C_nd,r_nd,0,1)); %二阶面积矩的回转半径的平方
% R1nd1=double(int(r_nd*C_nd,r_nd,0,1));     %一阶面积矩的回转半径
% % S_nd=double(int(C_nd,r_nd,0,1));                %无量纲翅面积
% F_nd2=R2nd2+2*xr_nd*R1nd1+xr_nd^2;    %使用这句计算结果也正确; 输出:F_nd2 =0.5024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Y_rcpnd=int(yr_cpnd*fx4,r_nd,0,1)/F_nd;
% disp(['净压心的无量纲位置Y_cpnd(alpha)=' num2str(Y_rcpnd)  ' 量纲单位可能是mm'])
% Y_rcpnd=abs(double(int(yr_cpnd*fx4,r_nd,0,1))/F_nd);
Y_rcpnd=double(int(yr_cpnd*fx4,r_nd,0,1))/F_nd;  % 与上面一句的指令得到的结果一致

