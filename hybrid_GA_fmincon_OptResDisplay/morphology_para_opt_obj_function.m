%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function obj_function=morphology_para_opt_obj_function(x)
% morphology_para_opt_obj_function
% morphology parametric optimization objective function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variable=[R_wingeff,C_avereff,xr,C_maxy];     % 变量
% LB = [2, 0.5, 0, 0];      % Lower bound            % 单位: mm & 扭转轴距前缘的无量纲距离[0,0.5]
% UB = [4, 2, 2, 0.5];     % Upper bound            % 单位: mm & 扭转轴距前缘的无量纲距离[0,0.5]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第一部分——气动功率
% 原始果蝇翅膀 R_wing=3.004;  C_aver=0.8854;   
% C_lead_ymax =0.4644;  C_trail_ymin =-0.8374;  C_max_LtoT = 1.3018; @C_maxy=0;
% Ratio_leadmax=C_lead_ymax/C_max_LtoT;
% %Ratio_leadmax=0.4644/1.3018=0.356737; %针对翅根和翅尖连线的扭转轴定出的前缘/最大前缘点和最新后缘点坐标间距=0.3567
% x=[3.004,0.8854,0.3289,0.356737]; % 初始值. % 未优化的果蝇翅膀形貌参数—翅根和翅尖连线的扭转轴定出的前缘/最大前缘点和最新后缘点坐标间距=0.3567
% C_lead_ymax =0.3255;  C_trail_ymin =-0.9764;  C_max_LtoT =1.3018;
% Ratio_leadmax=C_lead_ymax/C_max_LtoT; %Ratio_leadmax=0.3255/1.3018=0.25;%针对扭转轴位于最大前缘点和最新后缘点坐标间距0.25倍时
% x=[3.004,0.8854,0.3289,0.25]; % 初始值. % 未优化的果蝇翅膀形貌参数—扭转轴位于最大前缘点和最新后缘点坐标间距0.25倍时
% x=[3.004,0.8854,0.3289,0.5]; % 初始值. % 未优化的果蝇翅膀形貌参数—扭转轴位于最大前缘点和最新后缘点坐标间距0.5倍时
% x=[100,33.7,0.3289,0.356737];  %验证被放大后的翅膀的转动惯量——非常棒
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 变量单位: mm & 扭转轴距前缘的量纲距离[0,0.6509]——注意这里可能不用——XXX
% x=[3.004,0.8854,0.3289,0.1389];     % 未优化的果蝇翅膀形貌参数
% C_maxy25_nd=(0.464385778290230-0.138924474377504)/1.3018=0.3255/1.3018;  %C_maxy25_nd=0.25;
% x=[3.004,0.8854,0.3289,0.3255]; %翅膀被放大之前,扭转轴在翅膀最大前缘点到最小后缘点的距离1/4位置@0.25*C_max_LtoT, 见上一句指令的解释
% Ratio_leadmax=C_lead_ymax/C_max_LtoT; %Ratio_leadmax=0.4644/1.3018=0.356737; %针对翅根和翅尖连线的扭转轴定出的前缘
% x=[3.004,0.8854,0.3289,0.4644];     %翅膀被放大之前,扭转轴在翅根翅尖连线上@0.356737*C_max_LtoT, 见上一句指令的解释
% x=[3.004,0.8854,0.3289,0];          % 翅膀被放大之前,扭转轴在翅膀前缘最大值点处@0*C_max_LtoT
% x=[3.004,0.8854,0.3289,0.6509]; % 翅膀被放大之前,扭转轴在翅膀最大前缘点到最小后缘点的距离一半位置@0.5*C_max_LtoT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%@ options = gaoptimset('InitialPopulation',x_start,'TimeLimit',14400);
% x =[3.6470,1.9176,0.6487,0.4258]; 
%@options=gaoptimset('InitialPopulation',x_start,'TimeLimit',14400,'HybridFcn',{@fminsearch,fminsearchOptions});
% x =[4.0000,1.3086,0.9363,0.4644]; 
% @options=gaoptimset('InitialPopulation',x_start,'TimeLimit',14400,'HybridFcn',{@fminsearch,fminsearchOptions});
% x =[4.0000,1.2895,0.9238,0.4644]; %ConstraintFunction=@aspectratio_constraint; 
% @options=gaoptimset('InitialPopulation',x_start,'TimeLimit',14400,'HybridFcn',{@fmincon,fminconOptions});
% x =[2.0000,1.1161,1.0711,-0.1865];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x=[4.0000,0.5000,1.3364,0.5000];  % 不合理
% x=[4.0000,1.4283,0.9992,0.5000];  % 不合理
x=[2.2899,1.0561,0.3788,0.0001];  % 20150204——结果不错哦
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P_total=Aero_M_fruitfly2_exp(x);     % 正功率——平动功率和扭转功率——扭转轴功率和拍打轴功率
% size(P_total)                                      % (1000*2)
P_totalx=P_total(:,1);    % (1000*1)
P_totalz=P_total(:,2);    % (1000*1)
% xlswrite('D:\KXJ\PassiveRot_dynamic_Science_fruitfly\optimal_wing_para_motion\P_total.xlsx',P_total,'sheet1','A1:B2000');
%%%%%%%%%%%%%%%%%%%%%%%%%
N=length(P_totalx);
for i=1:N
    if P_totalx(i)<=0
        P_totalx(i)=0;
    end
