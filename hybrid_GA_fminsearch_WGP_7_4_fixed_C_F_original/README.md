# Here,the optimal post-processed resuts are ony for original wing morphology and kinematic_parameters��

Notes: Aerodynamic lift and drag coefficients (C_F) are fixed.

# ˵��ע������
��hybrid_GA_fminsearch_wings_morphology_6�޸Ķ�����20160106��֮ǰ�����ĵ�һЩ�������������Լ����ʵļ��������С����

Ŀǰ�ĳ����Ѿ��޸�,������ȷ

0.hybrid_GA_fminsearch_WingM4_4_2��hybrid_GA_fminsearch_WingM4_4_1�����޸Ķ���;

1.���ļ�����Ϊ11����GA����Ż�֮����fmincon�������㷨;

2.�������òѧ���˶�ѧ����(��Ϊ���г���˶�ѧ����)����11������;

3.���ʵ��ú��������������ú���һ�����ͬһ������Aero_F_M_fruitfly��������ϼ��;

4.����Լ�������С����ע�����ݵ��������޸ġ���ֱָƵ��Լ��f��[150,260];

5.kenimatics_wing_and_AoA_fruitfly_sim���(1000*9)����;

6.������hybrid_GA_fminsearch_wings_morphology_6ԭ��������޸�.

# force_Stick_figure for optimal calculated results 

## Stick_figure_force_downstroke for pitch axis located at 0.25*C_avereff
![force_Stick_figure](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_7_4_fixed_C_F_original/force_stick_figure/pic_eps_pdf_tif_png/Stick_figure_force_downstroke_%E5%B9%B3%E5%9D%87%E5%BC%A6%E9%95%BF_%E6%89%AD%E8%BD%AC%E8%BD%B4025C_avereff.png)

## Stick_figure_force_upstroke for pitch axis located at 0.25*C_avereff
![force_Stick_figure](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_7_4_fixed_C_F_original/force_stick_figure/pic_eps_pdf_tif_png/Stick_figure_force_upstroke_%E5%B9%B3%E5%9D%87%E5%BC%A6%E9%95%BF_%E6%89%AD%E8%BD%AC%E8%BD%B4025C_avereff.png)


# Optimiaztion calculated results are for fixed aerodynamic lift and drag coefficients (C_F) 

Notes: Aerodynamic lift and drag coefficients (C_F) do not vary with wing morphology parameters

## For the combined optimal wing shape parameters and kinematic parameters, aerodynamic force, inertial force, aerodynamic power, inertial power, wing pitch and flapping motion power, and total power output are listed here.

## Aerodynamic forces and inertia force
```
Aerodynamic force inbcludes normal force to wing plane, which are decomposed into aerodynamic lift and thrust again. And inertial force is also given out.
```

## Aerodynamic power and inertial power for pitch and flapping axis and total power output

# Figures for above mentioned aerodynamic force and power, inertial force and power, and wing pitch and flapping motion power, and total power output

## �Ĵ�Ǻ�Ťת����ʱ��ı仯����
![wing_kinematic_motion](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_7_4_fixed_C_F_original/force_power_results/pic_png/%E6%8B%8D%E6%89%93%E8%A7%92%E5%92%8C%E6%89%AD%E8%BD%AC%E8%A7%92%E9%9A%8F%E6%97%B6%E9%97%B4%E7%9A%84%E5%8F%98%E5%8C%96%E8%A7%84%E5%BE%8B.png)

## aerodynamic_forces_lift_and_thrust
![calculated results](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_7_4_fixed_C_F_original/force_power_results/pic_png/aerodynamic_forces_lift_and_thrust.png)

## aerodynamic_forces_lift_and_thrust_with_inertial_force
![calculated results](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_7_4_fixed_C_F_original/force_power_results/pic_png/aerodynamic_forces_lift_and_thrust_with_inertial_force.png)

## ����Ťת��x_{rw}-axis���������ʺ͹��Թ���
![calculated results](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_7_4_fixed_C_F_original/force_power_results/pic_png/%E6%B2%BF%E7%9D%80%E6%89%AD%E8%BD%AC%E8%BD%B4x_%7Brw%7D-axis%E7%9A%84%E6%B0%94%E5%8A%A8%E5%8A%9F%E7%8E%87%E5%92%8C%E6%83%AF%E6%80%A7%E5%8A%9F%E7%8E%87_2.png)

## �����Ĵ���z_{rr}-axis���������ʺ͹��Թ���
![calculated results](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_7_4_fixed_C_F_original/force_power_results/pic_png/%E6%B2%BF%E7%9D%80%E6%8B%8D%E6%89%93%E8%BD%B4z_%7Brr%7D-axis%E7%9A%84%E6%B0%94%E5%8A%A8%E5%8A%9F%E7%8E%87%E5%92%8C%E6%83%AF%E6%80%A7%E5%8A%9F%E7%8E%87_2.png)

## ����Ťת��x_{rw}-axis���Ĵ���z_{rr}-axis�Ĺ��Թ���
![calculated results](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_7_4_fixed_C_F_original/force_power_results/pic_png/%E6%B2%BF%E7%9D%80%E6%89%AD%E8%BD%AC%E8%BD%B4x_%7Brw%7D-axis%E5%92%8C%E6%8B%8D%E6%89%93%E8%BD%B4z_%7Brr%7D-axis%E7%9A%84%E6%83%AF%E6%80%A7%E5%8A%9F%E7%8E%87.png)

## ������ų����ò�����ĳ�Ťת����_�Ĵ��ʺ��ܹ������
![calculated results](https://github.com/xijunke/HoverEnergyConsumptionOptimizations_WGP/blob/main/hybrid_GA_fminsearch_WGP_7_4_fixed_C_F_original/force_power_results/pic_png/%E9%92%88%E5%AF%B9%E6%9C%80%E4%BC%98%E7%BF%85%E8%86%80%E5%BD%A2%E8%B2%8C%E5%8F%82%E6%95%B0%E7%9A%84%E7%BF%85%E6%89%AD%E8%BD%AC%E5%8A%9F%E7%8E%87_%E6%8B%8D%E6%89%93%E5%8A%9F%E7%8E%87%E5%92%8C%E6%80%BB%E5%8A%9F%E7%8E%87%E8%BE%93%E5%87%BA.png)

