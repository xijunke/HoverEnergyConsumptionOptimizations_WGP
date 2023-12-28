function F_verticalaver=Aero_F3_fruitfly_exp(x) % x是变量——% variable=[R_wingeff,C_avereff,xr,C_maxy];
%% 气动力: Solution of the aerodynamic force
% 修改时间——2014年12月20日,11:54——转动轴偏离弦向中点的偏移量坐标,在扭转轴向上偏移C_maxy之后
% clear all;clc;
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
% F_ndTrans=wing_para(1,1);             % F_ndTrans=0.46392;  无量纲, 量纲化单位为mm^4
Coeff_liftdragF_N=wing_para(1,2);      % Coeff_liftdragF_N=0.00682;  %单位是mg*mm
% M_xaercoeff=wing_para(1,3);          % M_xaercoeff=0.006038;   %单位是: mg.mm^2
% I1z=wing_para(1,4);                         % I1y=0.016158   % 单位是 mg.mm^2
% Z_rnd=wing_para(1,5);                     % Z_rnd=0.16265;  无量纲, 量纲化单位为mm
% M_xrdcoeff=wing_para(1,6);           % M_xrdcoeff=0.0001839; % 单位是mg.mm^2
% F_ndRot=wing_para(1,7);                % F_ndRot=0.74851;  无量纲, 量纲化单位为mm^4
F_yrotcoeff=wing_para(1,8);               % F_yrotcoeff =0.0032433;  % 单位是 mg.mm
% M_xRotcoeff=wing_para(1,9);         % M_xRotcoeff=0.002871;   % 单位是 mg.mm^2
% I2z=wing_para(1,10);                      % I2y=0.006943;        % 单位是 mg.mm^2
% I_xzam=wing_para(1,11);                % I_xzam=0.001424  % 单位是 mg.mm^2
% I_xxam=wing_para(1,12);                % I_xxam=0.000338  % 单位是 mg.mm^2
I5y=wing_para(1,13);                          % I5z=0.0050926   % 单位是 mg.mm
I6y=wing_para(1,14);                          % I6z=0.00077164  % 单位是 mg.mm
% I7z=wing_para(1,15);                      % I7y=0.0109056;        % 单位是 mg.mm^2
% M_zrdcoeff=wing_para(1,16);         % M_zrdcoeff=0.0011169; % 单位是 mg.mm % 转动气动阻尼力矩参数—绕翅平面下的弦向轴
% C_max_LtoT=wing_para(1,17);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I5y=wing_para(1,13);                       % I5z=0.0050945   % 单位是 mg.mm        % 下文中I3y应该改为I5y
% I6y=wing_para(1,14);                       % I6z=0.0011         % 单位是 mg.mm         % 下文中I4y应该改为I6y
% I7z=wing_para(1,15);                       % I7y=0.0109;        % 单位是 mg.mm^2    % 下文中I5z应该改为I7z
% I1z=wing_para(1,4);                         % I1y=0.0162;        % 单位是 mg.mm^2    % 下文中I7z应该改为I1z
% I2z=wing_para(1,10);                       % I2y=0.0069;        % 单位是 mg.mm^2    % 下文中I6z应该改为I2z 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 调用翅膀运动学-翅运动规律和几何攻角(AOA)等数据
% wing_m_output=[t',phi',psi',alpha',dphi',dpsi',ddphi',ddpsi',C_L',C_D',C_N1',C_T'];
% wing_kenimatics=kenimatics_wing_and_AoA_fruitfly_sim();  %调用函数kenimatics_wing_and_AoA;  % size(wing_kenimatics)  % (1000,11)
wing_kenimatics=kenimatics_wing_and_AoA_fruitfly_exp();
t=wing_kenimatics(:,1);                % 单位是ms
% phi=wing_kenimatics(:,2);        % 拍打角——单位是rad
psi=wing_kenimatics(:,3);            % 拍打角——单位是rad
alpha=wing_kenimatics(:,4);      % alpha=atan2(omega_z,-omega_y);  % 几何攻角——弧度制   %输出——有正有负
dphi=wing_kenimatics(:,5);          % 单位是rad/s
dpsi=wing_kenimatics(:,6);          % 单位是rad/s
ddphi=wing_kenimatics(:,7);       % 单位是rad/s^2
ddpsi=wing_kenimatics(:,8);     % 单位是rad/s^2
C_L=wing_kenimatics(:,9);          
C_D=wing_kenimatics(:,10);     
C_N1=wing_kenimatics(:,11);   
C_T=wing_kenimatics(:,12);   
C_N=C_N1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 翅膀坐标系下的角速率和角加速率——————这组数据来自翅2DOF运动
% 翅膀坐标系下的角速度
omega_x=dpsi;                     % 展向
omega_y=dphi.*sin(psi);       % 法向(初始向左)
omega_z=dphi.*cos(psi);      % 弦向朝上
omega_h=dphi;       % 铰链的角速度% omega_h=-sqrt(omega_y^2+omega_z^2);  % 右手法则顺时针
% 翅膀坐标系下的角加速度——用于虚质量力的计算
domega_x=ddpsi;
domega_y=ddphi.*sin(psi)+dphi.*dpsi.*cos(psi);
domega_z=ddphi.*cos(psi)-dphi.*dpsi.*sin(psi); 
%% 气动攻角和当地流场速度的计算
v_y_nonr=omega_z;   % v_y=r*dphi*cos(psi)
v_z_nonr=-omega_y;    % v_z=-r*dphi*sin(psi)
% alpha2=atan2(v_y_nonr,v_z_nonr);   % 正确——注意与下文的alpha=atan2(omega_z,-omega_y)*180/pi; 不同
% % 由于alpha=atan2(cot(psi))=atan2(cot(pi/2-alpha))=atan2(tan(alpha)); %这里atan2给出象限正负值，尤其是alpha>pi/2时
V_nonr=sqrt(v_y_nonr.^2+v_z_nonr.^2); % 当地来流速度V_nonr=omega_h=dphi;   % 单位是 rad/s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% xr=0.3289;  % x-root offset  \mm      % R_wingeff=wing_para(1,1);  % R_wingeff =3.0040;   % 单位是 mm
% R_ref=(xr+R_wingeff)*10^(-3);  
% R_ref_non=3.3293*10^(-3);
R_ref_non=1;   % r2_nd=0.5801;   
v_y=R_ref_non*omega_z;
v_z=-R_ref_non*omega_y;
V_ref=sqrt(v_y.^2+v_z.^2);
f=188.7;  T=1/f;          % Hz
V_ref_aver=trapz(t,V_ref)/(3*T);    % 翼尖参考速度: V_ref_aver=867.0901rad/s;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第一种气动力——翅坐标系下：平动气动环量力——升阻力分量；作用点：片元弦长中点
%% 输入参数为：4个
% C_avereff;  R_wingeff;    F_nd;                ——————这组数据来自翅形貌参数化;% F_nd=0.50236;
% omega_h;  C_L(alpha);  C_D(alpha);       ——————这组数据来自翅2DOF运动铰链角速率, 攻角
%%  Coeff_liftdragF_N   %单位  mg.mm=*10^(-9)kg.m
% g=9.821*10^(-6);   % 这里重力加速度:g=9.821N/kg=9.821*10^(-6)=9.821e-006   N/mg  ——g的国际单位是m*s^-2或N*kg^-1
g=9.821;   % 这里重力加速度:g=9.821N/kg=9.821*10^(-6)=9.821e-006   N/mg  ——g的国际单位是m*s^-2或N*kg^-1
lift_inst=V_nonr.^2.*C_L*Coeff_liftdragF_N*10^(-3)/g;      % 单位是rad^2*s^-2*kg*m / (m*s^-2)=mg
drag_inst=V_nonr.^2.*C_D*Coeff_liftdragF_N*10^(-3)/g;  % 单位是rad^2*s^-2*kg*m / (m*s^-2)=mg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%对瞬时气动升阻力使用梯形积分函数trapz进行数值积分，除以周期, 求解平均升阻力
lift_aver=trapz(t,lift_inst)/(3*T)                            % lift_aver =1.0913 
drag_aver=trapz(t,drag_inst)/(3*T)                      % drag_aver =0.9887
drag_instabs_aver=trapz(t,abs(drag_inst))/(3*T);        
lift2drag_aver=lift_aver/drag_instabs_aver         % 升力和阻力比值: lift2drag_aver =1.1037——不是升阻系数的比值，没有实际意义？
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(10)
F_LD=plot(t/T,lift_inst,'r-',t/T,drag_inst,'b:','LineWidth',2);   
xlabel('\itNormalized time')
ylabel('\itAerodynamic force (mg)')                    %单位换算到mg了哦
title('Aerodynamic lift and drag force \itvs. \itt \rm for flapping wing')
% legend('\itinstantaneous lift (\itF_L)','\itinstantaneous drag (\it|F_D|)')
legend('\itinstantaneous lift (\itF_L)','\itinstantaneous drag (\itF_D)')
set(F_LD,'LineWidth',2)
grid on
axis([0.9,3.0,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 翅坐标系下：平动气动环量力(1)——法向力；作用点：片元弦长中点
% C_N=C_N1=cos(abs(alpha)).*C_L+sin(abs(alpha)).*C_D; %由升阻力系数合成——2010-JFM-RJ Wood
% Coeff_liftdragF_N=6.8201e-012——单位是:kg/m^3*mm*mm^3= 10^(-12) kg.m
% F_ytran=-sign(alpha).*V_nonr.^2.*C_N*Coeff_liftdragF_N/g;  %单位是rad^2*s^-2*kg*m / (m*s^-2)=mg——仅用于显示
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(11)
% plot(t/T,F_ytran,'k-','LineWidth',2)
% xlabel('\itNormalized time')
% ylabel('\itF_{y,tran} (mg)')
% legend('F_{y,tran}')
% title('平动气动环量力(法向)随时间的变化规律') 
% grid on
% axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 单位是rad^2*s^-2*kg*m / (m*s^-2)=mg
F_ytran=-sign(alpha).*V_nonr.^2.*C_N*Coeff_liftdragF_N*10^(-3);   % 单位是rad^2*s^-2*mg*mm=10^(-9)N=10^(-9)*10^6uN
F_ytran_aver=trapz(t,abs(F_ytran))/(3*T)   % F_ytran_aver =14.5887uN;
F_ztran=-sign(alpha).*V_nonr.^2.*C_T*Coeff_liftdragF_N*10^(-3);  
% F_ytran=V_nonr.^2.*C_N*Coeff_liftdragF_N*10^(-3); 
% F_ztran=V_nonr.^2.*C_T*Coeff_liftdragF_N*10^(-3);  
figure(12)
plot(t/T,F_ytran,'k-',t/T,F_ztran,'r-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itF_{y,tran} & F_{z,tran} (uN)')
legend('F_{y,tran}','F_{z,tran}')
title('平动气动环量力(法向和切向)随时间的变化规律') 
grid on
axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第二种气动力—— 翅坐标系下： 旋转气动环量力：法向力；作用点：片元弦长中点
%% 输入参数为：3个
% C_avereff;   R_wingeff;   F_ndRot;  ——————这组数据来自翅形貌参数化
% omega_h;  omega_x;                    ——————这组数据来自翅2DOF运动铰链角速率, 翅角速率
% F_zrot=(1/2)*Rou*R_wingeff^2*C_avereff^2*C_R*omega_x.*omega_h*F_ndRot*(10^(-12)*10^3);%单位是mN——未考虑方向
% F_y_rot=C_R*sign(alpha2).*abs(omega_x).*abs(omega_h)*F_y_rotcoeff*10^6;    % 单位是uN
C_R=1.55;
% F_yrot=-C_R*sign(alpha).*omega_x.*V_nonr*F_yrotcoeff*10^(-3); % 
F_yrot=C_R*omega_x.*V_nonr*F_yrotcoeff*10^(-3);      % 单位是rad^2*s^-2*kg*m=10^(-9)N=10^(-9)*10^6uN
F_yrot_aver=trapz(t,abs(F_yrot))/(3*T)                             % F_yrot_aver =2.8944uN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(13)                  % 该气动力有些小  
hold on
plot(t/T,F_ytran,'k-',t/T,F_yrot,'r-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itF_{y,tran} &  F_{y,rot} (uN)')
legend('\itF_{y,tran}','\itF_{y,rot}')
title('平动气动环量力(法向)和旋转气动环量力(法向)随时间的变化规律')   
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第三种气动力——翅坐标系下：虚质量气动力：法向力；作用点：片元弦长中点
%%% 拍打和被动扭转的协同作用？——虚质量力——参考SK Agrawal的文献推导过程，以便理解其物理意义
%% 输入参数为：10个
% I5y;   I6y;     % 单位是 mg.mm=10^(-9) kg.m ——————这组数据来自翅形貌参数化
% domega_z; omega_x; omega_y;                      ——————这组数据来自翅2DOF运动翅角加速率, 角速率
% dphi; dalpha; ddphi; ddalpha; alpha;               ——————这组数据来自翅2DOF运动角速率, 角加速率, 攻角
%%  (1) 2010_JFM_Aeromechanics-虚质量气动力公式——% I5y和I6y单位是 mg.mm=*10^(-9) kg.m
% F_yadd=sign(phi).*(I5y*(domega_z-omega_x.*omega_y)+I6y*domega_x)*(10^(-9)*10^6);   %单位是uN
% F_yadd1=(I5y*(domega_z-omega_x.*omega_y)+I6y*domega_x)*10^(-3); % 原文推出的公式——更为合理些哦
% 注意公式前(-)符——根据果蝇翅膀坐标系修改了角速度和角加速度
% F_yadd1=-(I5y*(domega_z+omega_x.*omega_y)-I6y*domega_x/4)*10^(-3); %单位是rad^2*s^-2*kg*m=N=10^6uN % 与2001-JEB匹配
% F_yadd1=-(I5y*(domega_z+omega_x.*omega_y)+I6y*domega_x)*10^(-3); % 修改了原文推出的公式的正负号,且不含/4  % ——第一方案
F_yadd1=(-I5y*(domega_z+omega_x.*omega_y)+I6y*domega_x)*10^(-3);    % 修改了原文推出的公式的正负号,且不含/4  % ——第二方案
F_yadd1_aver=trapz(t,abs(F_yadd1))/(3*T)    % F_yadd1_aver=6.0929uN(old);  F_yadd1_aver=4.5472;——平均值
% (2)下面是2001-JEB-Sanjay SP-虚质量气动力公式
% F_yadd2=(I5y*(ddphi.*sin(alpha)+dphi.*dalpha.*cos(alpha))-(I6y/4)*ddalpha/4)*10^(-3);% 原文推出的公式——不动
% 下面的alpha1为全正几何攻角，有正有负的dalpha1和ddalpha1
% F_yadd2=-(I5y*(ddphi.*sin(alpha1)+dphi.*dalpha1.*cos(alpha1))-(I6y/4)*ddalpha1/4)*10^(-3); 
% F_yadd2=-(I5y*(ddphi.*sin(alpha1)+dphi.*dalpha1.*cos(alpha1))+(I6y/4)*ddalpha1/4)*10^(-3); 
% F_yadd2=-(I5y*(ddphi.*sin(alpha1)+dphi.*dpsi.*cos(alpha1))-(I6y/4)*ddpsi/4)*10^(-3); %这里的dpsi和ddpsi方向变化需要确定
% F_yadd2=-(I5y*(ddphi.*sin(alpha1)+dphi.*dpsi.*cos(alpha1))+(I6y/4)*ddpsi/4)*10^(-3); %这里的dpsi和ddpsi方向变化需要确定
% 下面的alpha2有正有负, dalpha和ddalpha需要求导
% F_yadd2=-(I5y*(ddphi.*sin(alpha)+dphi.*dalpha.*cos(alpha))-(I6y/4)*ddalpha/4)*10^(-3); 
i=length(alpha);   % size(alpha)=(2000*1)
dalpha=[diff(alpha);alpha(i,1)];    
j=length(dalpha);
ddalpha=[diff(dalpha);dalpha(j,1)];  % size(ddalpha)
F_yadd2=-(I5y*(ddphi.*sin(abs(alpha))+dphi.*dalpha.*cos(abs(alpha)))-(I6y/4)*ddalpha/4)*10^(-3);% ——第一方案
%%%%%%%%%%%%%%%%%%%%%%%%%
figure(14)  % 单位是 mg.mm*rad^2.*s^-2=10^(-9) kg.m*s^-2=10^(-9)N=10^(6)uN;   %单位是uN
F_yadd1_tran=-(I5y*(domega_z+omega_x.*omega_y))*10^(-3);  % 法向虚质量气动力平动分量——翅膀
F_yadd1_rot=(I6y*domega_x)*10^(-3);                                         % 法向虚质量气动力转动分量——翅膀
plot(t/T,F_yadd1_tran,'r-.',t/T,F_yadd1_rot,'g:',t/T,F_yadd1,'k-','LineWidth',2) 
ylabel('法向气动力分量F_{norm}(t) (uN)'); 
legend('F_{y,add1,tran}(t)','F_{y,add1,rot}(t)','F_{y,add1}(t)');  
title('法向虚质量气动力分量F_{y,add1}(t))随时间的变化')  
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%
figure(15)
hold on
plot(t/T,F_yadd1,'r-',t/T,F_yadd2,'b-','LineWidth',2)    % 注意这里的domega_x=ddpsi与ddalpha的符号存在不同哦
xlabel('\itNormalized time')
ylabel('\itF_{y,add} (uN)')
legend('F_{y,add1}','F_{y,add2}')
title('虚质量气动力(法向)随时间的变化规律')  
grid on
axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 翅膀自身惯性力分量
% % 翅膀坐标系下的角速度
% omega_x=dpsi;                     % 展向
% omega_y=dphi.*sin(psi);       % 法向(初始向左)
% omega_z=dphi.*cos(psi);      % 弦向朝上
% omega_h=dphi;       % 铰链的角速度% omega_h=-sqrt(omega_y^2+omega_z^2);  % 右手法则顺时针
% % 翅膀坐标系下的角加速度——用于虚质量力的计算
% domega_x=ddpsi;
% % domega_y=ddphi.*sin(psi)+dphi.*dpsi.*cos(psi);
% domega_z=ddphi.*cos(psi)-dphi.*dpsi.*sin(psi); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m_wing=2.4*10^-9;                    % kg
x_com=1.920243385*10^-3;      %  m                           % 质心的展向坐标
% z_com=-0.149785466+0.636=0.486215*10^-3;      % 到扭转轴的弦向距离
z_com=0.149785466*10^-3;       %  m                          % 到扭转轴的弦向距离
F_inert_y=-m_wing*(domega_z*x_com-domega_x*z_com+omega_y.*(omega_x*x_com+omega_z*z_com))*10^6;  % 翅膀自身惯性力—法向
F_inert_z=-m_wing*(-domega_y*x_com-omega_y.^2*z_com+omega_x.*(omega_z*x_com-omega_x*z_com))*10^6; % 翅膀自身惯性力—弦向
% F_inert_y=-m_wing*(ddphi.*cos(psi)*x_com-(ddpsi-dphi.^2.*sin(2*psi)/2)*z_com)*10^6;       % 翅膀自身惯性力—法向
% F_inert_z=-m_wing*(-ddphi.*sin(psi)*x_com-(dpsi.^2+dphi.^2.*(sin(psi)).^2)*z_com)*10^6;  % 翅膀自身惯性力—弦向
figure(16) 
plot(t/T,F_inert_y,'r-',t/T,F_inert_z,'g-','LineWidth',2) 
ylabel('翅膀自身惯性气动力分量F_{inert,y}(t) & F_{inert,z}(t) (uN)'); 
legend('F_{inert,y}(t)','F_{inert,z}(t)');  
title('翅膀自身惯性气动力分量F_{inert,y}(t) & F_{inert,z}(t)随时间的变化')  
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 总气动力—— 翅坐标系下：总(合成)法向气动力：平动气动环量力+旋转气动环量力+虚质量气动力；作用点：片元弦长中点
F_N=F_ytran+F_yadd1+F_yrot+F_inert_y;    % 单位是rad^2*s^-2*kg*m=N=10^6uN
figure(17)
plot(t/T,F_N,'k-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itF_N (uN)')
legend('F_N')
title('平动气动环量力+旋转气动环量力+虚质量气动力(法向)随时间的变化规律')
grid on
axis([0.9,4.05,-inf,inf])
hold on
L=length(t);
plot([0,t(L)/T],[0,0],'k-','LineWidth',2);     %画x-axis
%% 翅坐标系下：片元法向合力分解到片元垂直方向和水平方向；作用点：片元弦长中点
F_vertical=-sign(alpha).*F_N.*cos(alpha);                % 垂直方向vertical, %单位是uN  %  
F_horizontal=F_N.*sin(abs(alpha));                          % 水平方向horizontal,%单位是uN
% % F_horizontal=-sign(alpha).*F_N.*sin(alpha);     % 水平方向horizontal,%单位是uN
% F_vertical=abs(F_N.*cos(alpha));                          % 垂直方向vertical, %单位是uN
% F_horizontal=abs(sign(alpha).*F_N.*sin(alpha));  % 水平方向horizontal,%单位是uN
F_verticalaver=trapz(t,F_vertical)/(3*T)               % F_verticalaver=12.3074uN;   
g_uN=9.821;   % 这里重力加速度:g=9.821N/kg=9.821*10^6/10^6=9.821 uN/mg  ——g的国际单位是m*s^-2或N*kg^-1
F_vaver=trapz(t,F_vertical)/(3*T)/g_uN               % F_vaver =1.2532; %单位是mg      1.2532(含惯性力)
F_haver=trapz(t,F_horizontal)/(3*T)/g_uN          % F_haver =-0.1109; %单位是mg     -0.1109(含惯性力)
F_haverabs=trapz(t,abs(F_horizontal))/(3*T);    
F_v2haver=F_vaver/F_haverabs                % 升力和阻力比值: F_v2haver =0.1150;  0.1045(含惯性力)——不是升阻系数的比值，没有实际意义？
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(18)
hold on
plot(t/T,F_vertical,'r-',t/T,F_horizontal,'b:','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itF_{vertical} & F_{horizontal} (uN)')
legend('F_{vertical}','F_{horizontal}')
title('法向合力分解到垂直方向和水平方向的分量力随时间的变化规律')   
grid on
axis([0.9,4.05,-inf,inf])
set(gca,'XTick',(0.9:0.1:4.05))
hold on
L=length(t);
plot([0,t(L)/T],[0,0],'k-','LineWidth',2);     %画x-axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 翅坐标系下： 由法向气动力系数求解: 垂直方向和水平方向气动力系数
% Coeff_liftdragF_N=0.0068201——单位是:mg*mm^-3*mm*mm^3= 10^(-9) kg*m
% Rou=1.225*10^(-3);           %单位是Kg/m^3=10^6/(10^3)^3=10^(-3)mg/mm^3
% Coeff_liftdragF_N=(1/2)*Rou*C_avereff*R_wingeff^3*F_nd*10^(-12);  % kg*m
C_N_total=F_N*10^(-6)./(V_ref_aver.^2*Coeff_liftdragF_N*10^(-9));          % 单位: N/(rad^2*s^-2*kg*m)=一无量纲
% C_v=F_vertical*10^(-6)./(V_ref_aver.^2*Coeff_liftdragF_N*10^(-9)); 
% C_h=F_horizontal*10^(-6)./(V_ref_aver.^2*Coeff_liftdragF_N*10^(-9));    % *10^3); 
C_v=-sign(alpha).*C_N_total.*cos(alpha); 
C_h=C_N_total.*sin(abs(alpha)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%对瞬时气动力系数使用梯形积分函数trapz进行数值积分，除以周期, 求解平均垂直方向和水平方向气动力系数
C_vaver=trapz(t,C_v)/(3*T);                 % C_vaver =2.3852;       2.4003(含惯性力)   
C_haver=trapz(t,C_h)/(3*T);                 % C_haver =-0.2655;   -0.2125(含惯性力)  
C_habsaver=trapz(t,abs(C_h))/(3*T);     
C_v2haver=C_vaver/C_habsaver;           % 垂直升力系数与水平阻力系数的比值: C_v2haver = 1.1298;  1.026(含惯性力)
figure(19)
plot(t/T,C_N_total,'g-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itC_{N,total}')
legend('C_{N,total}')
title('法向合气动力系数随时间的变化规律')
grid on
axis([0.9,4.05,-inf,inf])

figure(20)
plot(t/T,C_v,'r-',t/T,C_h,'b-','LineWidth',2)
xlabel('\itNormalized time')
ylabel('\itC_v & C_h')
legend('C_v','C_h')
title('垂直方向和水平方向气动力系数随时间的变化规律')
grid on
axis([0.9,4.05,-inf,inf])
% close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