end
P_totalx_posi=P_totalx;
%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:N  % N=length(P_totalx);
    if P_totalz(j)<=0
        P_totalz(j)=0;
    end
end
P_totalz_posi=P_totalz;
%%%%%%%%%%%%%%%%%%%%%%%%%
% P_total_posi=[P_totalx_posi,P_totalz_posi]; 
% xlswrite('D:\KXJ\PassiveRot_dynamic_Science_fruitfly\optimal_wing_para_motion\P_total_positive.xlsx',P_total_posi,'sheet1','A1:B1000');
%%%%%%%%%%%%%%%%%%%%%%%%%
f=188.7; T=1/f;  %翅拍频率 (Hz)和周期  % w =1185.6; 
t=linspace(0.0052824335,0.0052824335+3*T,1000);  % t_steady1 
P_totalx_aver=trapz(t,P_totalx_posi)/(3*T);  % 时均正功率——平动功率和扭转功率——扭转轴功率和拍打轴功率
P_totalz_aver=trapz(t,P_totalz_posi)/(3*T);  % 时均正功率——平动功率和扭转功率——扭转轴功率和拍打轴功率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m_insect=1.8;         % M_fly=1.8mg;  % 2014-Science-MH Dickinson     % P_asterisk =31.8058; % 量纲单位=uW/mg;
% m_insect=0.72;    % 0.72 mg  % 2007-JFM-Wang ZJ                           % P_asterisk =80.6538; % 量纲单位=uW/mg;
% m_insect=0.96;    % 0.96 mg  % 2005-JEB-MH Dickinson                    % P_asterisk =60.4903; % 量纲单位=uW/mg;
% m_insect=1.05;    % 1.05mg; % 1997-JEB-Fritz-Olaf lehmann              % P_asterisk =55.3054; % 量纲单位=uW/mg;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P_asterisk=(P_totalx_aver+P_totalz_aver)/m_insect    % 量纲单位=uW/mg;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第二部分——penaltyfun1——升重比约束——惩罚函数
% % x=[3.004,0.8854,0.3289,0.4644];  % 未优化的果蝇翅膀形貌参数——翅根和翅尖连线的扭转轴定出的前缘
% x=[3.004,0.8854,0.3289,0.356737]; % 初始值. % 未优化的果蝇翅膀形貌参数—翅根和翅尖连线的扭转轴定出的前缘/最大前缘点和最新后缘点坐标间距=0.3567
% % x=[3.004,0.8854,0.3289,0.1389];  % 未优化的果蝇翅膀形貌参数
% x=[3.004,0.8854,0.3289,0.25];     % 初始值. % 未优化的果蝇翅膀形貌参数—扭转轴位于最大前缘点和最新后缘点坐标间距0.25倍时
% @ options = gaoptimset('InitialPopulation',x_start,'TimeLimit',14400);
% x =[3.6470,1.9176,0.6487,0.4258]; 
%@options=gaoptimset('InitialPopulation',x_start,'TimeLimit',14400,'HybridFcn',{@fminsearch,fminsearchOptions});
% x =[4.0000,1.3086,0.9363,0.4644]; 
% @options=gaoptimset('InitialPopulation',x_start,'TimeLimit',14400,'HybridFcn',{@fminsearch,fminsearchOptions});
% x =[4.0000,1.2895,0.9238,0.4644]; %ConstraintFunction=@aspectratio_constraint;  
% @options=gaoptimset('InitialPopulation',x_start,'TimeLimit',14400,'HybridFcn',{@fmincon,fminconOptions});
% x =[2.0000,1.1161,1.0711,-0.1865];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x=[4.0000,0.5000,1.3364,0.5000];  % 不合理
% x=[4.0000,1.4283,0.9992,0.5000];  % L =-2.6131;  % 不合理
% x =[4,2,0.8188,0.5];                         % L = 1.0009;
x=[2.2899,1.0561,0.3788,0.0001];  % 20150204——结果不错哦
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F_verticalaver=trapz(t,F_vertical)/(3*T);
F_vertical_aver=Aero_F3_fruitfly_exp(x); %调用函数:x是变量variable=[R_wingeff,C_avereff,xr,C_maxy]; % F_verticalaver=12.3074uN; 
g=9.81;   % N*kg^-1
m_insect=1.8; 
M_insectweight=m_insect*g;                  % M_weight=10.3±1.27uN@1997-JEB-Fritz-Olaf lehmann
% L会改变,因为扭转轴的位置为改变转动虚质量力系数I6z的大小;
% 此外还会引起阻尼力矩系数(Z_rnd,M_xrdcoeff)和虚质量力矩系数(I_xzam,I_xxam)的变化;
L=2*F_vertical_aver/M_insectweight      % 无量纲: L =1.3940; 
delta=L-1  % delta =-1.0332e-004;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 构建惩罚函数——penaltyfun1
r=2000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (L-1)<2.9*10^(-15)&&(L-1)>0
    penaltyfun1=0;
