function F_shape_con=F_shape_constraint(lambda)
% ������������ϵ��Լ��֮��ĳͷ�����
x=lambda;
LB=[0,0];  
UB=[10,10];  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=length(x);
con_min=LB;
con_max=UB;
zeta=zeros(N,1);
% y=zeros(N,1);
parfor i=1:N
    if x(i) < con_min(i)
        zeta(i)=abs(con_min(i)-x(i))/(con_max(i)-con_min(i));
    elseif x(i) > con_max(i)  % 
        zeta(i)=abs(x(i)-con_max(i))/(con_max(i)-con_min(i));
    else % x(i)>=con_min(i) && x(i)<=con_max(i);  % ���������ʽ
        zeta(i)=0;  % disp('����δ�����߽�Լ��');  
    end
end
F_shape_con=sum(zeta);
end