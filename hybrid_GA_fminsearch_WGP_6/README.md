# 说明注释区别

## hybrid_GA_fminsearch_WingM4_4_2不同于hybrid_GA_fminsearch_WingM4_4_1

0.hybrid_GA_fminsearch_WingM4_4_2由hybrid_GA_fminsearch_WingM4_4_1进化修改而来;

1.该文件夹下为11变量GA混合优化之程序—fmincon—搜索算法;

2.含翅膀形貌学和运动学参数(人为设计谐波运动学规律)共计11个变量;

3.功率调用函数和气动力调用函数一起调用同一个函数Aero_F_M_fruitfly——程序较简洁;

4.变量约束区间改小——注意数据的上下限修改——直指频率约束f∈[150,260];

5.kenimatics_wing_and_AoA_fruitfly_sim输出(1000*9)矩阵;

6.采用了WingM5_4_10variable_group原程序段来修改.

# force_Stick_figure for optimal calculated results 

## Stick_figure_force_downstroke for pitch axis located at 0.25*C_avereff
![force_Stick_figure](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_6/force_Stick_figure/pic_bmp_eps_tif_png/Stick_figure_force_downstroke_%E5%B9%B3%E5%9D%87%E5%BC%A6%E9%95%BF_%E6%89%AD%E8%BD%AC%E8%BD%B4025C_avereff.png)

## Stick_figure_force_upstroke for pitch axis located at 0.25*C_avereff
![force_Stick_figure](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_6/force_Stick_figure/pic_bmp_eps_tif_png/Stick_figure_force_upstroke_%E5%B9%B3%E5%9D%87%E5%BC%A6%E9%95%BF_%E6%89%AD%E8%BD%AC%E8%BD%B4025C_avereff.png)

# Aerodynamic forces and power for optimal wing shape parameters

## Aerodynamic forces for optimal wing shape parameters

![Aerodynamic forces](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_6/forces_power_for_optimal_wing_shape_parameters/forces_power_1/Forces.png)

## Power for optimal wing shape parameters

![Power](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_6/forces_power_for_optimal_wing_shape_parameters/forces_power_1/Power.png)