% elseif L<0 
%     penaltyfun1=r*abs((L-1));
elseif (L-1)>=2.9*10^(-15)||(L-1)<=0
    penaltyfun1=r*abs((L-1));
else
    disp('垂直方向力有错');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 该方案不可行的哦
% if ((L-1)>(2.9*10^(-15)) || (L-1)<0)
%     penaltyfun1=r*(L-1);    % penaltyfun1 =-1.6561e+004; 
% else
%    penaltyfun1=0;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% penaltyfun1=r*heaviside(1-L);        % heaviside(x) has the value 0 for x < 0;         1 for x > 0;       and 0.5 for x = 0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第三部分——penaltyfun2——优化参数变量的上下界约束——惩罚函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x=[4.0000,0.5000,1.3364,0.5000];  % 不合理
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fcn_con=sum_constraint(x);
% 构建惩罚函数——penaltyfun2
s=2000;
penaltyfun2=s*fcn_con;  % penaltyfun2 =663.6000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 第四部分——penaltyfun3——展弦比约束或者Rossby数约束——惩罚函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x=[4.0000,0.5000,1.3364,0.5000];  % 不合理
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% penaltyfun3=aspectratio_constraint(x);
% obj_function=P_asterisk+penaltyfun1+penaltyfun2+penaltyfun3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
obj_function=P_asterisk+penaltyfun1+penaltyfun2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%