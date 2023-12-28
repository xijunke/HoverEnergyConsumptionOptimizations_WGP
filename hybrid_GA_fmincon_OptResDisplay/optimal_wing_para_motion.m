% optimal_wing_para_motion
%% 第一部分——变量的约束边界
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (1) 翅膀长度和展弦比——R_wingeff,C_avereff和AR
% R_wingeff=3.004;      % 有效翅膀长度(mm)  
% C_avereff=0.8854;     % mm
% (2) 可以考虑已知展弦比, 求解气动力最优的翅形貌
% AR=R_wingeff/C_avereff;     %aspect ratio: AR=R^2/A_w;  这里输出为: AR=3.40158;  % Science数据是: AR=3.1519;
% C_avereff=R_wingeff/AR;     %mean chord length: C_aver=A_w/R=R^2/AR/R=R/AR; % C_aver=0.884mm;
% A_w=R_wingeff^2/AR;        %Area of wing: 这里输出为: A_w=2.66mm^2;   %RJ Wood设计的翅膀: A_w=2.84345 mm^2 
% (3) 翅根部偏离距离——xr
% xr=0.3289;                     % x-root offset  \mm
% xr_nd=xr/R_wingeff;      % x-root offset  无量纲展向偏置距离
% (4) 扭转轴的位置——C_maxy
% C_max_LtoT=C_lead_ymax-C_trail_ymin;       % C_max_LtoT =1.3018;
% x_0lb=0*C_max_LtoT;                                    % x_0lb=0;
% x_025=0.25*C_max_LtoT;                              % x_025=0.3255;
% x_0ub=0.5*C_max_LtoT;                                % x_0ub=0.6509;
% C_lead_ymax=max(f_x_lead2); % 输出: C_lead_ymax=0.4644; k_leadmax=644;%原始果蝇翅膀@最大前缘点到翅根翅尖连线的距离;@C_maxy=0;
% % C_maxylb =0.464385778290230;
% C_maxy25 =0.138924474377504;  % 针对程序wing_model_88_yaxis有: 第122行; C_maxy =0.1389; 
% C_maxyub =-0.186536829535222; 
% C_maxy=C_maxylb;
% C_maxy=C_maxy25;
% C_maxy=C_maxyub;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variable=[R_wingeff,C_avereff,xr,C_maxy];        % 变量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (5) 变量的约束边界——下面的排序依次是R_wingeff, C_avereff, xr和x_0(扭转到前缘最大值点的距离)
% nvars = 4;         % Number of variables 
% R_wingeff∈[2,4]*10^(-3);
% C_avereff∈[0.5,2]*10^(-3);
% xr∈[0,2]*10^(-3);
%%%%%%%%%%%%%%%%%%%%%%%%%
% x_0∈[0,0.5];  % 扭转轴距前缘的无量纲距离——% 原始果蝇翅膀 R_wing=3.004;  C_aver=0.8854; 
% C_maxylb =0.464385778290230;                   % C_maxylb=0.4644;
% C_maxy25 =0.138924474377504;                  % C_maxy25=0.1389; 
% C_maxyub =-0.186536829535222;                % C_maxyub=-0.1865
%%%%%%%%%%%%%%%%%%%%%%%%%
% variable=[R_wingeff,C_avereff,xr,C_maxy];     % 变量
% LB = [2, 0.5, 0, 0];      % Lower bound            % 单位: mm & 扭转轴距前缘的无量纲距离[0,0.5]
% UB = [4, 2, 2, 0.5];     % Upper bound            % 单位: mm & 扭转轴距前缘的无量纲距离[0,0.5]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第二部分——目标函数
tic
ObjectiveFunction=@morphology_para_opt_obj_function;  % fitness and constraint functions——调用目标函数
nvars=4;   % Number of variables 
LB = [2, 0.5, 0, 0];      % Lower bound       % 单位: mm & 扭转轴距前缘的无量纲距离[0,0.5]
UB = [4, 2, 2, 0.5];      % Upper bound      % 单位: mm & 扭转轴距前缘的无量纲距离[0,0.5]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 第三部分——展弦比对变量的线性约束
% X_AspR=[R_wingeff,C_avereff,xr];               % AR=(R_wingeff+xr)/C_avereff; % AR∈[1,5]
ConstraintFunction=@aspectratio_constraint;  % nonlinear inequality constraints——调用非线性不等式约束——XXX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 第四部分——混合遗传算法(Hybrid Function)-GA+fminsearch
% 原始果蝇翅膀 R_wing=3.004;  C_aver=0.8854;   
% C_lead_ymax =0.4644;  C_trail_ymin =-0.8374;  C_max_LtoT = 1.3018; @C_maxy=0;
% Ratio_leadmax=C_lead_ymax/C_max_LtoT; %Ratio_leadmax=0.4644/1.3018=0.356737; %针对翅根和翅尖连线的扭转轴定出的前缘
% x_start=[3.004,0.8854,0.3289,0.356737]; % 初始值. % 未优化的果蝇翅膀形貌参数——翅根和翅尖连线的扭转轴定出的前缘
% C_lead_ymax =0.3255;  C_trail_ymin =-0.9764;  C_max_LtoT =1.3018;
% Ratio_leadmax=C_lead_ymax/C_max_LtoT; %Ratio_leadmax=0.3255/1.3018=0.25;%针对扭转轴位于最大前缘点和最新后缘点坐标间距0.25倍时
x_start=[3.004,0.8854,0.3289,0.25];     % 初始值. % 未优化的果蝇翅膀形貌参数——扭转轴位于最大前缘点和最新后缘点坐标间距0.25倍时
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (1) 纯粹遗传算法最小化优化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% options = gaoptimset('InitialPopulation',x_start);  % (1)——可行——第四次计算(1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% options = gaoptimset('PlotFcns',{@gaplotbestf,@gaplotmaxconstr},'Display','iter');  % (2)——可行
% options = gaoptimset(options,'InitialPopulation',x_start,'TimeLimit',14400);  % (2)——可行——第四次计算(2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (2) 混合遗传算法(Hybrid Function)-GA+fminsearch
% % 自动由fminsearch跳转至fmincon搜索——可行——结果不好——第四次计算(3)
% options = gaoptimset('InitialPopulation',x_start,'TimeLimit',10800,'PlotFcns',{@gaplotbestf,@gaplotmaxconstr});
% % fminsearchOptions = optimset('algorithm','Nelder-Mead simplex direct search');
% % options=gaoptimset(options,'HybridFcn',{@fminsearch,x_start, fminsearchOptions}); 
% fminsearchOptions=optimset('Display','iter'); % fminsearch——无约束多变量函数最小化
% options=gaoptimset(options,'HybridFcn',{@fminsearch,fminsearchOptions}); % fminsearch——无约束多变量函数最小化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 采用fminsearch局部搜索——不可行
% options=gaoptimset('PopulationSize',200,'InitialPopulation',[],'TimeLimit',14400,'PlotFcns',{@gaplotbestf,@gaplotmaxconstr});
% fminsearchoptions = optimset('Display','iter','TolFun',1e-10);% fminsearch——无约束多变量函数最小化
% options =gaoptimset(options,'Hybridfcn',{@fminsearch,fminsearchoptions});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 采用fminunc局部搜索——不可行
% options = gaoptimset('InitialPopulation',x_start,'TimeLimit',14400,'PlotFcns', {@gaplotbestf,@gaplotstopping});
% fminuncOptions=optimset('Display','iter', 'LargeScale','off'); % fminunc——无约束多变量函数最小化
% options=gaoptimset(options,'HybridFcn',{@fminunc, fminuncOptions});  % fminunc——无约束多变量函数最小化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 采用fmincon局部搜索——可行——结果不好——第四次计算(4)
options = gaoptimset('InitialPopulation',x_start,'TimeLimit',10800,'PlotFcns',{@gaplotbestf,@gaplotmaxconstr});
fminconOptions=optimset('Display','iter','TolCon',1e-10); % fmincon——有约束非线性多变量最小化——算法不选择
% fminconOptions=optimset('Display','iter','Algorithm','active-set'); % fmincon——有约束非线性多变量最小化——算法选择
options=gaoptimset(options,'HybridFcn',{@fmincon,fminconOptions}); % fmincon——有约束非线性多变量最小化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Next we run the GA solver.
[x,fval]=ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB, ConstraintFunction,options)
% [x,fval]=ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB,[],options)
% [x,fval]=ga(ObjectiveFunction,nvars,[],[],[],[],[],[],[],options)
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%