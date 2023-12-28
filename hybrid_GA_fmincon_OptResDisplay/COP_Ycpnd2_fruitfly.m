function Y_rcpnd=COP_Ycpnd2_fruitfly(alpha,xr0,C_maxyaxis)   % 输入变量是C_maxyaxis和xr0, 不用含有R和C_aver;
% 修改时间——2014年12月21日,23:36
% 修改时间——2015年01月20日,11:16
%转动轴偏离弦向中点的偏移量坐标,在扭转轴向上偏移C_maxy之后
%% (1) 针对旋转轴气动力矩——求解净压心的无量纲位置Y_cpnd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R=16.0148-0.88=15.1348;
% 当 r_nd∈(0.88/15.1348,13.4427/15.1348)
% clear all; clc;  
R_wingeff=3.004;          %有效翅膀长度(mm) 
C_avereff=0.8854;         % mm
% xr=0.3289;                 % x-root offset  \mm
xr=xr0;                           % ————————————————————被更新
xr_nd=xr/R_wingeff;      % x-root offset  无量纲展向偏置距离
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 翅根-偏离-坐标系原点的距离
R_proximal=xr;                                                    % xr=3.19;     %RJ Wood设计的翅膀—\mm
R_distal=R_wingeff+xr;                                        % yr=0.73;    %RJ Wood设计的翅膀—\mm
x=linspace(R_proximal,R_distal,200);
x_mod_Root=0.636;                                            % mm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C_maxylb=0.464385778290230;
% C_maxy25=0.138924474377504;  % 针对程序wing_model_88_yaxis有: 第122行; C_maxy =0.1389; 
% C_maxyub=-0.186536829535222; 
% C_maxy=C_maxylb;
% C_maxy=C_maxy25;
C_maxy=C_maxyaxis;      % ————————————————————被更新
% C_maxy=C_maxyub;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 原始果蝇翅膀 R_wing=3.004;  C_aver=0.8854;   
C_lead_ymax=0.4644;   % C_trail_ymin =-0.8374;  
C_max_LtoT= 1.3018;    % @C_maxy=0;
% Ratio_leadmax=C_lead_ymax/C_max_LtoT; %Ratio_leadmax=0.4644/1.3018=0.356737; %针对翅根和翅尖连线的扭转轴定出的前缘
% x_start=[3.004,0.8854,0.3289,0.356737]; % 初始值. % 未优化的果蝇翅膀形貌参数——翅根和翅尖连线的扭转轴定出的前缘
% C_lead_ymax =0.3255;  C_trail_ymin =-0.9764;  C_max_LtoT =1.3018;
% Ratio_leadmax=C_lead_ymax/C_max_LtoT; %Ratio_leadmax=0.3255/1.3018=0.25;%针对扭转轴位于最大前缘点和最新后缘点坐标间距0.25倍时
% x_start=[3.004,0.8854,0.3289,0.25];     % 初始值. % 未优化的果蝇翅膀形貌参数——扭转轴位于最大前缘点和最新后缘点坐标间距0.25倍时
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C_maxy=C_lead_ymax-C_maxy*C_max_LtoT;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yr_lead=-0.08249*x.^6+0.9167*x.^5-4.04*x.^4+8.872*x.^3-10.06*x.^2+5.674*x-0.413-x_mod_Root-C_maxy;  
yr_trail=-0.0333*x.^6+0.504*x.^5-2.795*x.^4+7.258*x.^3-8.769*x.^2+3.739*x+0.1282-x_mod_Root-C_maxy;
% C_rx=yr_lead-yr_trail;      % 正确——量纲化实际弦长分布
% 采用前缘拟合函数求解——实际平均弦长=面积/R_wingeff
% wing_aera=trapz(x,C_rx);             %输出: wing_aera =2.6597; % mm^2
% C_aver=wing_aera/R_wingeff    % 输出量纲化平均弦长: C_avereff=C_aver =0.8854; % mm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (a) 无量纲前缘分布函数
r_nd=(x-xr)/R_wingeff;
yr_leadnd0=yr_lead/C_avereff;
P_coeff_lead=polyfit(r_nd,yr_leadnd0,6);
% (b)  无量纲后缘分布函数
yr_trailnd0=yr_trail/C_avereff;
% P_coeff_trail=polyfit(r_nd,yr_trailnd0,6);
% (c)  无量纲弦长分布函数
Cr_nd=yr_leadnd0-yr_trailnd0;
P_coeff_Cr=polyfit(r_nd,Cr_nd,6);  % 多项式系数  % Cr_nd2=polyval(Coeff,r_nd1);
syms r_nd   % 无量纲弦长分布为6阶多项式——转换必须有这条指令
yr_leadnd=vpa(poly2sym(P_coeff_lead,r_nd),6); 
% yr_trailnd=vpa(poly2sym(P_coeff_trail,r_nd),6);
C_nd=vpa(poly2sym(P_coeff_Cr,r_nd),6);  
% % 方案(1)——由前后缘函数的无量纲化yr_leadnd——yr_trailnd——求得
% 下面是翅前缘函数——针对扭转轴的位置不同需要进行分段函数处理吗?
% yr_leadnd =-68.4639*r_nd^6+208.297*r_nd^5-245.231*r_nd^4+137.467*r_nd^3-36.8594*r_nd^2+4.79235*r_nd-0.156071;
% yr_trailnd =-27.6379*r_nd^6+121.093*r_nd^5-185.804*r_nd^4+125.603*r_nd^3-33.1053*r_nd^2-0.145527*r_nd-0.156013;
% 无量纲弦长分布为6阶多项式
% C_nd =-40.826*r_nd^6+87.204*r_nd^5-59.4267*r_nd^4+11.8645*r_nd^3-3.75408*r_nd^2+4.93788*r_nd-0.0000578215;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wing_kenimatics=kenimatics_wing_and_AoA();        %调用函数kenimatics_wing_and_AoA
% % size(wing_kenimatics)     %  (400*16)
% alpha=wing_kenimatics(:,4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d_cprnd=0.82*abs(alpha)/pi+0.05;                    %旋转轴气动力矩的弦向压心位置;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % alpha1=(0.25-0.05)*pi/0.82*180/pi                % alpha1=43.9024;
% Ratio_axistr =0.2834;   % 平动环量展向压心对应的片条的扭转轴到前缘的无量纲距离
% alpha1=(Ratio_axistr-0.05)*pi/0.82*180/pi;        % alpha1=51.2341;  
% Ratio_axisrot=0.2706;  % 转动环量展向压心对应的片条的扭转轴到前缘的无量纲距离
% alpha2=(Ratio_axisrot-0.05)*pi/0.82*180/pi;      % alpha2=48.4244;  
% alpha_crit=[+19.5295,-26.2696, 93.28874372]*pi/180;  % 几何攻角的几个临界值
% d_cprnd_crit=0.82*abs(alpha_crit)/pi+0.05;        % 旋转轴气动力矩的弦向压心位置;
% % output: d_cprnd_crit =[0.1390    0.1697    0.4750];  % 环量压心变化的上下限区间
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% yr_cpnd=yr_nd+yr_leadnd-C_nd*d_cprnd;  
yr_cpnd=yr_leadnd-C_nd*d_cprnd;  
fx2=(r_nd+xr_nd)^2*C_nd;                  % 无量纲气动力F_nd的原始被积函数
fx4=expand(fx2);
F_nd=double(int(fx4,r_nd,0,1));           % Result: F_nd=0.46392
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
Y_rcpnd=double(int(yr_cpnd*fx4,r_nd,0,1))/F_nd;

