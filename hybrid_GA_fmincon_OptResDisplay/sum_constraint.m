% 建立约束之外的惩罚函数
function y=sum_constraint(x)
% variable=[R_wingeff,C_avereff,xr,C_maxy];     % 变量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 变量的约束边界——下面的排序依次是R_wingeff, C_avereff, xr和x_0(扭转到前缘最大值点的距离)
% nvars = 4;         % Number of variables 
% R_wingeff∈[2,4]*10^(-3);
% C_avereff∈[0.5,2]*10^(-3);
% xr∈[0,2]*10^(-3);
%%%%%%%%%%%%%%%%%%%%%%%%%
% x_0∈[0,0.5];  % 距前缘的无量纲距离
% C_maxylb =0.464385778290230;    % C_maxylb =0.4644;
% C_maxy25 =0.138924474377504;   % C_maxy25 =0.1389; 
% C_maxyub =-0.186536829535222; % C_maxyub =-0.1865
%%%%%%%%%%%%%%%%%%%%%%%%%
% variable=[R_wingeff,C_avereff,xr,C_maxy];     % 变量
LB = [2, 0.5, 0, 0];      % Lower bound       % 单位: mm & 扭转轴距前缘的无量纲距离[0,0.5]
UB = [4, 2, 2, 0.5];      % Upper bound      % 单位: mm & 扭转轴距前缘的无量纲距离[0,0.5]
% X_AspR=[R_wingeff,C_avereff,xr];                   % AR=(R_wingeff+xr)/C_avereff; % AR∈[2,8]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=length(x);
con_min=LB;
con_max=UB;
zeta=zeros(N,1);
% y=zeros(N,1);
for i=1:N
    if x(i) < con_min(i)
        zeta(i)=abs(con_min(i)-x(i))/(con_max(i)-con_min(i));
    elseif x(i) > con_max(i)  % x=[4.0000,0.5000,1.3364,0.5000];  penaltyfun2=663.6000=2000*sum(zeta);则y=sum(zeta)=0.3318;
        zeta(i)=abs(x(i)-con_max(i))/(con_max(i)-con_min(i));
    else % x(i)>=con_min(i) && x(i)<=con_max(i);  % 无需这句表达式
        zeta(i)=0;  % disp('变量未超出边界约束');  
    end
end
 y=sum(zeta);
end