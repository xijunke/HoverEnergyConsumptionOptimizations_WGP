function wing_m_output=kenimatics_wing_and_AoA_fruitfly_exp_Cfcoeff(R_wing,C_aver,xr0,C_maxyaxis)
%% kenimatics_wing_and_AoA
% 翅运动规律和几何攻角(AOA)
% (注意：最终计算出来的扭转角,需要时间轴区间和实验时间轴配准)———需要求解和核对
% clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 创建符号函数，求导——获得角速率—————用于计算气动力和力矩时，需要更新计算而得的扭转角
% (1) 2014-Science-实测翅拍打角—— 按照4阶傅里叶级数拟合 
syms t         % t  自己设置时间轴
w =1185.6;     % 角频率   %  f=188.7; T=1/f;  %翅拍频率 (Hz)和周期  
phi1=sym('(3.9008+65.0445*cos(w*t)+4.2642*sin(w*t)+3.5806*cos(2*w*t)-2.9492*sin(2*w*t)+0.1319*cos(3*w*t)+0.3639*sin(3*w*t)+0.7844*cos(4*w*t)+0.2098*sin(4*w*t))*pi/180');  %符号函数: 原始数据的度数——转化为弧度制
dphi1=diff(phi1,t,1);
ddphi1=diff(phi1,t,2); 
dphi=inline(vectorize(dphi1),'w','t');                    % 数值函数
ddphi=inline(vectorize(ddphi1),'w','t');   
% (2) 2014-Science-实测翅扭转角——按照8阶傅里叶级数拟合    
psi1=sym('-(4.2936+1.8536*cos(t*w)+59.6529*sin(t*w)+5.1852*cos(2*t*w)+1.6095*sin(2*t*w)-8.4569*cos(3*t*w)+9.8057*sin(3*t*w)+3.9562*cos(4*t*w)+5.8064*sin(4*t*w)-3.0337*cos(5*t*w)-2.8749*sin(5*t*w)-2.8771*cos(6*t*w)+0.6686*sin(6*t*w)+0.8649*cos(7*t*w)-0.6137*sin(7*t*w)+0.0771*cos(8*t*w)-1.0007*sin(8*t*w))*pi/180');  %符号函数:原始数据的度数——转化为弧度制
dpsi1=diff(psi1,t,1);   
ddpsi1=diff(psi1,t,2);    
dpsi=inline(vectorize(dpsi1),'w','t');  %数值函数
ddpsi=inline(vectorize(ddpsi1),'w','t');  %数值函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 给各个函数赋值
f=188.7; T=1/f;  %翅拍频率 (Hz)和周期  % w =1185.6; 
t=linspace(0.0052824335,0.0052824335+3*T,1000);  % t_steady1   
dphi=dphi(w,t);         %(1*100)的行向量——拍打角速率                                                           % 输出
ddphi=ddphi(w,t);    %(1*100)的行向量——拍打角加速率                                                         % 输出
dpsi=dpsi(w,t);         %(1*100)的行向量——扭转角速率                                                             % 输出
ddpsi=ddpsi(w,t);     %(1*100)的行向量——扭转角加速率                                                         % 输出
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 拍打角和扭转角
% 拍打角—— (1*100)的行向量——拍打角——弧度制            %输出                                     
phi=(3.9008+65.0445*cos(w*t)+4.2642*sin(w*t)+3.5806*cos(2*w*t)-2.9492*sin(2*w*t)+...
        0.1319*cos(3*w*t)+0.3639*sin(3*w*t)+0.7844*cos(4*w*t)+0.2098*sin(4*w*t))*pi/180; % 原始数据的度数——转化为弧度制
% 扭转角——(1*100)的行向量——扭转角——弧度制            %输出
psi=-(4.2936+1.8536*cos(t*w)+59.6529*sin(t*w)+5.1852*cos(2*t*w)+1.6095*sin(2*t*w)-8.4569*cos(3*t*w)+9.8057*sin(3*t*w)+... 
        3.9562*cos(4*t*w)+5.8064*sin(4*t*w)-3.0337*cos(5*t*w)-2.8749*sin(5*t*w)-2.8771*cos(6*t*w)+...
        0.6686*sin(6*t*w)+0.8649*cos(7*t*w)-0.6137*sin(7*t*w)+0.0771*cos(8*t*w)-1.0007*sin(8*t*w))*pi/180;  % 原始数据的度数——转化为弧度制
