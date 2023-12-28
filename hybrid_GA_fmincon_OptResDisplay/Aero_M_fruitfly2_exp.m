function P_total=Aero_M_fruitfly2_exp(x) % x是变量——% variable=[R_wingeff,C_avereff,xr,C_maxy];
%% 气动力矩: Solution of the aerodynamic moment
% 修改时间——2014年12月23日,21:58——转动轴偏离弦向中点的偏移量坐标,在扭转轴向上偏移C_maxy之后
% 考虑翅膀重力矩——针对第二种角速度情况下
% 2014年6月20日,14:54:46
% 2014年6月20日,2:02:08
% 注意单位——(N.m)—*10^6—(mN.mm)=(uN.m)
% clear all;clc;
% tic                             % Elapsed time is 99.240238 seconds.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 调用含翅形貌参数化和气动力系数的函数
% wing_para_output=zeros(1,16);
% wing_para_output=[F_ndTrans,Coeff_liftdragF_N,M_xaercoeff,I1y,Z_rnd, M_xrdcoeff,...
%     F_ndRot,F_yrotcoeff,M_xRotcoeff, I2y,...
%     I_xzam,I_xxam, I5z,I6z,I7y,M_zrdcoeff];
R_wing=x(1);
C_aver=x(2); 
xr0=x(3);
C_maxyaxis=x(4);
wing_para=wing_shape_fruitfly_sixteen_good(R_wing,C_aver,xr0,C_maxyaxis);   %调用函数wing_shape_fruitfly;  % size(wing_para)
% (1) 平动环量气动力和力矩参数
% F_ndTrans=wing_para(1,1);             % F_ndTrans=0.46391;  无量纲, 量纲化单位为mm^4
Coeff_liftdragF_N=wing_para(1,2);  % Coeff_liftdragF_N=0.00682;  %单位是mg*mm  %平动环量法向力
M_xaercoeff=wing_para(1,3);              % M_xaercoeff=0.006038;   %单位是: mg.mm^2   % 平动环量气动力矩参数——绕翅平面下的展向轴
% C_aver1=M_xaercoeff/Coeff_liftdragF_N;  % C_aver1=0.8854;
I1z=wing_para(1,4);                             % I1y=0.016158   % 单位是 mg.mm^2            % 平动环量气动力矩参数——绕翅平面下的弦向轴
% Z_rnd=wing_para(1,5);                     % Z_rnd=0.16265;  无量纲, 量纲化单位为mm
M_xrdcoeff=wing_para(1,6);                % M_xrdcoeff=0.0001839; % 单位是mg.mm^2 %转动气动阻尼力矩参数—绕翅平面下的展向轴
% (2) 转动环量气动力和力矩参数
% F_ndRot=wing_para(1,7);                % F_ndRot=0.74847;  无量纲, 量纲化单位为mm^4
F_yrotcoeff=wing_para(1,8);               % F_yrotcoeff =0.003243;  % 单位是 mg.mm   % 转动环量法向力
M_xRotcoeff=wing_para(1,9);             % M_xRotcoeff=0.002871;   % 单位是 mg.mm^2 % 转动环量气动力矩系数——绕翅平面下的展向轴
% C_aver2=M_xRotcoeff/F_yrotcoeff    % C_aver2=0.8854;
I2z=wing_para(1,10);                          % I2y=0.006943;        % 单位是 mg.mm^2            % 转动环量气动力矩参数——绕翅平面下的弦向轴
% (3) 虚质量气动力和力矩参数
I_xzam=wing_para(1,11);                    % I_xzam =0.001424  % 单位是 mg.mm^2  % 虚质量气动力矩参数——绕翅平面下的展向轴
I_xxam=wing_para(1,12);                    % I_xxam =0.000338  % 单位是 mg.mm^2  % 虚质量气动力矩参数——绕翅平面下的展向轴
I5y=wing_para(1,13);                          % I5z=0.0050926   % 单位是 mg.mm       % 虚质量气动力参数—法向力
I6y=wing_para(1,14);                          % I6z=0.00077164    % 单位是 mg.mm       % 虚质量气动力参数—法向力
I7z=wing_para(1,15);                          % I7y=0.0109056;      % 单位是 mg.mm^2   % 虚质量气动力矩参数——绕翅平面下的弦向轴
M_zrdcoeff=wing_para(1,16);             % M_zrdcoeff=0.001169; % 单位是 mg.mm^2 % 转动气动阻尼力矩参数—绕翅平面下的弦向轴
% C_max_LtoT=wing_para(1,17);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I5y=wing_para(1,13);                       % I5z=0.0050945   % 单位是 mg.mm       % 下文中I3y应该改为I5y
% I6y=wing_para(1,14);                       % I6z=0.0011         % 单位是 mg.mm       % 下文中I4y应该改为I6y
% I7z=wing_para(1,15);                       % I7y=0.0109;        % 单位是 mg.mm^2   % 下文中I5z应该改为I7z
% I1z=wing_para(1,4);                         % I1y=0.0162         % 单位是 mg.mm^2    % 下文中I7z应该改为I1z
% I2z=wing_para(1,10);                       % I2y=0.0069;         % 单位是 mg.mm^2    % 下文中I6z应该改为I2z    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 调用翅膀运动学-翅运动规律和几何攻角(AOA)等数据
% wing_m_output=[t',phi',psi',alpha',dphi',dpsi',ddphi',ddpsi',C_L',C_D',C_N1',C_T'];
wing_kenimatics=kenimatics_wing_and_AoA_fruitfly_exp();  %调用函数kenimatics_wing_and_AoA;  % size(wing_kenimatics)  % (1000,12)
t=wing_kenimatics(:,1);               % 单位是ms
phi=wing_kenimatics(:,2);           % 拍打角——单位是rad
psi=wing_kenimatics(:,3);            % 拍打角——单位是rad
alpha=wing_kenimatics(:,4);       % alpha=atan2(omega_z,-omega_y);  % 几何攻角——弧度制   %输出——有正有负
dphi=wing_kenimatics(:,5);         % 单位是rad/s
dpsi=wing_kenimatics(:,6);         % 单位是rad/s
ddphi=wing_kenimatics(:,7);      % 单位是rad/s^2
ddpsi=wing_kenimatics(:,8);       % 单位是rad/s^2
C_L=wing_kenimatics(:,9);          
C_D=wing_kenimatics(:,10);     
C_N1=wing_kenimatics(:,11);   
C_T=wing_kenimatics(:,12); 
C_N=C_N1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 在翅坐标系，采用气动力矩气动力矩系数: Omega1; Omega2; Omega3; Omega4;
% 用于第2种方法求解气动力矩—翅坐标系下(坐标系原点为翅根点O'): 气动力矩系数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % yr_lead=-0.08249*x.^6+0.9167*x.^5-4.04*x.^4+8.872*x.^3-10.06*x.^2+5.674*x-0.413; %前缘的拟合函数
% % yr_trail=-0.0333*x.^6+0.504*x.^5-2.795*x.^4+7.258*x.^3-8.769*x.^2+3.739*x+0.1282; %后缘的拟合函数
Omega1= 0.01615796930;           %单位是 mg.mm^2  ———可能会出错，还需要核对计算——偏小
Omega2 = 0.0004196574748;      %单位是 mg.mm^2  ———可能会出错，还需要核对计算
Omega3=0.006942725660;          %单位是 mg.mm^2   ———可能会出错，还需要核对计算
Omega4=0.007031892405;          %单位是 mg.mm^2   ———可能会出错，还需要核对计算
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 翅膀坐标系下的角速率和角加速率——————这组数据来自翅2DOF运动
f=188.7;    % Hz
T=1/f;        
% 翅膀坐标系下的角速度
omega_x=dpsi;                      % 展向
omega_y=dphi.*sin(psi);        % 法向(初始向左)
omega_z=dphi.*cos(psi);       % 弦向朝上
omega_h=dphi;       % 铰链的角速度% omega_h=-sqrt(omega_y^2+omega_z^2);  % 右手法则顺时针
% 翅膀坐标系下的角加速度——用于虚质量力的计算
domega_x=ddpsi;
domega_y=ddphi.*sin(psi)+dphi.*dpsi.*cos(psi);
domega_z=ddphi.*cos(psi)-dphi.*dpsi.*sin(psi); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 气动攻角和当地流场速度的计算
v_y_nonr=omega_z;     % v_y=r*dphi*cos(psi)
v_z_nonr=-omega_y;   % v_z=-r*dphi*sin(psi)
alpha2=atan2(v_y_nonr,-v_z_nonr);   % 正确——注意与下文的alpha2=atan2(omega_z,-omega_y)*180/pi; 不同
% % 由于alpha2=atan2(cot(psi))=atan2(cot(pi/2-alpha))=atan2(tan(alpha)); %这里atan2给出象限正负值，尤其是alpha>pi/2时
V_nonr=sqrt(v_y_nonr.^2+v_z_nonr.^2); % 当地来流速度V_nonr=omega_h=dphi;   % 单位是 rad/s
% figure(11)
% plot(t/T,alpha*180/pi,'r-',t/T,alpha2*180/pi,'b-.','LineWidth',2)  
% xlabel('\itNormalized time')
% ylabel('\it\alpha & AoA  (deg)')
% legend('\alpha(t)','AoA(t)')
% title('攻角AoA随时间的变化规律')
% grid on
% axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第一模块——展向扭转轴——气动力矩分量%%%%
%%%%含七部分, 分别是：%%%%%%%%%%%%%%单位: (mN.mm)或(uN.m)
%%%%第一部分——平动环量产生的气动力矩%%%%%%
%%%%第二部分——转动环量产生的气动力矩%%%%%%
%%%%第三部分——转动气动阻尼力矩%%%%%%%%%
%%%%第四部分——转动虚质量力矩%%%%%%%%%%
%%%%第五部分——扭转铰链的弹性回复力矩%%%%%%
%%%%第六部分——翅膀重力矩%%%%%%%%%%%%
%%%%第七部分——翅膀自身惯性力矩%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第一部分——平动环量产生的气动力矩—扭转轴—单位: (mN.mm)或(uN.m)
% 输入参数为：5个
% C_avereff;   R_wingeff;   F_nd;   Y_rcpnd;         ——————这组数据来自翅形貌参数化
% alpha2;   omega_h;   C_N(alpha2);                      ——————这组数据来自翅2DOF运动攻角,铰链角速率
% 平动扭转气动力矩——旋转轴气动力矩
% M_xtrans=(-sign(alpha2).*Rou.*omega_h.^2.*C_N.*C_avereff^2*R_wingeff^3*F_nd.*Y_rcpnd/2)*10^(-15); %原文公式N.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (1) 方案1——平动环量产生的转动轴力矩——压心位于扭转轴之后
F_ytran=-sign(alpha2).*abs(C_N).*V_nonr.^2*Coeff_liftdragF_N*10^(-3);   % 单位是rad^2*s^-2*mg*mm=10^(-9)N=10^(-9)*10^6uN
% 下面的单位是 (rad/s)^2*mg.mm^2=mg.mm/s^2.mm=10^(-3) uN.mm
Y_rcpnd=COP_Ycpnd2_fruitfly(alpha2,xr0,C_maxyaxis);  % 针对旋转轴气动力矩——调用函数COP_Ycpnd2_fruitfly求解净压心的无量纲位置Y_rcpnd
% Y_rcpndaver=mean(Y_rcpnd)    % Y_rcpndaver=0.1298(old); % Y_rcpndaver= - 0.0271;
M_xtrans1=-sign(alpha2).*abs(C_N).*V_nonr.^2.*Y_rcpnd*M_xaercoeff*10^(-3);    % 旋转轴气动力矩一开始是逆时针的
Z_trans1=M_xtrans1./F_ytran;    % 计算弦向力臂
% Z_transaver1=mean(Z_trans1)   % Z_transaver1=0.1149(old); % Z_transaver1= - 0.0240;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (2) 方案2——平动环量产生的转动轴力矩——压心位于扭转轴之后——扭转轴—第二种求解气动力矩的方法
% 气动力矩输入参数为：10个 %% 单位: (mN.mm)或(uN.m)
% Omega1; Omega2; Omega3; Omega4;  见前文——————这组数据来自翅形貌参数化
%%%%%%%%%%%%%%%%%%%%%%%%%
% alpha0=pi/4;     % 攻角假设为45°，求解旋转轴气动力矩弦向压心位置——暂时——调用攻角函数———XXX
d_cprnd=0.82*abs(alpha2)/pi+0.05;                  %攻角为pi/4时的旋转轴气动力矩的弦向压心位置;
% M_rotx=((Omega3*d_cprnd-Omega4).*sign(dphi).*dphi.^2.*C_N)*(10^-12*10^6); % 方向沿着扭转轴(x轴)——产生Pitching Motion
% mg.mm^2*rad*s^-2=(10^-12)kg*m*s^-2*m=10^-12N*m=10^-3 uN*mm
% k_xtranscirc=0.716;     % 该系数有问题——XXX
k_xtranscirc=0.1;     % 该系数有问题
% uN*mm % 方向沿着扭转轴(x轴)—由文献给出——注意这里(Omega3*d_cprnd-Omega4)＜0
M_xtranscirc=-k_xtranscirc*sign(alpha2).*(Omega3*d_cprnd-Omega4).*dphi.^2.*C_N*(10^-3); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(12)  
plot(t/T,M_xtrans1,'b-',t/T,M_xtranscirc,'g-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itM_{trans,x} & M_{transcirc,x} )  (uN.mm)')
legend('M_{trans,x}','M_{transcirc,x}')
title('展向(x-axis)-平动环量产生的转动轴气动力矩——对比分析')
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (3) 方案3——针对旋转轴气动力矩——变压心位置
k_xaero=1; 
N=length(t);
M_xtrans=zeros(N,1);
Y_rcpnd_trans=zeros(N,1);
for i=1:1:N
   % 输入变量是C_maxyaxis和xr0, 不用含有R和C_aver;
    Y_rcpnd_trans(i,1)=COP_Ycpnd2_TransCirc(alpha2(i,1),xr0,C_maxyaxis);  % 调用函数COP_Ycpnd2_TransCirc求解净压心的无量纲位置Y_rcpnd; % 正负交替
    %  Y_rcpnd_trans=abs(Y_rcpnd_trans(i,1));  % 正
    % 下面的单位是 (rad/s)^2*mg.mm^2=mg.mm/s^2.mm=10^(-3) uN.mm
    %  M_xaercoeff=0.0060;   %单位是: mg.mm^2
    % 平动环量产生的旋转轴气动力矩一开始是逆时针的
     % M_xtrans(i,1)=-k_xaero*sign(alpha2(i,1)).*abs(C_N(i,1)).*V_nonr(i,1).^2.*Y_rcpnd_trans(i,1)*M_xaercoeff*10^(-3);      
     M_xtrans(i,1)=-k_xaero*sign(alpha2(i,1)).*abs(C_N(i,1)).*V_nonr(i,1).^2.*Y_rcpnd_trans(i,1)*M_xaercoeff*10^(-3);  
end
% M_xrotcirc(i,1)=k_xRot*C_R*omega_x(i,1).*abs(omega_h(i,1)).*Y_rcpnd_rot(i,1)*M_xRotcoeff*10^(-3);
% F_ytran=-sign(alpha2).*abs(C_N).*V_nonr.^2*Coeff_liftdragF_N*10^(-3); 
Z_trans=M_xtrans./F_ytran;    % 计算弦向力臂
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 平动环量产生的气动力矩
figure(13)  
% plot(t/T,M_xtrans1,'b-',t/T,M_xtranscirc,'g-',t/T,M_xtrans,'r-','LineWidth',2)
plot(t/T,M_xtrans1,'b-',t/T,M_xtrans,'g-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itM_{trans1,x} & M_{transcirc,x} & M_{trans,x}  (uN.mm)')
% legend('M_{trans1,x}','M_{transcirc,x}','M_{trans,x}')
legend('M_{trans1,x}','M_{trans,x}')
title('展向(x-axis)-平动环量产生的转动轴气动力矩——对比分析')
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第二部分——转动环量产生的气动力矩——扭转轴
k_xRot=1;  
C_R=1.55;    % 该系数可以修改
% C_R=2.58;
% M_xtrans(i,1)=k_xaero*sign(alpha2(i,1)).*abs(C_N(i,1)).*V_nonr(i,1).^2.*Y_rcpnd_trans(i,1)*M_xaercoeff*10^(-3);  
% F_yrot=C_R*omega_x.*abs(omega_h)*F_yrotcoeff*10^(-3); % 单位是rad^2*s^-2*kg*m=10^(-9)N=10^(-9)*10^6uN
F_yrot=C_R*omega_x.*abs(V_nonr)*F_yrotcoeff*10^(-3);      % 单位是rad^2*s^-2*kg*m=10^(-9)N=10^(-9)*10^6uN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M_xRotcoeff=k_xRot*C_R*M_xRotcoeff;
M_xrotcirc1=omega_x.*abs(omega_h).*Y_rcpnd*M_xRotcoeff*10^(-3);
Z_rot1=M_xrotcirc1./F_yrot;           % 计算弦向力臂
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=length(t);
M_xrotcirc=zeros(N,1);
Y_rcpnd_rot=zeros(N,1);
for i=1:1:N
    % 转动环量绕扭转轴气动力矩——调用函数COP_Ycpnd2_RotCirc求解净压心的无量纲位置Y_rcpnd_rot
    % 转动环量产生的—压心分布符合Dickinson函数 or 压心在中弦点 or 压心在c(r)/4处—扭转轴力矩
    Y_rcpnd_rot(i,1)=COP_Ycpnd2_RotCirc(alpha2(i,1),xr0,C_maxyaxis); % 压心分布符合Dickinson函数: % 输入变量是C_maxyaxis和xr0, 不用含有R和C_aver;
   % Y_rcpnd_rot=abs(Y_rcpnd_rot(i,1));
   % 下面的单位是 (rad/s)^2*mg.mm^2=mg.mm/s^2.mm=10^(-3) uN.mm
   %  M_xrotcirc(i,1)=k_xRot*C_R*sign(alpha2(i,1)).*omega_x(i,1).*abs(V_nonr(i,1)).*Y_rcpnd_rot(i,1)*M_xRotcoeff*10^(-3); % 转动环量绕扭转轴气动力矩  
   M_xrotcirc(i,1)=k_xRot*C_R*omega_x(i,1).*abs(omega_h(i,1)).*Y_rcpnd_rot(i,1)*M_xRotcoeff*10^(-3);    % 转动环量绕扭转轴气动力矩
end
Z_rot=M_xrotcirc./F_yrot;           % 计算弦向力臂
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(14)  % 转动气动力矩分量, 转动阻尼力矩分量和转动环量绕扭转轴气动力矩
hold on
plot(t/T,M_xrotcirc1,'r-',t/T,M_xrotcirc,'b-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itM_{rotcirc,x})  (uN.mm)')
legend('M_{rotcirc1,x}','M_{rotcirc,x}')
title('展向(x-axis)-转动环量绕扭转轴气动力矩随时间的变化规律')
grid on
% axis([0.9,4.05,-inf,inf])
% set(gca,'XTick',(1:0.1:4.05))
axis([0.9,3,-inf,inf])
set(gca,'XTick',(1:0.1:3))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 保存随攻角变化的弦向平动环量和转动环量气动力的压心
% Z_rot=M_xrotcirc./F_yrot;           % 计算弦向力臂
% Z_trans=M_xtrans./F_ytran;        % 计算弦向力臂
Z_circ=(M_xtrans+M_xrotcirc)./(F_ytran+F_yrot);    % 计算弦向力臂
% size(Y_rcpnd_trans)
% size(Y_rcpnd_rot)
x_cop=[t,alpha2*180/pi,Y_rcpnd,Z_trans1,Y_rcpnd_trans,Z_trans,Y_rcpnd_rot,Z_rot,Z_circ]; 
xlswrite('D:\KXJ\PassiveRot_dynamic_Science_fruitfly\optimal_wing_para_motion\hybrid_GA_fmincon_OptResDisplay\x_cop.xlsx',x_cop,'sheet1','A1:I2000');
% (a) 平动环量气动力矩的弦向压心的平均值
% 下面调用函数COP_Ycpnd2_fruitfly求解净压心的无量纲位置Y_rcpnd
Y_rcpndaver=mean(Y_rcpnd)                     % Y_rcpndaver=-0.0271;
% 下面Z_trans1=M_xtrans1./F_ytran;          % 计算弦向力臂
Z_transaver1=mean(Z_trans1)                    % Z_transaver1=-0.0240;
% 下面调用函数COP_Ycpnd2_fruitfly求解净压心的无量纲位置Y_rcpnd;
Y_rcpnd_transaver=mean(Y_rcpnd_trans)   % Y_rcpnd_transaver=0.0144;%Y_rcpnd_transaver=trapz(t,Y_rcpnd_trans)/(3*T)
% 下面Z_trans=M_xtrans./F_ytran;               % 计算弦向力臂
Z_transaver=mean(Z_trans)                         % Z_transaver= 0.0127;
% (b) 转动环量气动力矩的弦向压心的平均值
% 下面调用函数COP_Ycpnd2_RotCirc求解净压心的无量纲位置Y_rcpnd_rot
Y_rcpnd_rotaver=mean(Y_rcpnd_rot)  % Y_rcpnd_rotaver=0.0133; % Y_rcpnd_rotaver=trapz(t,Y_rcpnd_rot)/(3*T) 
% 下面Z_rot=M_xrotcirc./F_yrot;                % 计算弦向力臂
Z_rotaver=mean(Z_rot)                              % Z_rotaver=0.0118;
% (c) 环量气动力矩的弦向压心的平均值
% 下面Z_circ=(M_xtrans+M_xrotcirc)./(F_ytran+F_yrot);    % 计算弦向力臂
Z_circaver=mean(Z_circ)                             % Z_circaver=0.0092;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 平动环量和转动环量气动力——弦向压心随时间变化曲线Z_rot1
figure(15) 
plot(t/T,Y_rcpnd,'b:',t/T,Z_trans1,'g-.',t/T,Y_rcpnd_trans,'b-',t/T,Z_trans,'g-',t/T,Y_rcpnd_rot,'r:',t/T,Z_rot1,'r-.',t/T,Z_rot,'r-',t/T,Z_circ,'k-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('平动环量和转动环量气动力——弦向压心与扭转轴之间的距离  (mm)')
legend('Y_{rcpnd}(t)','Z_{trans,1}(t)','Y_{rcpnd,trans}(t)','Z_{trans}(t)','Y_{rcpnd,rot}(t)','Z_{rot1}(t)','Z_{rot}(t)','Z_{circ}(t)');
title('平动环量和转动环量气动力的弦向压心随时间的变化规律')
grid on
% hold on
% % plot(t/T,F_ytran,'r-',t/T,F_yrot,'g-',t/T,F_ytran+F_yrot,'k-',t/T,M_xtrans+M_xrotcirc,'k:','LineWidth',2)
% plot(t/T,F_ytran+F_yrot,'k-',t/T,M_xtrans+M_xrotcirc,'k:','LineWidth',2)
axis([0.9,4.05,-inf,inf])
% axis([0.9,4.05,-0.3,0.3])
set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第三部分——转动气动阻尼力矩—扭转轴—单位: (mN.mm)或(uN.m)
% 气动阻尼力矩——输入参数为：2个
% C_avereff;   R_wingeff;    Z_rnd;     ——————这组数据来自翅形貌参数化
% omega_x;                                      ——————这组数据来自翅2DOF运动角速率
% (1) 方案1——转动扭转气动力矩——转动气动阻尼力矩
% M_xrd=(-omega_x.*abs(omega_x)*Rou*C_RD*C_avereff^4*R_wingeff*Z_rnd/2)*10^(-15); %原文公式 N.m
% C_RD=5.0;     %转动阻尼气动力系数:C_RD=C_rd∈(3,6); 或者C_rd=C_dmax=3.4;
C_RD=1;  
% C_RD=2;  
% uN.mm   % (rad/s)^2*mg.mm^2=mg.mm/s^2.mm=10^(-3) uN.mm
M_xrd=-C_RD*omega_x.*abs(omega_x)*M_xrdcoeff*10^(-3);   % 阻尼力矩一开始是顺时针的 % 注意这个方向取决于omega_x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (2) 方案2—— 扭转角速度产生的——转动阻尼力矩——第二种求解气动力矩的方法
% 气动力矩输入参数为：10个 %% 单位: (mN.mm)或(uN.m)
% Omega1; Omega2; Omega3; Omega4;  见前文——————这组数据来自翅形貌参数化
% M_rdampx=-(Omega2*sign(dpsi).*dpsi.^2*C_RD)*(10^-12*10^6);  % 方向沿着扭转轴(x轴)——产生Pitching Motion
% mg.mm^2*rad*s^-2=(10^-12)kg*m*s^-2*m=10^-12N*m=10^-3 uN*mm
% k_xrotdamp=0.3775;  % 当C_RD=5时;  该系数才与上面M_xrd匹配
k_xrotdamp=0.438;
M_xrotdamp=-k_xrotdamp*sign(dpsi).*Omega2.*dpsi.^2*C_RD*(10^-3);  % uN*mm % 方向沿着扭转轴(x轴)——由文献给出
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(16)  
hold on
plot(t/T,M_xrd,'k-',t/T,M_xrotdamp,'rd','LineWidth',1.5)
xlabel('\itNormalized time')
ylabel('\itM_{rd,x}  & M_{rdamp,x} )  (uN.mm)')
legend('M_{rd,x}','M_{rdamp,x}')
title('展向(x-axis)-转动阻尼力矩——对比分析') % 气动阻尼力矩随时间的变化规律
grid on
axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 对比分析——平动环量产生气动力矩和转动阻尼力矩之和的差异
figure(17)  % 两种计算方法求得的被动扭转力矩的对比 
M_xpassiverot=M_xtrans1+M_xrd;   % 被动扭转气动力矩含3种机制的气动力矩
M_totalx=M_xtranscirc+M_xrotdamp;  % 翅平面: 展向扭转轴(x轴)
plot(t/T,M_xpassiverot,'r-',t/T,M_totalx,'b-','LineWidth',2)    
xlabel('\itNormalized time')
ylabel('\itM_{passiverot,x}  &  M_{total,x}  (mN.mm)')      
legend('M_{passiverot,x}','M_{total,x}')
title('被动扭转气动力矩的总和(展向-x-axis)气动力矩随时间的变化规律')
grid on
axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第四部分——转动虚质量力矩+平动虚质量力矩—扭转轴—单位: (mN.mm)或(uN.m)
% 虚质量气动力矩输入参数为：6个——虚质量力产生的—压心在中弦点—扭转轴力矩
% I_xzam;   I_xxam;       ——————这组数据来自翅形貌参数化
% omega_x;   omega_z;   domega_x;   domega_y;   ——————这组数据来自翅2DOF运动角速率和角加速率
% 虚质量扭转气动力矩——根据果蝇翅膀修改的角速度和角加速度
% M_xam=(-I_xyam*(domega_y-omega_x*omega_z)-I_xxam*domega_x)*10^(-12); %N.m-原始公式不可用于数值计算,需要转换下
% 下面的单位是: mg.mm^2*(rad/s)^2=mg.mm/s^2.mm=10^(-3) uN.mm; %注意这样处理，是因为虚质量项中domega_x=ddpsi;  
k_am=1;   % 虚质量力矩系数; 2.35是近似上限； psi_max =32.9386
F_yadd1=(-I5y*(domega_z+omega_x.*omega_y)+I6y*domega_x)*10^(-3); 
% 虚质量力矩一开始是顺时针的，很快便成为逆时针，后接着是平动加速和转动减速至恒定，再接着是平动减速，转动加速
% M_xam=k_am*(-I_xzam*(domega_z-omega_x.*omega_y)-I_xxam*domega_x)*10^(-3);  % uN.mm 
M_xam=-k_am*(-I_xzam*(domega_z+omega_x.*omega_y)+I_xxam*domega_x)*10^(-3);   % 初始逆时针(-)
c_zcopnd_add=M_xam./F_yadd1;                              % 计算弦向力臂
% c_zcopnd_addaver=trapz(t,c_zcopnd_add)/(3*T); % c_zcopnd_addaver =-0.3058;
c_zcopnd_addaver=mean(c_zcopnd_add);                 % c_zcopnd_addaver=-0.3058; 
figure(18)                         
plot(t/T,M_xam,'r-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itM_{am,x}   (uN.mm)')
legend('M_{am,x}')
title('虚质量气动力矩随时间的变化规律')   % 虚质量气动力矩随时间的变化规律
grid on
axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第五部分—— 扭转铰链回复力矩——扭转轴
% 翅铰链参数——Paremeter of wing hinge
L_h1=70e-006;     % L_h2=175e-006;   % length of wing hinge  \um——已经换算到m
W_h=1.8e-003;                                     % width of wing hinge  \mm——已经换算到m
t_h=7.6e-006;                                       % thickness of wing hinge \um——已经换算到m
E_h=2.5e009;                                        % lmodulus of elasticity for wing hinge  \Gpa 注意单位
%下面的单位是 N/m^2*m^3*m/m=N.m=kg*m/s^2.m=mg.mm/s^2.mm:[10^12]=10^6(mN.mm)=10^9(uN.mm)
k_hinge=1.11;      % psi_max =70.4552 @ k_am=1;  % 计算的扭转角幅值≈实测扭转角幅值
k_h=k_hinge*E_h*t_h^3*W_h/(12*L_h1)*10^9;  % uN.mm;  % mg.mm/s^2.mm
M_hinge=-k_h*psi*10^(-3);    % k_h为rotational stiffness of the passive hinge  % 铰链回复力矩开始是顺时针的
% figure(19)
% plot(t/T,M_hinge,'c-')  
% xlabel('\itNormalized time')
% ylabel('\itM_{hinge}   (uN.mm)')      
% legend('M_{hinge}')
% title('铰链回复力矩(展向:x-axis)随时间的变化规律')
% grid on
% axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第六部分——翅膀重力矩——扭转轴
m_wing=2.4*10^-9;                                             % kg
g=9.821;                                                               % m/s^2=N/kg
xr=0.3289*10^-3;                                                %  \m       % x-root offset 
x_com=xr+1.920243385*10^-3;                         %  \m       % 质心的展向坐标
% z_com=-0.149785466+0.636=0.486215*10^-3;% 到扭转轴的弦向距离
z_com=0.149785466*10^-3;                               %  \m       % 到扭转轴的弦向距离
d_com=z_com;                                                    % \m        % 主意正负号
r_cog=x_com;
M_weight_x=m_wing*g*d_com*sin(psi)*10^9;   % 单位是: 10^9(uN.mm)  % 重力矩开始是顺时针的
M_weight_y=m_wing*g*r_cog*cos(psi)*10^9;
M_weight_z=-m_wing*g*r_cog*sin(psi)*10^9;
figure(20) 
plot(t/T,M_weight_x,'r-',t/T,M_weight_y,'b-',t/T,M_weight_z,'g-','LineWidth',2) 
xlabel('\itNormalized time')
ylabel('翅膀自身重力力矩分量M_{inert,x}(t) & M_{inert,y}(t) & M_{inert,z}(t) (uN.mm)'); 
legend('M_{weight,x}(t)','M_{weight,y}(t)','M_{weight,z}(t)');  
title('翅膀自身重力力矩分量M_{inert,x}(t),M_{inert,y}(t) & M_{inert,z}(t)随时间的变化')  
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第七部分——翅膀自身惯性力矩——扭转轴
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F_inert_y=-m_wing*(domega_z*x_com-domega_x*z_com+omega_y.*(omega_x*x_com+omega_z*z_com))*10^6;  % 翅膀自身惯性力—法向
F_inert_z=-m_wing*(-domega_y*x_com-omega_y.^2*z_com+omega_x.*(omega_z*x_com-omega_x*z_com))*10^6; % 翅膀自身惯性力—弦向
% 翅膀自身惯性力矩
M_inert_x=-z_com*F_inert_y*10^3;  % 展向——翅膀自身惯性力矩;  初始逆时针(-)
M_inert_z=-x_com*F_inert_y*10^3;  % 弦向——翅膀自身惯性力矩;  初始逆时针(-)
M_inert_y=x_com*F_inert_z*10^3;   % 弦向——翅膀自身惯性力矩;  初始顺时针(-)
figure(21) 
plot(t/T,M_inert_x,'k-',t/T,M_inert_z,'r-',t/T,M_inert_y,'g-','LineWidth',2) 
xlabel('\itNormalized time')
ylabel('翅膀自身惯性气动力矩分量M_{inert,x}(t) & M_{inert,z}(t) & M_{inert,y}(t) (uN.mm)'); 
legend('M_{inert,x}(t)','M_{inert,z}(t)','M_{inert,y}(t)');  
title('翅膀自身惯性气动力矩分量M_{inert,x}(t) & M_{inert,z}(t) & M_{inert,y}(t)随时间的变化')  
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  第1种方法求解—翅坐标系下：被动扭转气动力矩的总和 M_xpassive_rotation; 方向沿着扭转轴(x轴)
%翅坐标系下: 被动扭转气动力矩{方向沿着扭转轴(x轴)}: 
% M_xpassiverot=M_xtrans1+M_xrd+M_xam;                % 被动扭转气动力矩含3种机制的气动力矩
M_xaero1=M_xtrans1+M_xrd+M_xam;                           % 被动扭转气动力矩含3种机制的气动力矩
M_xaero=M_xtrans+M_xrd+M_xam+M_xrotcirc;            % 被动扭转气动力矩含4种机制的气动力矩
M_xtotal1=M_xtrans1+M_xrd+M_xam-M_hinge;                                        % -M_inert_x-M_weight
M_xtotal=M_xtrans+M_xrd+M_xam+M_xrotcirc-M_hinge;                         % -M_inert_x-M_weight
% M_xtotal1=M_xtrans1+M_xrd+M_xam-M_hinge+M_inert_x;                   % -M_weight——6项
M_xtotal2=M_xtrans+M_xrd+M_xam+M_xrotcirc-M_hinge+M_inert_x;   % -M_weight——6项
% M_xtotal1=M_xtrans1+M_xrd+M_xam-M_hinge+M_inert_x+M_weight;                    %  7项
% M_totalx=M_xtrans+M_xrd+M_xam+M_xrotcirc-M_hinge+M_inert_x+M_weight;     %  7项
%% (1)整个翅膀弦向压心计算平动环量力矩%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(22)  % 平动环量气动力矩, 转动阻尼力矩、转动环量气动力矩和虚质量力矩-绕扭转轴气动力矩
plot(t/T,M_xtrans1,'r-',t/T,M_xrd,'g-',t/T,M_xam,'b-',t/T,M_xaero1,'k-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itM_{aero1,x}  ( including M_{trans1,x}  & M_{rd,x}  &  M_{am,x} &)  (uN.mm)')
legend('M_{trans1,x}','M_{rd,x}','M_{am,x}','M_{aero1,x}')
title('展向(x-axis)-平动环量气动力矩,转动阻尼力矩,虚质量力矩和总气动力矩-随时间的变化规律')
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
% hold on
% plot(t/T,phi*180/pi,'r:',t/T,psi*180/pi,'b:',t/T,alpha2*180/pi,'g:','LineWidth',1.5)  %转换为ms 和 度数degree   *10^3   *180/pi
%% (2)特殊片条弦向压心计算平动环量力矩%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(23)  % 平动环量气动力矩, 转动阻尼力矩、转动环量气动力矩和虚质量力矩-绕扭转轴气动力矩
plot(t/T,M_xtrans,'r-',t/T,M_xrd,'g-',t/T,M_xrotcirc,'m-',t/T,M_xam,'b-',t/T,M_xaero,'k-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itM_{aero,x}  ( including M_{trans,x}  & M_{rd,x}  & M_{rotcirc,x} & M_{am,x})  (uN.mm)')
legend('M_{trans,x}','M_{rd,x}','M_{rotcirc,x}','M_{am,x}','M_{aero,x}')
title('展向(x-axis)-平动环量气动力矩,转动阻尼力矩,转动环量气动力矩,虚质量力矩及总气动力矩-随时间的变化规律')
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
% hold on
% plot(t/T,phi*180/pi,'r:',t/T,psi*180/pi,'b:',t/T,alpha2*180/pi,'g:','LineWidth',1.5)  %转换为ms 和 度数degree   *10^3   *180/pi
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(24)  % 展向(x-axis)气动力矩随时间的变化规律
plot(t/T,M_hinge,'c-',t/T,M_inert_x,'y',t/T,M_xaero1,'m-',t/T,M_xtotal1,'k-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itM_{total1,x}  ( including M_{x,aero1} & M_{hinge} & M_{inert,x})  (uN.mm)')
legend('M_{hinge}','M_{inert,x}','M_{aero1,x}','M_{total1,x}')
title('展向(x-axis)-气动力矩,铰链回复力矩和翅膀自身惯性力力矩及总力矩-随时间的变化规律')
grid on
axis([0.9,4.05,-inf,inf])
hold on
set(gca,'XTick',(0.9:0.1:4.05))
% hold on
% plot(t/T,phi*180/pi,'r:',t/T,psi*180/pi,'b:',t/T,alpha2*180/pi,'g:','LineWidth',1.5)  %转换为ms 和 度数degree   *10^3   *180/pi
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(25)  % 展向(x-axis)气动力矩随时间的变化规律
plot(t/T,M_hinge,'c-',t/T,M_inert_x,'y',t/T,M_xaero,'m-',t/T,M_xtotal,'k-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itM_{total,x}  ( including M_{x,aero} & M_{hinge} & M_{inert,x})  (uN.mm)')
legend('M_{hinge}','M_{inert,x}','M_{aero,x}','M_{total,x}')
title('展向(x-axis)-气动力矩,铰链回复力矩和翅膀自身惯性力力矩及总力矩-随时间的变化规律')
grid on
axis([0.9,4.05,-inf,inf])
hold on
set(gca,'XTick',(0.9:0.1:4.05))
% hold on
% plot(t/T,phi*180/pi,'r:',t/T,psi*180/pi,'b:',t/T,alpha2*180/pi,'g:','LineWidth',1.5)  %转换为ms 和 度数degree   *10^3   *180/pi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % figure(26)        % 图1——拍打角,扭转角和几何攻角AOA
% % plot(t/T,phi*180/pi,'r:',t/T,psi*180/pi,'b:',t/T,alpha2*180/pi,'g:','LineWidth',1.5)  %转换为ms 和 度数degree   *10^3   *180/pi
% % xlabel('\itNormalized time')
% % ylabel('\itAngle (°)')
% % legend('\it\phi(t)','\it\psi(t)','\it\alpha2(t)')
% % title('拍打角,扭转角和几何攻角AOA随时间的变化规律')   % 拍打角,扭转角和几何攻角AOA随时间的变化规律
% % grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第2种方法求解—翅坐标系下：沿着扭转轴(x轴)被动扭转气动力矩的总和M_x
figure(27)  % 平动环量气动力矩, 转动阻尼力矩、转动环量气动力矩和虚质量力矩-绕扭转轴气动力矩
plot(t/T,M_xtrans,'r-',t/T,M_xrd,'g-',t/T,M_xrotcirc,'m-',t/T,M_xam,'b-',t/T,M_hinge,'c-',t/T,M_inert_x,'y',t/T,M_xtotal2,'k-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itM_{total,x}  ( including M_{trans,x}  & M_{rd,x}  & M_{rotcirc,x} & M_{am,x} & M_{hinge} & M_{inert,x})  (uN.mm)')
legend('M_{trans,x}','M_{rd,x}','M_{rotcirc,x}','M_{am,x}','M_{hinge}','M_{inert,x}','M_{total2,x}')
title('展向(x-axis)-平动环量气动力矩,转动阻尼力矩,转动环量气动力矩,虚质量力矩,铰链回复力矩和翅膀自身惯性力力矩及总力矩-随时间的变化规律')   % 展向气动力矩随时间的变化规律
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
% hold on
% plot(t/T,phi*180/pi,'r:',t/T,psi*180/pi,'b:',t/T,alpha2*180/pi,'g:','LineWidth',1.5)  %转换为ms 和 度数degree   *10^3   *180/pi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 绕扭转轴的功率
% P_xtrans=-M_xtrans.*omega_x*10^-6;  % uN.mm*rad*s^-1=10^-9N*m*s^-1=10^-9W=10^-6mW=10^-3uW
% P_xrd=-M_xrd.*omega_x*10^-6;  % mW
% P_xrotcirc=-M_xrotcirc.*omega_x*10^-6;  % mW
% P_xam=-M_xam.*omega_x*10^-6;  % mW
% P_inert_x=-M_inert_x.*omega_x*10^-6;  % mW
% P_totalx=-M_totalx.*omega_x*10^-6;  % mW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 平动环量力矩功率  % uW
% P_xtrans=-0.1*M_xtrans.*omega_x*10^-3; 
P_xtrans=-M_xtrans.*omega_x*10^-3;  % uN.mm*rad*s^-1=10^-9N*m*s^-1=10^-9W=10^-6mW=10^-3uW
%%%%%%%%%%%%%%%%%%%%%%%%%
% 转动阻尼力矩功率  % uW
% P_xrd=-0.5*M_xrd.*omega_x*10^-3;                           % OK
% M_xrd=-C_RD*omega_x.*abs(omega_x)*M_xrdcoeff*10^(-3);   % 转动阻尼力矩
P_xrd=-M_xrd.*omega_x*10^-3;                
% P_xrd=-M_xrd.*omega_x*10^-3; 
%%%%%%%%%%%%%%%%%%%%%%%%%
% 转动环量力矩功率  % uW  
% M_xrotcirc(i,1)=k_xRot*C_R*sign(omega_x).*omega_x(i,1).*abs(omega_h(i,1)).*Y_rcpnd_rot(i,1)*M_xRotcoeff*10^(-3); %  转动环量力矩
% P_xrotcirc=-0.5*(-sign(alpha2(i,1))).*M_xrotcirc.*omega_x*10^-3;  
% P_xrotcirc=-0.5*M_xrotcirc.*abs(omega_x)*10^-3;    % OK
P_xrotcirc=-M_xrotcirc.*abs(omega_x)*10^-3; 
% P_xrotcirc=-M_xrotcirc.*omega_x*10^-3;          % 采用这个公式，则前文中M_xrotcirc(i,1)需要乘以sign(omega_x)*
%%%%%%%%%%%%%%%%%%%%%%%%%
% 虚质量力矩功率和翅膀自身惯性力矩功率  % uW
P_xam=-M_xam.*omega_x*10^-3;
P_inert_x=-M_inert_x.*omega_x*10^-3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M_totalx=M_xtrans+M_xrd+M_xrotcirc+M_xam+M_inert_x;    % 翅平面: 展向扭转轴(x轴)
% P_totalx=-M_totalx.*abs(omega_x)*10^-3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P_aerox=P_xtrans+P_xrd+P_xrotcirc+P_xam;
P_totalx=P_xtrans+P_xrd+P_xrotcirc+P_xam+P_inert_x;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(28)  % 平动环量气动力矩, 转动阻尼力矩、转动环量气动力矩和虚质量力矩-绕扭转轴的功率
plot(t/T,P_xtrans,'r-.',t/T,P_xrd,'g--',t/T,P_xrotcirc,'m:',t/T,P_xam,'b-','LineWidth',2)
hold on
plot(t/T,P_aerox,'k-','LineWidth',3)
hold on
plot([0.9,4.05],[0,0],'k-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itP_{aero,x}  ( including P_{trans,x}  & P_{rd,x}  & P_{rotcirc,x} & P_{am,x})  (uW)')
legend('P_{trans,x}','P_{rd,x}','P_{rotcirc,x}','P_{am,x}','P_{aero,x}')
title('展向(x-axis)-平动环量气动力矩,转动阻尼力矩,转动环量气动力矩,虚质量力矩及总气动力矩绕扭转轴的功率-随时间的变化规律')   % 展向气动力矩随时间的变化规律
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
% hold on
% plot(t/T,phi*180/pi,'r:',t/T,psi*180/pi,'b:',t/T,alpha2*180/pi,'g:','LineWidth',1.5)  %转换为ms 和 度数degree   *10^3   *180/pi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(29)  % 气动力矩和虚质量力矩,翅膀自身惯性力力矩及总力矩绕扭转轴的功率
plot(t/T,P_aerox,'b-',t/T,P_inert_x,'c:','LineWidth',2)
hold on
plot(t/T,P_totalx,'k-','LineWidth',3)
hold on
plot([0.9,4.05],[0,0],'k-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itP_{total,x}  ( including P_{aero,x} & P_{inert,x})  (uW)')
legend('P_{aero,x}','P_{inert,x}','P_{total,x}')
title('展向(x-axis)-气动力力矩,翅膀自身惯性力力矩及总力矩绕扭转轴的功率-随时间的变化规律')   % 展向气动力矩随时间的变化规律
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
% hold on
% plot(t/T,phi*180/pi,'r:',t/T,psi*180/pi,'b:',t/T,alpha2*180/pi,'g:','LineWidth',1.5)  %转换为ms 和 度数degree   *10^3   *180/pi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第二模块——弦向转动轴——气动力矩分量%%%%%%
%%%%含七部分, 分别是：%%%%%%%%%%%%%%单位: (mN.mm)或(uN.m)
%%%%第一部分——平动环量产生的气动力矩%%%%%%%
%%%%第二部分——转动环量气动力矩%%%%%%%%%%%
%%%%第三部分——转动虚质量力矩%%%%%%%%%%%%
%%%%第四部分——转动阻尼力矩%%%%%%%%%%%%%
%%%%第五部分——拍打轴转动铰链的弹性回复力矩%%%%
%%%%第六部分——拍打轴驱动力矩%%%%%%%%%%%%
%%%%第七部分——翅膀自身惯性力矩%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第一部分 平动环量法向气动力产生的力矩——绕翅平面下的弦向轴
% 气动力矩输入参数为：10个 %% 单位: (mN.mm)或(uN.m)
% Omega1; Omega2; Omega3; Omega4;          ——————这组数据来自翅形貌参数化
%%%%%%%%%%%%%%%%%%%%%%%%%
% % M_n=(-Omega1*sign(dphi).*dphi.^2.*C_N)*(10^-12*10^6);  % 方向沿着翅平面弦向轴(y轴)——产生bending Motion along chord
% % mg.mm^2*rad*s^-2=(10^-12)kg*m*s^-2*m=10^(-12)N*m=10^-3 uN*mm   
% M_ztrans1=sign(dphi)*Omega1.*dphi.^2.*C_N*(10^-3);  % 方向沿着翅平面弦向轴(y轴)——由文献给出——与下面相同
k_ztrans=1;  
M_ztrans=k_ztrans*sign(alpha2).*(I1z.*C_N.*omega_h.^2)*10^(-3);   % I1z=0.0162; % 单位是 mg.mm^2=10^-3uN*mm=10^-6 mN*mm
% figure(30)
% plot(t/T,M_ztrans1,'r-',t/T,M_ztrans,'g-','LineWidth',2)  
% grid on
% axis([0.9,4.05,-inf,inf])
r_xcopnd_tr=M_ztrans./F_ytran;           % 计算展向力臂
% r_xcopnd_traver=mean(r_xcopnd_tr)   %  r_xcopnd_traver=-2.3692;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第二部分 转动环量法向气动力产生的力矩——绕翅平面下的弦向轴
% C_R=1.55;    % 该系数有问题
% M_zrot=I2z*C_R*omega_x.*V_nonr*10^(-3); % V_nonr=omega_h=dphi
C_R=1.55;    % 该系数有问题
k_zrot=1;
M_zrot=-k_zrot*I2z*C_R*omega_x.*omega_h*10^(-3);  % I2z=0.0069; 单位是: mg.mm^2*(rad*s^-1)^2=10^-6mN.mm=10^-3uN.mm
r_xcopnd_rot=M_zrot./F_yrot;                          % 计算展向力臂
% r_xcopnd_rotaver=-mean(abs(r_xcopnd_rot))  % r_xcopnd_rotaver=-2.1408
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 平动环量和转动环量气动力作用的展向平均压心位置距拍打轴的距离
r_xcopnd=(M_ztrans+M_zrot)./(F_ytran+F_yrot); 
% r_xcopndaver=mean(r_xcopnd)    %r_xcopndaver=-2.9352(XXX);
% r_xcopndaver1=(r_xcopnd_traver+r_xcopnd_rotaver)/2;   % r_xcopndaver1=-2.2550;
%% 平动环量和转动环量气动力——展向压心随时间变化曲线
figure(31) 
plot(t/T,r_xcopnd_tr,'b-.',t/T,r_xcopnd_rot,'g-.',t/T,r_xcopnd,'r-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('平动环量和转动环量气动力——展向压心与扭转轴之间的距离 (mm)')
legend('r_{xcopnd,tr}(t)','r_{xcopnd,rot}(t)','r_{xcopnd}(t)')
title('平动环量和转动环量气动力——展向压心随时间的变化规律')
grid on
hold on
% plot(t/T,F_ytran,'r-.',t/T,F_yrot,'g-.',t/T,F_ytran+F_yrot,'k-',t/T,M_ztrans+M_zrot,'k:','LineWidth',2)
plot(t/T,F_ytran+F_yrot,'k-',t/T,M_ztrans+M_zrot,'k:','LineWidth',2)
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
%% 保存随攻角变化的展向平动环量和转动环量气动力的压心
% z_cop=[t,alpha2*180/pi,r_xcopnd_tr,r_xcopnd_rot,r_xcopnd]; 
% xlswrite('D:\KXJ\PassiveRot_dynamic_Science_fruitfly\optimal_wing_para_motion\hybrid_GA_fmincon_OptResDisplay\z_cop.xlsx',z_cop,'sheet1','A1:E2000');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第三部分 虚质量法向气动力产生的力矩——绕翅平面下的弦向轴 % I5y和I6y单位是 mg.mm=*10^(-9) kg.m  %单位是10^6uN
% F_yadd1=-(I5y*(domega_z+omega_x.*omega_y)-I6y*domega_x)*10^(-3); % 修改了原文推出的公式的正负号,且不含/4
F_yadd1=(-I5y*(domega_z+omega_x.*omega_y)+I6y*domega_x)*10^(-3);
% M_zadd=-(I7z*(domega_z+omega_x.*omega_y)-I_xzam*domega_x)*10^(-3); % 修改了原文推出的公式的正负号,且不含/4
% k_za=1; 
k_za=0.35; 
M_zadd=k_za*(-I7z*(domega_z+omega_x.*omega_y)+I_xzam*domega_x)*10^(-3); % 原文推出的公式——更为合理些哦   % 初始逆时针(-)
r_xcopnd_add=M_zadd./F_yadd1;
% r_xcopnd_addaver=trapz(t,r_xcopnd_add)/(3*T);    % r_xcopnd_addaver=0.7934;
r_xcopnd_addaver=mean(r_xcopnd_add);   % r_xcopnd_addaver=0.7320;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第四部分 转动阻尼力矩——绕翅平面下的弦向轴
% C_RD=5.0;     %转动阻尼气动力系数:C_RD=C_rd∈(3,6); 或者C_rd=C_dmax=3.4;
% uN.mm   % (rad/s)^2*mg.mm^2=mg.mm/s^2.mm=10^(-3) uN.mm
C_RD2=0.05*C_RD;
% C_RD2=1*C_RD;  % 该系数有问题
M_zrd=-C_RD2*omega_x.*abs(omega_x)*M_zrdcoeff*10^(-3);   % 阻尼力矩一开始是顺时针的 % 注意这个方向取决于omega_x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 第五部分——拍打轴转动铰链—弦向—铰链回复力矩
% T_transRat=3000*10^-3;          % 传动比    % 单位: rad/mm; 
T_transRat=2857*10^-3;              % 传动比    % 单位: rad/mm; 
k_act=300;                                    % 单位:  N/m=mN/mm  % 2011-ICIRS-System identification
% 参考: 2010-BB-Distributed power and control actuation
% k_zh=k_act/T_transRat^2;          % k_zh =33.3333=mN*mm^-1* rad^-2*mm^2=mN.mm* rad^-2 
k_eq=344.8;                                   % 单位:  N/m=mN/mm
% k_zh1=2*10^(-3);
k_zh1=0.15*10^(-3);
k_zh=k_zh1*(k_eq-k_act)/T_transRat^2;   % k_trans =5.4885; % mN.mm/rad;
% k_zh=5.4872;                              % k_trans=5.4872;  % uN.m/rad=10^-3*10^3 mN.mm/rad;
M_zhinge=k_zh*phi*10^(3);         % 单位是: mN.mm=*10^(3)uN.mm
% figure(32)
% plot(t/T,M_zhinge,'c-')  
% xlabel('\itNormalized time')
% ylabel('\itM_{z,hinge}   (uN.mm)')      
% legend('M_{z,hinge}(t)')
% title('铰链回复力矩(展向:x-axis)随时间的变化规律')
% grid on
% axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 第六部分——拍打轴输入的驱动力矩
% F_act=F_0*sin(2*pi*f*t );  % 参考: 2010-BB-Distributed power and control actuation
T_transRat=3000*10^-3;    % 传动比    % 单位: rad/mm;        % T_transRat=3000rad/um;  % 2012-BB-正式版-Conceptual design 
% F_act=55.9;                         %单位: mN % for phi_halfmax =57.5823°;                           % F_b = 0.0559N   0.0594N 
% T_transRat=3300*10^-3;     % 传动比    % 单位: rad/mm         % 2008-IEEE TR-RJ Wood
% F_act=136/2;                        % F_act=123/2; % 单位: mN
% F_act=112;      % 单位: mN   % 需要获得 PHI_pp=1.1487*180/pi=65.82°;
F_act=56;          % 单位: mN  % 匹配弦向轴最大力矩0.3mN.mm
M_ampl=F_act/T_transRat;
w =1185.6;
T=2*pi/w;    % f=1/T;   % f=188.7;
% k_zact=0.25*10^(2);
% k_zact=6.75*10^(3);
k_zact=5*10^(-3);
% k_zact=7.5*10^(2);
% delta_act=0; 
delta_act=-1.571;
% t_range=linspace(0.0052824335,0.0052824335+5*T,1000);
M_zact=k_zact*M_ampl*cos(w*t+delta_act)*10^(3);  % 单位是: mN.mm=*10^(3)uN.mm
% figure(33)
% plot(t/T,M_zact,'r-')
% xlabel('\itNormalized time');  ylabel('\itM_{z,act} (mN.mm)');
% legend('M_{z,act}(t)')
% title('拍打轴输入的驱动力矩')
% grid on
% axis([0.9,4.05,-inf,inf])
% set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第七部分 绕翅平面下的弦向轴力矩之和——含翅膀自身惯性力矩
% M_inert_z=-x_com*F_inert_y*10^3;                     % 弦向——翅膀自身惯性力矩;  初始逆时针(-)
M_inert_z=1*M_inert_z;
% M_ztotal=M_ztrans+M_zrot+M_zadd+M_zrd+M_inert_z;     % 翅平面: 弦向(z轴)
% M_ztotal=(M_ztrans+M_zrot+M_zadd+M_zrd);
M_ztotal=(M_ztrans+M_zrot+M_zadd+M_zrd).*cos(psi)-M_zact+M_zhinge;
figure(34)
hold on
plot(t/T,M_ztrans,'r-',t/T,M_zrot,'g-',t/T,M_zadd,'b-',t/T,M_zrd,'c-',...
       t/T,M_inert_z,'m-',t/T,M_zhinge,'r-.',t/T,M_zact,'k:',t/T,M_ztotal,'g:','LineWidth',2)  
xlabel('\itNormalized time')
ylabel('\itM_{z,trans} & M_{z,rot} & M_{z,add} & M_{z,rd} & M_{inert,z}(t) & M_{total,z}  (uN.mm)')
legend('M_{z,trans}(t)','M_{z,rot}(t)','M_{z,add}(t)','M_{z,rd}(t)','M_{inert,z}(t)','M_{hinge,z}(t)','M_{act,z}(t)','M_{total,z}(t)')
title('弦向(翅坐标系z轴)气动力矩随时间的变化规律')   % 弦向气动力矩随时间的变化规律
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 拍打轴的功率
% 平动环量力矩功率  % uW
P_ztrans=M_ztrans.*omega_z*10^-3;  % uN.mm*rad*s^-1=10^-9N*m*s^-1=10^-9W=10^-6mW=10^-3uW
%%%%%%%%%%%%%%%%%%%%%%%%%
% 转动环量力矩功率  % uW  
P_zrotcirc=M_zrot.*omega_z*10^-3; 
%%%%%%%%%%%%%%%%%%%%%%%%%
% 虚质量力矩功率和翅膀自身惯性力矩功率  % uW
P_zam=M_zadd.*omega_z*10^-3;
P_inert_z=M_inert_z.*omega_z*10^-3;
%%%%%%%%%%%%%%%%%%%%%%%%%
% 转动阻尼力矩功率  % uW
P_zrd=M_zrd.*omega_z*10^-3;  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M_ztotal=M_ztrans+M_zrot+M_zadd+M_zrd+M_inert_z;     % 翅平面: 弦向(z轴)
% M_ztotal=(M_ztrans+M_zrot+M_zadd+M_zrd).*cos(psi)-M_zact+M_zhinge;
% P_totalz=-M_ztotal.*abs(omega_z)*10^-3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P_aeroz=P_ztrans+P_zrd+P_zrotcirc+P_zam;
P_totalz=P_ztrans+P_zrd+P_zrotcirc+P_zam+P_inert_z;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(35)  % 平动环量气动力矩, 转动阻尼力矩、转动环量气动力矩和虚质量力矩-绕扭转轴的功率
plot(t/T,P_ztrans,'r-.',t/T,P_zrd,'g--',t/T,P_zrotcirc,'m:',t/T,P_zam,'b-','LineWidth',2)
hold on
plot(t/T,P_aeroz,'k-','LineWidth',3)
hold on
plot([0.9,4.05],[0,0],'k-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itP_{aero,z}  ( including P_{trans,z}  & P_{rd,z}  & P_{rotcirc,z} & P_{am,z})  (uW)')
legend('P_{trans,z}','P_{rd,z}','P_{rotcirc,z}','P_{am,z}','P_{aero,z}')
title('弦向(z-axis)-平动环量气动力矩,转动阻尼力矩,转动环量气动力矩,虚质量力矩及总气动力矩绕扭转轴的功率-随时间的变化规律')  % 弦向气动力矩随时间的变化规律
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
% hold on
% plot(t/T,phi*180/pi,'r:',t/T,psi*180/pi,'b:',t/T,alpha2*180/pi,'g:','LineWidth',1.5)  %转换为ms 和 度数degree   *10^3   *180/pi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(36)  % 气动力矩和虚质量力矩,翅膀自身惯性力力矩及总力矩绕扭转轴的功率
plot(t/T,P_aeroz,'b-',t/T,P_inert_z,'c:','LineWidth',2)
hold on
plot(t/T,P_totalz,'k-','LineWidth',3)
hold on
plot([0.9,4.05],[0,0],'k-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itP_{total,z}  ( including P_{aero,z} & P_{inert,z})  (uW)')
legend('P_{aero,z}','P_{inert,z}','P_{total,z}')
title('弦向(z-axis)-气动力力矩,翅膀自身惯性力力矩及总力矩绕扭转轴的功率-随时间的变化规律')   % 弦向气动力矩随时间的变化规律
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
% hold on
% plot(t/T,phi*180/pi,'r:',t/T,psi*180/pi,'b:',t/T,alpha2*180/pi,'g:','LineWidth',1.5)  %转换为ms 和 度数degree   *10^3   *180/pi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 翅膀两自由度运动的功率计算——平动功率和扭转功率——扭转轴功率和拍打轴功率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P_aerox=P_xtrans+P_xrd+P_xrotcirc+P_xam;
% P_totalx=P_xtrans+P_xrd+P_xrotcirc+P_xam+P_inert_x;
P_psix_total=P_aerox;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P_aeroz=P_ztrans+P_zrd+P_zrotcirc+P_zam;
% P_totalz=P_ztrans+P_zrd+P_zrotcirc+P_zam+P_inert_z;
P_phiz_total=P_aeroz;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I_moment=inertia_moment(R_wing,C_aver,xr0,C_maxyaxis);        %调用函数inertia_moment;
% uN.mm*rad*s^-1=10^-9N*m*s^-1=10^-9W=10^-6mW=10^-3uW
Ix_inertia=I_moment(1,1)*10^(-3);     % 由平移轴定理获得  % g.mm^2=10^(-9)kg.m^2——for 10^-3uW
Iz_inertia=I_moment(1,2)*10^(-3);     % 由平移轴定理获得  % g.mm^2=10^(-9)kg.m^2——for 10^-3uW
% 下面——rad*s^-1*10^(-9)kg.m^2*rad*s^-2=10^(-9)(N=kg*m.s^-2)*(m.s^-1)=10^-9W=10^-6mW=10^-3uW
P_Ix_inertia=omega_x*Ix_inertia.*domega_x;      % uW
P_Iz_inertia=omega_z*Iz_inertia.*domega_z;      % uW
P_totalx=P_psix_total+P_Ix_inertia;
P_totalz=P_phiz_total+P_Iz_inertia;
P_total=[2*P_totalx,2*P_totalz];                           % 两个翅膀——分别两个自由度运动产生的功率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第三模块——法向转动轴——气动力矩分量%%%%%
%%%%含三部分, 分别是：%%%%%%%%%%%%%%单位: (mN.mm)或(uN.m)
%%%%第一部分——平动环量产生的气动力矩%%%%%%
%%%%第二部分——转动环量产生的气动力矩%%%%%%
%%%%第三部分——翅膀自身惯性力矩%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第一部分——平动环量产生的气动力矩——法向轴
% % 气动力矩输入参数为：10个 %% 单位: (mN.mm)或(uN.m)
% % Omega1; Omega2; Omega3; Omega4;         ——————这组数据来自翅形貌参数化
% %%%%%%%%%%%%%%%%%%%%%%%%%
% % M_t=(-Omega1*sign(dphi).*dphi.^2.*C_T)*(10^-12*10^6);    % 方向沿着翅平面法向轴(z轴)——产生Plunging Motion
% % mg.mm^2*rad*s^-2=(10^-12)kg*m*s^-2*m=10^-12N*m=10^-3 uN*mm
% % M_tang=-sign(dphi)*Omega1.*dphi.^2.*C_T*(10^-3);    % uN*mm %  方向沿着翅平面法向轴(z轴)——由文献给出
% % M_ytrans1=M_tang;            % 翅平面: 法向(y轴)
% M_ytrans=-sign(alpha2).*(I1z.*C_T.*omega_h.^2)*10^(-3);   % I1z=0.0162; % 单位是 mg.mm^2
% figure(37)
% plot(t/T,M_ytrans1,'r-',t/T,M_ytrans,'g-','LineWidth',2)  
% grid on
% axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第二部分——转动环量产生的气动力矩——法向轴
% % C_R=1.55;    % 该系数有问题————————XXXXXXXXXXXXXX
% % M_zrot=I2z*C_R*omega_x.*V_nonr*10^(-3);   % V_nonr=omega_h=dphi
% % I2z=0.0069; 单位是: mg.mm^2  * (rad*s^-1)^2=mN.mm=10^(-3)uN.mm
% M_yrot=I2z*C_T.*omega_x.*omega_h*10^(-3);    % C_T全正
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第三部分——翅膀自身惯性力矩——法向轴
% %  M_inert_y=x_com*F_inert_z*10^3;  % 弦向——翅膀自身惯性力矩;  初始顺时针(-)
% M_ytotal=M_ytrans+M_yrot+M_inert_y;
% figure(38)
% plot(t/T,M_ytrans,'r-',t/T,M_yrot,'b-',t/T,M_inert_y,'g-',t/T,M_ytotal,'k-','LineWidth',2)  
% xlabel('\itNormalized time')
% ylabel('\itM_{trans,y} & M_{rot,y} & M_{inert,y} & M_{total,y} (uN.mm)')
% legend('M_{trans,y}(t)','M_{rot,y}(t)','M_{inert,y}(t)','M_{total,y}(t)')
% title('法向(翅坐标系y轴)气动力矩随时间的变化规律')   % 法向气动力矩随时间的变化规律
% grid on
% axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close all;
% toc
