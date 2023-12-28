function Y_rcpnd=COP_Ycpnd2_fruitfly3(alpha)
%% (1) �����ת���������ء�����⾻ѹ�ĵ�������λ��Y_cpnd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R=16.0148-0.88=15.1348;
% �� r_nd��(0.88/15.1348,13.4427/15.1348)
% clear all; clc;
R_wingeff=3.004;    %��Ч��򳤶�(mm) 
xr=0.3289;                     % x-root offset  \mm
xr_nd=xr/R_wingeff;      % x-root offset  ������չ��ƫ�þ���
C_avereff=0.8854;         % mm    
% yr=0.73;                     % RJ Wood��Ƶĳ��\mm
yr=0;                              % Ťת��ͨ�������������ߡ�\mm
yr_nd=yr/C_avereff;       % y-root offset  ����������ƫ�þ��� yr_nd = 0.0214;
% % ���-ƫ��-����ϵԭ��ľ���
% R_proximal=xr;                                               % xr=3.19;     %RJ Wood��Ƶĳ��\mm
% R_distal=R_wingeff+xr;                                   % yr=0.73;    %RJ Wood��Ƶĳ��\mm
% x=linspace(R_proximal,R_distal,200);
% yr_lead=-0.08249*x.^6+0.9167*x.^5-4.04*x.^4+8.872*x.^3-10.06*x.^2+5.674*x-0.413;  
% yr_trail=-0.0333*x.^6+0.504*x.^5-2.795*x.^4+7.258*x.^3-8.769*x.^2+3.739*x+0.1282;
syms r_nd
% �����ǳ�ǰԵ�����������Ťת���λ�ò�ͬ��Ҫ���зֶκ�������
yr_leadnd=(-0.08249*r_nd^6+0.9167*r_nd^5-4.04*r_nd^4+8.872*r_nd^3-10.06*r_nd^2+5.674*r_nd-0.413)/C_avereff; 
% �������ҳ��ֲ�Ϊ6�׶���ʽ
Cr_nd2 =-40.827*r_nd^6+87.2061*r_nd^5-59.4281*r_nd^4+11.8648*r_nd^3-3.75417*r_nd^2+4.938*r_nd-0.0000578229;
C_nd=Cr_nd2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wing_kenimatics=kenimatics_wing_and_AoA();        %���ú���kenimatics_wing_and_AoA
% % size(wing_kenimatics)     %  (400*16)
% alpha=wing_kenimatics(:,4);
d_cprnd=0.82*abs(alpha)/pi+0.05;                  %��ת���������ص�����ѹ��λ��;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yr_cpnd=yr_nd+yr_leadnd-C_nd*d_cprnd;
fx2=(r_nd+xr_nd)^2*C_nd;                  % ������������F_nd��ԭʼ��������
fx4=expand(fx2);
F_nd=double(int(fx4,r_nd,0,1));           % Result: F_nd=0.46392
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������������(nondimention_aerodynamic_component)����⡪��F_nd
% ע�⡪���öγ����мǲ����޸ģ�ǰ��ֻҪ��֤������ȷ���������ҳ��ֲ����ɡ�
%���µĹ�ʽӦʹ�ú���������ٵ��ҳ��ֲ���ʽC_nd
% R2nd2=double(int(r_nd^2*C_nd,r_nd,0,1)); %��������صĻ�ת�뾶��ƽ��
% R1nd1=double(int(r_nd*C_nd,r_nd,0,1));     %һ������صĻ�ת�뾶
% % S_nd=double(int(C_nd,r_nd,0,1));                %�����ٳ����
% F_nd2=R2nd2+2*xr_nd*R1nd1+xr_nd^2;    %ʹ����������Ҳ��ȷ; ���:F_nd2 =0.5024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Y_rcpnd=int(yr_cpnd*fx4,r_nd,0,1)/F_nd;
% disp(['��ѹ�ĵ�������λ��Y_cpnd(alpha)=' num2str(Y_rcpnd)  ' ���ٵ�λ������mm'])
% Y_rcpnd=abs(double(int(yr_cpnd*fx4,r_nd,0,1))/F_nd);
Y_rcpnd=double(int(yr_cpnd*fx4,r_nd,0,1))/F_nd;  % ������һ���ָ��õ��Ľ��һ��

