function wing_m_output=kenimatics_wing_and_AoA_fruitfly_exp_Cfcoeff(R_wing,C_aver,xr0,C_maxyaxis)
%% kenimatics_wing_and_AoA
% ���˶����ɺͼ��ι���(AOA)
% (ע�⣺���ռ��������Ťת��,��Ҫʱ���������ʵ��ʱ������׼)��������Ҫ���ͺ˶�
% clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �������ź������󵼡�����ý����ʡ������������ڼ���������������ʱ����Ҫ���¼�����õ�Ťת��
% (1) 2014-Science-ʵ����Ĵ�ǡ��� ����4�׸���Ҷ������� 
syms t         % t  �Լ�����ʱ����
w =1185.6;     % ��Ƶ��   %  f=188.7; T=1/f;  %����Ƶ�� (Hz)������  
phi1=sym('(3.9008+65.0445*cos(w*t)+4.2642*sin(w*t)+3.5806*cos(2*w*t)-2.9492*sin(2*w*t)+0.1319*cos(3*w*t)+0.3639*sin(3*w*t)+0.7844*cos(4*w*t)+0.2098*sin(4*w*t))*pi/180');  %���ź���: ԭʼ���ݵĶ�������ת��Ϊ������
dphi1=diff(phi1,t,1);
ddphi1=diff(phi1,t,2); 
dphi=inline(vectorize(dphi1),'w','t');                    % ��ֵ����
ddphi=inline(vectorize(ddphi1),'w','t');   
% (2) 2014-Science-ʵ���Ťת�ǡ�������8�׸���Ҷ�������    
psi1=sym('-(4.2936+1.8536*cos(t*w)+59.6529*sin(t*w)+5.1852*cos(2*t*w)+1.6095*sin(2*t*w)-8.4569*cos(3*t*w)+9.8057*sin(3*t*w)+3.9562*cos(4*t*w)+5.8064*sin(4*t*w)-3.0337*cos(5*t*w)-2.8749*sin(5*t*w)-2.8771*cos(6*t*w)+0.6686*sin(6*t*w)+0.8649*cos(7*t*w)-0.6137*sin(7*t*w)+0.0771*cos(8*t*w)-1.0007*sin(8*t*w))*pi/180');  %���ź���:ԭʼ���ݵĶ�������ת��Ϊ������
dpsi1=diff(psi1,t,1);   
ddpsi1=diff(psi1,t,2);    
dpsi=inline(vectorize(dpsi1),'w','t');  %��ֵ����
ddpsi=inline(vectorize(ddpsi1),'w','t');  %��ֵ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ������������ֵ
f=188.7; T=1/f;  %����Ƶ�� (Hz)������  % w =1185.6; 
t=linspace(0.0052824335,0.0052824335+3*T,1000);  % t_steady1   
dphi=dphi(w,t);         %(1*100)�������������Ĵ������                                                           % ���
ddphi=ddphi(w,t);    %(1*100)�������������Ĵ�Ǽ�����                                                         % ���
dpsi=dpsi(w,t);         %(1*100)������������Ťת������                                                             % ���
ddpsi=ddpsi(w,t);     %(1*100)������������Ťת�Ǽ�����                                                         % ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �Ĵ�Ǻ�Ťת��
% �Ĵ�ǡ��� (1*100)�������������Ĵ�ǡ���������            %���                                     
phi=(3.9008+65.0445*cos(w*t)+4.2642*sin(w*t)+3.5806*cos(2*w*t)-2.9492*sin(2*w*t)+...
        0.1319*cos(3*w*t)+0.3639*sin(3*w*t)+0.7844*cos(4*w*t)+0.2098*sin(4*w*t))*pi/180; % ԭʼ���ݵĶ�������ת��Ϊ������
% Ťת�ǡ���(1*100)������������Ťת�ǡ���������            %���
psi=-(4.2936+1.8536*cos(t*w)+59.6529*sin(t*w)+5.1852*cos(2*t*w)+1.6095*sin(2*t*w)-8.4569*cos(3*t*w)+9.8057*sin(3*t*w)+... 
        3.9562*cos(4*t*w)+5.8064*sin(4*t*w)-3.0337*cos(5*t*w)-2.8749*sin(5*t*w)-2.8771*cos(6*t*w)+...
        0.6686*sin(6*t*w)+0.8649*cos(7*t*w)-0.6137*sin(7*t*w)+0.0771*cos(8*t*w)-1.0007*sin(8*t*w))*pi/180;  % ԭʼ���ݵĶ�������ת��Ϊ������
