%% optimal_F_shape
tic
matlabpool open 4
% function obj_function=objfunction_aeroF_coeff(x)
ObjFunction=@objfunction_F_shape;  % fitness and constraint functions——调用目标函数objfunction_aeroF_coeff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambda0=[0.61,0.95];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% psoptimset——Create pattern search options structure
% % Complete poll around current iterate; 'off'
options=psoptimset('CompletePoll','on','CompleteSearch','on','Display','iter','UseParallel','always'); 
[x,fval,exitflag,output] = patternsearch(ObjFunction,lambda0,[],[],[],[],[],[],[],options)
matlabpool close
optimal_variablex=x;
object_value=fval;
save('result_x.txt', 'optimal_variablex', '-ASCII')
save('result_fval.txt', 'object_value', '-ASCII')
% output_1=[population,scores];
% xlswrite('D:\kxj\aero_force_torque_3dof_wingbeat\population_scores.xlsx',output_1,'sheet1','A1:K100');
elapsedTime =toc/60;  
disp(['Caculation finished and the elapsedTime= ' num2str(elapsedTime ,'%5.4f') 'minutes'])