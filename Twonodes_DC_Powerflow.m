clear;clc;close all;
%两节点直流潮流
X12 = 0.2;
S_B = 100;
P12_Max = 150/S_B;
L2 = 400/S_B;
a = [3;4.05];
b = [20;18.07];
c = [100;98.87];
Pmin = [28;90]/S_B;
Pmax = [206;284]/S_B;
%决策变量
Pg = sdpvar(2,1);
P12 = sdpvar(1,1);
d = sdpvar(2,1);
%目标函数
z = 0;
for i=1:2
    z = z + a(i)*Pg(i)*Pg(i)+b(i)*Pg(i)+c(i);
end
%添加约束
C = [];
C = [C;Pg>=Pmin];  %上下限
C = [C;Pg<=Pmax];
C = [C;Pg(1)==P12]; %线路潮流
C = [C;(d(1)-d(2))/X12==P12]; %线路直流潮流是功角差/电抗
C = [C;P12<=P12_Max]; %线路潮流上限
C = [C;d(1)==0]; %平衡节点功角参考
C = [C;Pg(2)+P12==L2]; %负荷平衡
ops=sdpsettings('verbose',0);
%求解
result = optimize(C,z,ops);
if result.problem == 0    %求解成功
    Pg_star=double(Pg)
    P12_star=double(P12)
    Delta_star=double(d)
    z_star=double(z)
    else
    disp('求解过程中出错');
end