% [phi_min,k]=min(phi);  % ���:  phi_min =-1.0157;  k =10756;      
% t_0=t(k);                       % ���: t0 =0.0028; 
%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(1)       % ͼ1�����Ĵ�Ǻ�Ťת��
% % subplot(311)
% plot(t/T,phi*180/pi,'r-',t/T,psi*180/pi,'b-','LineWidth',2)  %ת��Ϊms �� ����degree   *10^3   *180/pi
% xlabel('\itNormalized time')
% ylabel('\itAngle (��)')
% legend('\it\phi(t)','\it\psi(t)')
% title('�Ĵ�Ǻ�Ťת����ʱ��ı仯����')   % �Ĵ�Ǻ�Ťת����ʱ��ı仯����
% grid on
% axis([0.9,4.05,-105,105])
% set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot-�Ĵ�����ʺ�Ťת������
% subplot(312)                                                       
% plot(t/T,dphi,'r-',t/T,dpsi,'b-','LineWidth',2)
% xlabel('\itNormalized time')
% ylabel('������ (rad/s)')
% legend('\itd\phi(t)','\itd\psi(t)')
% title('�Ĵ�����ʺ�Ťת��������ʱ��ı仯����') 
% grid on
% axis([0.9,4.05,-inf,inf])
% set(gca,'XTick',(0.9:0.1:4.05))
% % Plot-�Ĵ�Ǽ����ʺ�Ťת�ǽǼ�����
% subplot(313)
% plot(t/T,ddphi,'r-',t/T,ddpsi,'b-','LineWidth',2)
% xlabel('\itNormalized time')
% ylabel('�Ǽ����� (rad/s^-2)')
% legend('\itdd\phi(t)','\itdd\psi(t)')
% title('�Ĵ�Ǽ����ʺ�Ťת�Ǽ�������ʱ��ı仯����') 
% grid on
% axis([0.9,4.05,-inf,inf])
% set(gca,'XTick',(0.9:0.1:4.05))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot-Ťת�Ǻͼ��ι���AOA
% % alpha1=pi/2+psi.*sign(dphi);        %(1*200)���������������ι��ǡ���������        %�������ȫ�����ι��� 
% alpha1=pi/2-psi.*sign(dphi);        %(1*200)���������������ι��ǡ���������        %�������ȫ�����ι���  % ʵ��Ťת��ǰ����
% % Y = sign(X) returns an array Y the same size as X, where each element of Y is:
% % *1 if the corresponding element of X is greater than zero
% % * 0 if the corresponding element of X equals zero
% % *-1 if the corresponding element of X is less than zero
% figure(2)                                                              % ͼ2���� ע�����Ｘ�ι���ʼ��ȡ��ֵ
% % % x_interval=[0,1/2,1/2,0];
% % % y_interval=[-100,-100,100,100];
% % % fill(x_interval,y_interval,'y');
% % % hold on
% % % legend('','\it\psi(t)','\it\alpha_1(t)')
% plot(t/T,psi*180/pi,'b-',t/T,alpha1*180/pi,'g-','LineWidth',2)      %Ťת�Ǻͼ��ι���AOA��ʱ��ı仯����
% xlabel('\itNormalized time')
% ylabel('\itAngle (��)')
% legend('\it\psi(t)','\it\alpha_1(t)')
% hold on
% L=length(t);
% plot([0,t(L)/T],[0,0],'k-');     %��x-axis
% title('Ťת�Ǻͼ��ι���alpha_1��ʱ��ı仯����') 
% grid on
% axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �������ϵ�µĽ��ٶ�
% omega_x=dpsi;   % Ťת��:   x(1)=psi;  x(2)=dpsi;   
omega_y=dphi.*sin(psi);
omega_z=dphi.*cos(psi);
% omega_h=dphi;    % �������ϵ�½���������    % omega_h=sqrt(omega_y^2+omega_z^2);  % ���ַ���˳ʱ��
%% �������ϵ�µĽǼ��ٶȡ����������������ļ���
% domega_x=ddpsi;
% domega_y=ddphi.*sin(psi)+dphi.*dpsi.*cos(psi); 
% domega_z=ddphi.*cos(psi)-dphi.*dpsi.*sin(psi); 
%% �������Ǽ��㡪��ȡ�����ٶ�����ڸ�������ٶȣ���������Ӹ��ţ�
v_y_nonr=-omega_z;   % v_y=r*dphi*cos(psi)
v_z_nonr=omega_y;    % v_z=-r*dphi*sin(psi)
alpha2=atan2(-v_y_nonr,v_z_nonr);   % ��ȷ����ע�������ĵ�alpha=atan2(omega_z,-omega_y)*180/pi; ��ͬ  % ʵ��Ťת��ǰ����
% ����alpha=atan2(cot(psi))=atan2(cot(pi/2-alpha))=atan2(tan(alpha)); %����atan2������������ֵ��������alpha>pi/2ʱ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(3)                                               % ͼ3����ʹ�ó������ϵ�µĽ��ٶ���⼸�ι���
% plot(t/T,alpha1*180/pi,'r-',t/T,alpha2*180/pi,'b-','LineWidth',2)    
% xlabel('\itNormalized time')
% ylabel('\it\alpha_1 & \alpha_2 (deg)')
% legend('\alpha_1 (t)','\alpha_2 (t)')
% title('������ʱ��ı仯����')   % ������ʱ��ı仯����
% grid on
% axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ������ϵ�£�������ϵ��
%% lift and drag coefficients with Alpha�����湥�Ǳ仯��������ϵ���ͷ���������ϵ��
% alpha=45;     %�ٶ����Ǻ㶨����;���湫ʽ��������ϵ��Ϊ:C_L=1.8046;C_D=1.7037.
alpha=alpha2;
% (1)����ľ��鹫ʽ����1999-science-MH Dickinson�����ס�����һ��
% C_L =0.225+1.58*sin((2.13*alpha*180/pi-7.2)*pi/180);  % ���ι�����������(alpha),����ʹ�þ���ֵ����abs(alpha);
% C_D =1.92-1.55*cos((2.04*alpha*180/pi-9.82)*pi/180);  % ���ι�����������(alpha),����ʹ�þ���ֵ����abs(alpha);
% C_N=cos(alpha).*C_L2+sin(alpha).*C_D2;  % ���ι�����������(alpha2),����ʹ�þ���ֵ����abs(alpha);
% (2) lift and drag coefficients with Alpha�����湥�Ǳ仯��������ϵ���ͷ���������ϵ�����ڶ��֡������仯��ϵ��
% (a) 1999-Science-MH Dickinson�����Ƕ�alpha�Զ�����ʾ,�������Ǻ�������Ի����Ƶ�
% C_L =(0.225+1.58*sin((2.13*abs(alpha)*180/pi-7.2)*pi/180)); 
% C_D =(1.92-1.55*cos((2.04*abs(alpha)*180/pi-9.82)*pi/180));
% (b) 2004-JEB-Wang ZJ�����Ƕ�alpha�Զ�����ʾ,�������Ǻ�������Ի����Ƶ�
% C_D =(1.92-1.55*cos((2.04*abs(alpha)*180/pi-9.82)*pi/180));
% C_D =1.92+1.55*cos((2.04*alpha1-9.82)*pi/180);
% (c) ƽ��������ϵ�������ֵ
% C_L_aver=trapz(t,C_L)/(3*T); % C_L_aver =1.5088;
% C_D_aver=trapz(t,C_D)/(3*T) % C_D_aver =1.9123;
% C_L2C_D_aver=C_L_aver/C_D_aver; % C_L2C_D_aver =0.7890;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (9) 2014-JRSI-Nabawy�������ǳ�򼸺���ò����Ӱ���������ϵ��
% C_La2d=2*pi;    % ��λ��rad^(-1), ����2*pi (rad^(-1))= 0.11 (deg^(-1));   
C_La2d=5.15662;  % ��λ��rad^(-1), ��Ե���������ŵ����ƽ��, ����ʹ�� 0.09 (deg^(-1)) % ����ǰԵ�������ⷨ�����Ĳ�����ɭ����ϵ��ģ��C_L_polhamus1��ȫ�غ�
% The parameter E is the edge correction proposed by Jones [42] for the lifting line theory 
% and is evaluated as the quotient of the wing semi-perimeter to its length[42,43].
% lambda=0.755; % ��Ϊ����һ����������, �Ա���ʵ����Զ��õ�������ϵ�����жԱ�, �� C_La2d=2*pi;ʱ��ʵ����Ͻ���Ͻ�
% lambda=0.61; % ��Ϊ����һ����������, �Ա���ʵ����Զ��õ�������ϵ�����жԱ�, �� C_La2d=5.15662; ;ʱ��ʵ����Ͻ���Ͻ�
lambda=0.70; % ��������������������Dickinson��ϵ�ϵ��������õ����رȺ����������ܶȽϽӽ�,��P_asterisk=29.7503;  L =1.2761;
% x=[3.004,0.8854,0.3289,0.356737];
% R_wing=x(1);
% C_aver=x(2);
% xr0=x(3);
% C_maxyaxis=x(4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C_periEdge=C_perimeter_to_Edge_correction(R_wing,C_aver,xr0,C_maxyaxis);
% C_perimeter_to_Edge_correction
%%%%%%%%%%%%%%%%%%%%%%%%%
R_wingeff=3.004;    %��Ч��򳤶�(mm)  
C_avereff=0.8854;  % ��λ:mm
xr=0.3289;                % x-root offset  \mm
%%%%%%%%%%%%%%%%%%%%%%%%%
% R_wing=R_wingeff;
% C_aver=C_avereff;
% xr0=xr;
x_0_vari=C_maxyaxis;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���-ƫ��-����ϵԭ��ľ���
R_proximal=xr;                                                    % xr=3.19;     %RJ Wood��Ƶĳ��\mm
R_distal=R_wingeff+xr;                                        % yr=0.73;    %RJ Wood��Ƶĳ��\mm
x=linspace(R_proximal,R_distal,200);
x_mod_Root=0.636;                                            % mm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��Գ���ͳ�����ߵ�Ťת�ᶨ����ǰԵ     
% C_maxy=C_lead_ymax-C_maxy*C_max_LtoT; %ת����ƫ�������е��ƫ��������,��Ťת������ƫ�� -C_maxy֮��  %XXX
yr_lead=-0.08249*x.^6+0.9167*x.^5-4.04*x.^4+8.872*x.^3-10.06*x.^2+5.674*x-0.413-x_mod_Root;  
yr_trail=-0.0333*x.^6+0.504*x.^5-2.795*x.^4+7.258*x.^3-8.769*x.^2+3.739*x+0.1282-x_mod_Root;
%% ���ö���ʽ������ϻ�á���������ǰ��Ե�ֲ��������ҳ��ֲ�����
% (a) ������ǰԵ�ֲ�����
r_nd=(x-xr)/R_wingeff;
yr_leadnd0=yr_lead/C_avereff;
P_coeff_lead=polyfit(r_nd,yr_leadnd0,6);
% (b)  �����ٺ�Ե�ֲ�����
yr_trailnd0=yr_trail/C_avereff;
P_coeff_trail=polyfit(r_nd,yr_trailnd0,6);
% % (c)  �������ҳ��ֲ�����
% Cr_nd=yr_leadnd0-yr_trailnd0;
% P_coeff_Cr=polyfit(r_nd,Cr_nd,6);  % ����ʽϵ��  % Cr_nd2=polyval(Coeff,r_nd1);
syms r   r_nd   % �������ҳ��ֲ�Ϊ6�׶���ʽ����ת������������ָ��
yr_leadnd=vpa(poly2sym(P_coeff_lead,r_nd),6); 
yr_trailnd=vpa(poly2sym(P_coeff_trail,r_nd),6);
% Cr_nd=vpa(poly2sym(P_coeff_Cr,r_nd),6);  
% yr_leadnd =-68.4639*r_nd^6+208.297*r_nd^5-245.231*r_nd^4+137.467*r_nd^3-36.8594*r_nd^2+4.79235*r_nd-0.156071;
% yr_trailnd =-27.6379*r_nd^6+121.093*r_nd^5-185.804*r_nd^4+125.603*r_nd^3-33.1053*r_nd^2-0.145527*r_nd-0.156013;
% Cr_nd =-40.826*r_nd^6+87.204*r_nd^5-59.4267*r_nd^4+11.8645*r_nd^3-3.75408*r_nd^2+4.93788*r_nd-0.0000578215;
% C_nd=Cr_nd;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ʼ��Ӭ���
% x_mod_Root=0.636;    
% y_r_lead=-0.08249*r.^6+0.9167*r.^5-4.04*r.^4+8.872*r.^3-10.06*r.^2+5.674*r-0.413-x_mod_Root;  
% y_r_trail=-0.0333*r.^6+0.504*r.^5-2.795*r.^4+7.258*r.^3-8.769*r.^2+3.739*r+0.1282-x_mod_Root;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��̬���ű������
%%%%%%%%%%%%%%%%%%%%%%%%%
f_x_lead=C_aver*yr_leadnd;  % ���ź���
f_x_trail =C_aver*yr_trailnd;  % ���ź���
%%%%%%%%%%%%%%%%%%%%%%%%%
f_x_lead1=inline(vectorize(f_x_lead),'r_nd');  %��ֵ����
f_x_trail1=inline(vectorize(f_x_trail),'r_nd');   %��ֵ����
r_nd1=linspace(0,1,200);     % x=linspace(R_proximal,R_distal,200);  % x=r_nd*R_wingeff+xr;
f_x_lead2=f_x_lead1(r_nd1); 
f_x_trail2=f_x_trail1(r_nd1);
rx=r_nd1*R_wing+xr0;  % rx=linspace(0,1,200)*R_wingeff+xr; 
r_x_min=min(rx);  
r_x_max=max(rx);          % r_x_max=100.3289;
% cftool
warning('off')
P_coeff_le=polyfit(rx,f_x_lead2,6);     % ����ʽϵ��
P_coeff_tr=polyfit(rx,f_x_trail2,6);      % ����ʽϵ��
y_r_lead=vpa(poly2sym(P_coeff_le,r),6);    % ���ź���
y_r_trail=vpa(poly2sym(P_coeff_tr,r),6);     % ���ź���
% %%%%%%%%%%%%%%%%%%%%%%%%%
fun_le=expand((1+(diff(y_r_lead,r,1))^2)^(1/2));             % fun_le=simplify(expand((1+(diff(y_r_lead,r,1))^2)^(1/2)))
C_perimeter_le=double(int(fun_le,r,r_x_min,r_x_max));     % C_perimeter_le =3.2791; % change double to vpa
fun_tr=expand((1+(diff(y_r_trail,r,1))^2)^(1/2));              % fun_tr=simplify(expand((1+(diff(y_r_trail,r,1))^2)^(1/2)))
C_perimeter_tr=double(int(fun_tr,r,r_x_min,r_x_max));     % C_perimeter_le =3.6067;  % change double to vpa
E_C_peri=((C_perimeter_le+C_perimeter_tr)/2)/R_wing;   % E_C_peri =1.1461;
C_periEdge=E_C_peri;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
E=lambda*C_periEdge;   % E=C/2/R; ��Գ�ʼ��Ӭ��� E_C_peri=1.146071666; 
% The parameter k is the so-called 'k-factor' included to correct for the difference in efficiency between the assumed ideal
% uniform downwash distribution and real downwash distribution [35,40,44]. For this work, the k-factor required within
% equation (2.11) will be estimated using the induced power factor expression of hovering actuator disc models [45].
k=1.51;  % ��Թ�Ӭ
% for the span of a single  wing 
% AR=3.40158;     % ע�������չ�ұ�AR��(3,5)�ǱȽϺõġ�% ��Թ�Ӭ
AR=(R_wing+xr0)/C_aver; 
C_La_Ny=C_La2d/(E+k*C_La2d/(pi*AR));     % �����������������ۻ�õ���ά�����������б��  % ���: C_La_Ny =2.7506;
% C_L_nabawy=(0.5*C_La2d/(E+k*C_La2d/(pi*AR)))*sin(2*alpha_4);
C_L_nabawy=0.5*C_La_Ny*sin(2*abs(alpha));   % ��2009-JEB-Rotational accelerations ��Fig.7ͼʵ�����ݶԱȷ��Ϻܺ�
% C_D_nabawy=C_Lnabawy.*tan(alpha_4);   % C_Dnabawy=2*C_T*(sin(alpha))^2=C_La_Ny*(sin(alpha))^2;  
C_D_nabawy=C_La_Ny*(sin(abs(alpha))).^2;  
C_L=C_L_nabawy;
C_D=C_D_nabawy;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C_N1=cos(abs(alpha)).*C_L+sin(abs(alpha)).*C_D; %��������ϵ���ϳɡ���2010-JFM-RJ Wood
% (3) lift and drag coefficients with Alpha�����湥�Ǳ仯��������ϵ���ͷ���������ϵ�����������֡���ȫ��ϵ��
% C_L2 =0.225+1.58*sin((2.13*abs(alpha)*180/pi-7.2)*pi/180);  % ���ι���ȫ��abs(alpha);��������ϵ��ȫ��
% C_D2 =1.92-1.55*cos((2.04*abs(alpha)*180/pi-9.82)*pi/180); % ���ι���ȫ��abs(alpha);��������ϵ��ȫ��
% % C_N2=cos(abs(alpha)).*C_L2+sin(abs(alpha)).*C_D2;                % ���ι���Ϊ��abs(alpha)����������ϵ��ȫ��
% ��������-��������ϵ���ϳɡ��� 2012-IEEE ASME TM-Veaceslav Arabagi ��2009-Science-Deng Xinyan
% C_N2=sign(alpha2).*sqrt(C_L2.^2+C_D2.^2); 
% (4) Normal and tangential coefficients with Alpha�����湥�Ǳ仯�ķ��������������ϵ�����������֡���ȫ��ϵ��
% C_N3=3.4*sin(abs(alpha));      % 2006-IEEE TR-Deng Xinyan �� 2010-EAE-RJ Wood-����������ϵ�����
% ����(tangential)������ϵ��C_Tֻ��alpha��(-pi/4,pi/4)ʱ��Ϊ�㣬�������Ϊ��
% if alpha<pi/4 & alpha>-pi/4
%     C_T=0.4*cos(2*alpha).^2
% else
%     C_T=0;
% end
% C_T=0.4*(cos(2*alpha)).^2.*(alpha>-pi/4 & alpha<pi/4);       %����������ϵ�����
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(4)        % ͼ6��������ϵ�¡�������ϵ��
% plot(t/T,C_L,'r-',t/T,C_D,'b-','LineWidth',2);      %ʱ�����򻯣�����Ƶ��f, ���߳�������T;
% xlabel('\itt (Normalized time with flapping period)')
% ylabel('\itForce coefficients')
% % title('Coefficients of lift and drag \itvs. t \rm for flapping wing')
% title('����������ϵ������ʱ��ı仯����')
% legend('\itC_L','\itC_D')
% grid on
% axis([0.9,4.05,-inf,inf])
% figure(5)     % ͼ7��������ϵ�¡����������������ϵ��
% plot(t/T,C_N3,'r-',t/T,C_T,'b-')                                % �õ��ķ��������������ϵ����Ҫ��ʵ
% xlabel('Normalized time')
% ylabel('C_N3(\alpha(t)) & C_T(\alpha (t))')
% legend('C_{N3}(\alpha)','C_T(\alpha)')
% title('���������������ϵ����ʱ��ı仯����')
% grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %���ַ���������ϵ��
% figure(6)     % ͼ8��������ϵ�¡�����������ϵ��
% plot(t/T,C_N1,'r-',t/T,C_N2,'b-',t/T,C_N3,'g-','LineWidth',2);      %ʱ�����򻯣�����Ƶ��f, ���߳�������T;
% xlabel('\itt (Normalized time with flapping period)')
% ylabel('\itForce coefficients')
% % title('Coefficients of normal force \itvs. t \rm for flapping wing')
% title('����������ϵ����ʱ��ı仯����')
% legend('\itC_{N1}','\itC_{N2}','\itC_{N3}')
% grid on
% axis([0.9,4.05,-inf,inf])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���˶����������������ϵ�����
% wing_m_output=zeros(200,12);
% wing_m_output=[t',phi',psi',alpha',dphi',dpsi',ddphi',ddpsi',C_N1',C_L',C_D',C_T'];
wing_m_output=[t',phi',psi',alpha',dphi',dpsi',ddphi',ddpsi',C_N1'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




