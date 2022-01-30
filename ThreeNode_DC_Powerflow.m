clear;clc;close all;
%三节点直流潮流
S_B = 100;
Load = 100/S_B;
X_Line = [0.2;0.25;0.4];
P_Line = [50;100;100]/S_B;
Line = [1 2;2 3;1 3];
Pg_Node = [1;3];
b = [10;11];
Pmin = [0;0]/S_B;
Pmax = [65;100]/S_B;
%决策变量
Pg = sdpvar(2,1);
PL = sdpvar(3,1);
d = sdpvar(3,1);
%目标函数
z = 0;
for i=1:2
    z = z +b(i)*Pg(i);
end
%添加约束
C = [];
C = [C;Pg>=Pmin];  %上下限
C = [C;Pg<=Pmax];
C = [C;PL>=-P_Line];  %上下限
C = [C;PL<=P_Line];
C = [C;d<=pi]; %平衡节点功角参考
C = [C;d>=-pi]; %平衡节点功角参考
C = [C;d(3)==0]; %平衡节点功角参考
for i=1:3
    C = [C;PL(i)-(d(Line(i,1))-d(Line(i,2)))/X_Line(i)==0]; %线路潮流
end
%功率平衡首先指的是各节点的平衡，刚开始的时候，直接无视线路或者都减PL是不行的，
%所以的话，应该根据首末节点，也就是功率的正方向，首节点正，末节点负，分节点列
%最终各节点相加，可以把线路潮流PL消掉，剩下的就是发电机与负荷功率平衡
C = [C;Pg(1)-PL(1)-PL(3)==0]; %功率平衡
C = [C;-Load+PL(1)-PL(2)==0]; %功率平衡
C = [C;Pg(2)+PL(2)+PL(3)==0]; %功率平衡
ops=sdpsettings('verbose',0);
%求解
result = optimize(C,z,ops);
if result.problem == 0    %求解成功
    Pg_star=double(Pg)
    PL_star=double(PL)
    Delta_star=double(d)
    z_star=double(z)
    else
    disp('求解过程中出错');
end