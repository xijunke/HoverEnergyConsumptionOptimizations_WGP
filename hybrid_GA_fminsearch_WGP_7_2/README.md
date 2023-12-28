# 说明注释区别

由hybrid_GA_fminsearch_wings_morphology_6修改而来，20160106日之前该论文的一些气动力和力矩以及功率的计算程序有小错误

目前改程序已经修改，几近正确——此方案，不可行，并行计算出错，可能是函数调用过深

0.hybrid_GA_fminsearch_WingM4_4_2由hybrid_GA_fminsearch_WingM4_4_1进化修改而来
1.该文件夹下为11变量GA混合优化之程序—fmincon—搜索算法
2.含翅膀形貌学和运动学参数(人为设计谐波运动学规律)共计11个变量
3.功率调用函数和气动力调用函数一起调用同一个函数Aero_F_M_fruitfly——程序较简洁
4.变量约束区间改小——注意数据的上下限修改——直指频率约束f∈[150,260];
5.kenimatics_wing_and_AoA_fruitfly_sim输出(1000*9)矩阵

6.采用了hybrid_GA_fminsearch_wings_morphology_6原程序段来修改。



该方案无法实现改变翅膀前后缘的周长积分，因而无法实现并行优化计算