% [phi_min,k]=min(phi);  % 输出:  phi_min =-1.0157;  k =10756;      
% t_0=t(k);                       % 输出: t0 =0.0028; 
%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(1)       % 图1——拍打角和扭转角
% % subplot(311)
% plot(t/T,phi*180/pi,'r-',t/T,psi*180/pi,'b-','LineWidth',2)  %转换为ms 和 度数degree   *10^3   *180/pi
% xlabel('\itNormalized time')
% ylabel('\itAngle (°)')
% legend('\it\phi(t)','\it\psi(t)')
% title('拍打角和扭转角随时间的变化规律')   % 拍打角和扭转角随时间的变化规律
% grid on
% axis([0.9,4.05,-105,105])
% set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot-拍打角速率和扭转角速率
% subplot(312)                                                       
% plot(t/T,dphi,'r-',t/T,dpsi,'b-','LineWidth',2)
% xlabel('\itNormalized time')
% ylabel('角速率 (rad/s)')
% legend('\itd\phi(t)','\itd\psi(t)')
% title('拍打角速率和扭转角速率随时间的变化规律') 
% grid on
% axis([0.9,4.05,-inf,inf])
% set(gca,'XTick',(0.9:0.1:4.05))
% % Plot-拍打角加速率和扭转角角加速率
% subplot(313)
% plot(t/T,ddphi,'r-',t/T,ddpsi,'b-','LineWidth',2)
% xlabel('\itNormalized time')
% ylabel('角加速率 (rad/s^-2)')
% legend('\itdd\phi(t)','\itdd\psi(t)')
% title('拍打角加速率和扭转角加速率随时间的变化规律') 
% grid on
% axis([0.9,4.05,-inf,inf])
% set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot-扭转角和几何攻角AOA
% % alpha1=pi/2+psi.*sign(dphi);        %(1*200)的行向量——几何攻角——弧度制        %输出——全正几何攻角 
% alpha1=pi/2-psi.*sign(dphi);        %(1*200)的行向量——几何攻角——弧度制        %输出——全正几何攻角  % 实测扭转角前负号
% % Y = sign(X) returns an array Y the same size as X, where each element of Y is:
% % *1 if the corresponding element of X is greater than zero
% % * 0 if the corresponding element of X equals zero
% % *-1 if the corresponding element of X is less than zero
% figure(2)                                                              % 图2—— 注意这里几何攻角始终取正值
% % % x_interval=[0,1/2,1/2,0];
% % % y_interval=[-100,-100,100,100];
% % % fill(x_interval,y_interval,'y');
% % % hold on
% % % legend('','\it\psi(t)','\it\alpha_1(t)')
% plot(t/T,psi*180/pi,'b-',t/T,alpha1*180/pi,'g-','LineWidth',2)      %扭转角和几何攻角AOA随时间的变化规律
% xlabel('\itNormalized time')
% ylabel('\itAngle (°)')
% legend('\it\psi(t)','\it\alpha_1(t)')
% hold on
% L=length(t);
% plot([0,t(L)/T],[0,0],'k-');     %画x-axis
% title('扭转角和几何攻角alpha_1随时间的变化规律') 
% grid on
% axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 翅膀坐标系下的角速度
% omega_x=dpsi;   % 扭转角:   x(1)=psi;  x(2)=dpsi;   
omega_y=dphi.*sin(psi);
omega_z=dphi.*cos(psi);
% omega_h=dphi;    % 翅膀坐标系下铰链角速率    % omega_h=sqrt(omega_y^2+omega_z^2);  % 右手法则顺时针
%% 翅膀坐标系下的角加速度——用于虚质量力的计算
% domega_x=ddpsi;
% domega_y=ddphi.*sin(psi)+dphi.*dpsi.*cos(psi); 
% domega_z=ddphi.*cos(psi)-dphi.*dpsi.*sin(psi); 
%% 气动攻角计算——取流产速度相对于刚体好了速度，所以整体加负号；
v_y_nonr=-omega_z;   % v_y=r*dphi*cos(psi)
v_z_nonr=omega_y;    % v_z=-r*dphi*sin(psi)
alpha2=atan2(-v_y_nonr,v_z_nonr);   % 正确——注意与下文的alpha=atan2(omega_z,-omega_y)*180/pi; 不同  % 实测扭转角前负号
% 由于alpha=atan2(cot(psi))=atan2(cot(pi/2-alpha))=atan2(tan(alpha)); %这里atan2给出象限正负值，尤其是alpha>pi/2时
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(3)                                               % 图3——使用翅膀坐标系下的角速度求解几何攻角
% plot(t/T,alpha1*180/pi,'r-',t/T,alpha2*180/pi,'b-','LineWidth',2)    
% xlabel('\itNormalized time')
% ylabel('\it\alpha_1 & \alpha_2 (deg)')
% legend('\alpha_1 (t)','\alpha_2 (t)')
% title('攻角随时间的变化规律')   % 攻角随时间的变化规律
% grid on
% axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 翅坐标系下：气动力系数
%% lift and drag coefficients with Alpha——随攻角变化的升阻力系数和法向气动力系数
% alpha=45;     %假定攻角恒定不变;下面公式的升阻力系数为:C_L=1.8046;C_D=1.7037.
alpha=alpha2;
% (1)下面的经验公式来自1999-science-MH Dickinson的文献——第一种
% C_L =0.225+1.58*sin((2.13*alpha*180/pi-7.2)*pi/180);  % 几何攻角正负交替(alpha),无需使用绝对值符号abs(alpha);
% C_D =1.92-1.55*cos((2.04*alpha*180/pi-9.82)*pi/180);  % 几何攻角正负交替(alpha),无需使用绝对值符号abs(alpha);
% C_N=cos(alpha).*C_L2+sin(alpha).*C_D2;  % 几何攻角正负交替(alpha2),无需使用绝对值符号abs(alpha);
% (2) lift and drag coefficients with Alpha——随攻角变化的升阻力系数和法向气动力系数—第二种—正负变化的系数
% (a) 1999-Science-MH Dickinson——角度alpha以度数表示,但是三角函数是针对弧度制的
% C_L =(0.225+1.58*sin((2.13*abs(alpha)*180/pi-7.2)*pi/180)); 
% C_D =(1.92-1.55*cos((2.04*abs(alpha)*180/pi-9.82)*pi/180));
% (b) 2004-JEB-Wang ZJ——角度alpha以度数表示,但是三角函数是针对弧度制的
% C_D =(1.92-1.55*cos((2.04*abs(alpha)*180/pi-9.82)*pi/180));
% C_D =1.92+1.55*cos((2.04*alpha1-9.82)*pi/180);
% (c) 平均升阻力系数和其比值
% C_L_aver=trapz(t,C_L)/(3*T); % C_L_aver =1.5088;
% C_D_aver=trapz(t,C_D)/(3*T) % C_D_aver =1.9123;
% C_L2C_D_aver=C_L_aver/C_D_aver; % C_L2C_D_aver =0.7890;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (9) 2014-JRSI-Nabawy——考虑翅膀几何形貌参数影响的气动力系数
% C_La2d=2*pi;    % 单位是rad^(-1), 这里2*pi (rad^(-1))= 0.11 (deg^(-1));   
C_La2d=5.15662;  % 单位是rad^(-1), 针对典型昆虫雷诺数的平板, 建议使用 0.09 (deg^(-1)) % 采用前缘吸力比拟法建立的波尔豪森升力系数模型C_L_polhamus1完全重合
% The parameter E is the edge correction proposed by Jones [42] for the lifting line theory 
% and is evaluated as the quotient of the wing semi-perimeter to its length[42,43].
% lambda=0.755; % 人为引入一个缩放因子, 以便于实验测试而得的气动力系数进行对比, 当 C_La2d=2*pi;时与实验拟合结果较近
% lambda=0.61; % 人为引入一个缩放因子, 以便于实验测试而得的气动力系数进行对比, 当 C_La2d=5.15662; ;时与实验拟合结果较近
lambda=0.70; % 采用这个缩放因子与采用Dickinson拟合的系数计算而得的升重比和气动功率密度较接近,即P_asterisk=29.7503;  L =1.2761;
% x=[3.004,0.8854,0.3289,0.356737];
% R_wing=x(1);
% C_aver=x(2);
% xr0=x(3);
% C_maxyaxis=x(4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C_periEdge=C_perimeter_to_Edge_correction(R_wing,C_aver,xr0,C_maxyaxis);
% C_perimeter_to_Edge_correction
%%%%%%%%%%%%%%%%%%%%%%%%%
R_wingeff=3.004;    %有效翅膀长度(mm)  
C_avereff=0.8854;  % 单位:mm
xr=0.3289;                % x-root offset  \mm
%%%%%%%%%%%%%%%%%%%%%%%%%
% R_wing=R_wingeff;
% C_aver=C_avereff;
% xr0=xr;
x_0_vari=C_maxyaxis;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 翅根-偏离-坐标系原点的距离
R_proximal=xr;                                                    % xr=3.19;     %RJ Wood设计的翅膀—\mm
R_distal=R_wingeff+xr;                                        % yr=0.73;    %RJ Wood设计的翅膀—\mm
x=linspace(R_proximal,R_distal,200);
x_mod_Root=0.636;                                            % mm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 针对翅根和翅尖连线的扭转轴定出的前缘     
% C_maxy=C_lead_ymax-C_maxy*C_max_LtoT; %转动轴偏离弦向中点的偏移量坐标,在扭转轴向上偏移 -C_maxy之后  %XXX
yr_lead=-0.08249*x.^6+0.9167*x.^5-4.04*x.^4+8.872*x.^3-10.06*x.^2+5.674*x-0.413-x_mod_Root;  
yr_trail=-0.0333*x.^6+0.504*x.^5-2.795*x.^4+7.258*x.^3-8.769*x.^2+3.739*x+0.1282-x_mod_Root;
%% 采用多项式函数拟合获得——无量纲前后缘分布函数和弦长分布函数
% (a) 无量纲前缘分布函数
r_nd=(x-xr)/R_wingeff;
yr_leadnd0=yr_lead/C_avereff;
P_coeff_lead=polyfit(r_nd,yr_leadnd0,6);
% (b)  无量纲后缘分布函数
yr_trailnd0=yr_trail/C_avereff;
P_coeff_trail=polyfit(r_nd,yr_trailnd0,6);
% % (c)  无量纲弦长分布函数
% Cr_nd=yr_leadnd0-yr_trailnd0;
% P_coeff_Cr=polyfit(r_nd,Cr_nd,6);  % 多项式系数  % Cr_nd2=polyval(Coeff,r_nd1);
syms r   r_nd   % 无量纲弦长分布为6阶多项式——转换必须有这条指令
yr_leadnd=vpa(poly2sym(P_coeff_lead,r_nd),6); 
yr_trailnd=vpa(poly2sym(P_coeff_trail,r_nd),6);
% Cr_nd=vpa(poly2sym(P_coeff_Cr,r_nd),6);  
% yr_leadnd =-68.4639*r_nd^6+208.297*r_nd^5-245.231*r_nd^4+137.467*r_nd^3-36.8594*r_nd^2+4.79235*r_nd-0.156071;
% yr_trailnd =-27.6379*r_nd^6+121.093*r_nd^5-185.804*r_nd^4+125.603*r_nd^3-33.1053*r_nd^2-0.145527*r_nd-0.156013;
% Cr_nd =-40.826*r_nd^6+87.204*r_nd^5-59.4267*r_nd^4+11.8645*r_nd^3-3.75408*r_nd^2+4.93788*r_nd-0.0000578215;
% C_nd=Cr_nd;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 初始果蝇翅膀
% x_mod_Root=0.636;    
% y_r_lead=-0.08249*r.^6+0.9167*r.^5-4.04*r.^4+8.872*r.^3-10.06*r.^2+5.674*r-0.413-x_mod_Root;  
% y_r_trail=-0.0333*r.^6+0.504*r.^5-2.795*r.^4+7.258*r.^3-8.769*r.^2+3.739*r+0.1282-x_mod_Root;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 动态缩放比例翅膀
%%%%%%%%%%%%%%%%%%%%%%%%%
f_x_lead=C_aver*yr_leadnd;  % 符号函数
f_x_trail =C_aver*yr_trailnd;  % 符号函数
%%%%%%%%%%%%%%%%%%%%%%%%%
f_x_lead1=inline(vectorize(f_x_lead),'r_nd');  %数值函数
f_x_trail1=inline(vectorize(f_x_trail),'r_nd');   %数值函数
r_nd1=linspace(0,1,200);     % x=linspace(R_proximal,R_distal,200);  % x=r_nd*R_wingeff+xr;
f_x_lead2=f_x_lead1(r_nd1); 
f_x_trail2=f_x_trail1(r_nd1);
rx=r_nd1*R_wing+xr0;  % rx=linspace(0,1,200)*R_wingeff+xr; 
r_x_min=min(rx);  
r_x_max=max(rx);          % r_x_max=100.3289;
% cftool
warning('off')
P_coeff_le=polyfit(rx,f_x_lead2,6);     % 多项式系数
P_coeff_tr=polyfit(rx,f_x_trail2,6);      % 多项式系数
y_r_lead=vpa(poly2sym(P_coeff_le,r),6);    % 符号函数
y_r_trail=vpa(poly2sym(P_coeff_tr,r),6);     % 符号函数
% %%%%%%%%%%%%%%%%%%%%%%%%%
fun_le=expand((1+(diff(y_r_lead,r,1))^2)^(1/2));             % fun_le=simplify(expand((1+(diff(y_r_lead,r,1))^2)^(1/2)))
C_perimeter_le=double(int(fun_le,r,r_x_min,r_x_max));     % C_perimeter_le =3.2791; % change double to vpa
fun_tr=expand((1+(diff(y_r_trail,r,1))^2)^(1/2));              % fun_tr=simplify(expand((1+(diff(y_r_trail,r,1))^2)^(1/2)))
C_perimeter_tr=double(int(fun_tr,r,r_x_min,r_x_max));     % C_perimeter_le =3.6067;  % change double to vpa
E_C_peri=((C_perimeter_le+C_perimeter_tr)/2)/R_wing;   % E_C_peri =1.1461;
C_periEdge=E_C_peri;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
E=lambda*C_periEdge;   % E=C/2/R; 针对初始果蝇翅膀 E_C_peri=1.146071666; 
% The parameter k is the so-called 'k-factor' included to correct for the difference in efficiency between the assumed ideal
% uniform downwash distribution and real downwash distribution [35,40,44]. For this work, the k-factor required within
% equation (2.11) will be estimated using the induced power factor expression of hovering actuator disc models [45].
k=1.51;  % 针对果蝇
% for the span of a single  wing 
% AR=3.40158;     % 注意这里的展弦比AR∈(3,5)是比较好的。% 针对果蝇
AR=(R_wing+xr0)/C_aver; 
C_La_Ny=C_La2d/(E+k*C_La2d/(pi*AR));     % 由普朗特升力线理论获得的三维翅膀升力曲线斜率  % 输出: C_La_Ny =2.7506;
% C_L_nabawy=(0.5*C_La2d/(E+k*C_La2d/(pi*AR)))*sin(2*alpha_4);
C_L_nabawy=0.5*C_La_Ny*sin(2*abs(alpha));   % 与2009-JEB-Rotational accelerations 的Fig.7图实测数据对比符合很好
% C_D_nabawy=C_Lnabawy.*tan(alpha_4);   % C_Dnabawy=2*C_T*(sin(alpha))^2=C_La_Ny*(sin(alpha))^2;  
C_D_nabawy=C_La_Ny*(sin(abs(alpha))).^2;  
C_L=C_L_nabawy;
C_D=C_D_nabawy;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C_N1=cos(abs(alpha)).*C_L+sin(abs(alpha)).*C_D; %由升阻力系数合成——2010-JFM-RJ Wood
% (3) lift and drag coefficients with Alpha——随攻角变化的升阻力系数和法向气动力系数——第三种——全正系数
% C_L2 =0.225+1.58*sin((2.13*abs(alpha)*180/pi-7.2)*pi/180);  % 几何攻角全正abs(alpha);——升力系数全正
% C_D2 =1.92-1.55*cos((2.04*abs(alpha)*180/pi-9.82)*pi/180); % 几何攻角全正abs(alpha);——阻力系数全正
% % C_N2=cos(abs(alpha)).*C_L2+sin(abs(alpha)).*C_D2;                % 几何攻角为正abs(alpha)——法向力系数全正
% 正负交替-由升阻力系数合成—— 2012-IEEE ASME TM-Veaceslav Arabagi 或2009-Science-Deng Xinyan
% C_N2=sign(alpha2).*sqrt(C_L2.^2+C_D2.^2); 
% (4) Normal and tangential coefficients with Alpha——随攻角变化的法向和切向气动力系数——第四种——全正系数
% C_N3=3.4*sin(abs(alpha));      % 2006-IEEE TR-Deng Xinyan 或 2010-EAE-RJ Wood-法向气动力系数输出
% 切向(tangential)气动力系数C_T只在alpha∈(-pi/4,pi/4)时不为零，其他情况为零
% if alpha<pi/4 & alpha>-pi/4
%     C_T=0.4*cos(2*alpha).^2
% else
%     C_T=0;
% end
% C_T=0.4*(cos(2*alpha)).^2.*(alpha>-pi/4 & alpha<pi/4);       %切向气动力系数输出
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(4)        % 图6—翅坐标系下—升阻力系数
% plot(t/T,C_L,'r-',t/T,C_D,'b-','LineWidth',2);      %时间正则化，乘以频率f, 或者除以周期T;
% xlabel('\itt (Normalized time with flapping period)')
% ylabel('\itForce coefficients')
% % title('Coefficients of lift and drag \itvs. t \rm for flapping wing')
% title('气动升阻力系数随着时间的变化规律')
% legend('\itC_L','\itC_D')
% grid on
% axis([0.9,4.05,-inf,inf])
% figure(5)     % 图7—翅坐标系下—法向和切向气动力系数
% plot(t/T,C_N3,'r-',t/T,C_T,'b-')                                % 得到的法向和切向气动力系数需要核实
% xlabel('Normalized time')
% ylabel('C_N3(\alpha(t)) & C_T(\alpha (t))')
% legend('C_{N3}(\alpha)','C_T(\alpha)')
% title('法向和切向气动力系数随时间的变化规律')
% grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %三种法向气动力系数
% figure(6)     % 图8—翅坐标系下—法向气动力系数
% plot(t/T,C_N1,'r-',t/T,C_N2,'b-',t/T,C_N3,'g-','LineWidth',2);      %时间正则化，乘以频率f, 或者除以周期T;
% xlabel('\itt (Normalized time with flapping period)')
% ylabel('\itForce coefficients')
% % title('Coefficients of normal force \itvs. t \rm for flapping wing')
% title('法向气动力系数随时间的变化规律')
% legend('\itC_{N1}','\itC_{N2}','\itC_{N3}')
% grid on
% axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 翅运动规律输出和气动力系数输出
% wing_m_output=zeros(200,12);
% wing_m_output=[t',phi',psi',alpha',dphi',dpsi',ddphi',ddpsi',C_N1',C_L',C_D',C_T'];
wing_m_output=[t',phi',psi',alpha',dphi',dpsi',ddphi',ddpsi',C_N1'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




