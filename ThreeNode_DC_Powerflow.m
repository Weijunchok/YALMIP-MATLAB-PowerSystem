clear;clc;close all;
%���ڵ�ֱ������
S_B = 100;
Load = 100/S_B;
X_Line = [0.2;0.25;0.4];
P_Line = [50;100;100]/S_B;
Line = [1 2;2 3;1 3];
Pg_Node = [1;3];
b = [10;11];
Pmin = [0;0]/S_B;
Pmax = [65;100]/S_B;
%���߱���
Pg = sdpvar(2,1);
PL = sdpvar(3,1);
d = sdpvar(3,1);
%Ŀ�꺯��
z = 0;
for i=1:2
    z = z +b(i)*Pg(i);
end
%���Լ��
C = [];
C = [C;Pg>=Pmin];  %������
C = [C;Pg<=Pmax];
C = [C;PL>=-P_Line];  %������
C = [C;PL<=P_Line];
C = [C;d<=pi]; %ƽ��ڵ㹦�ǲο�
C = [C;d>=-pi]; %ƽ��ڵ㹦�ǲο�
C = [C;d(3)==0]; %ƽ��ڵ㹦�ǲο�
for i=1:3
    C = [C;PL(i)-(d(Line(i,1))-d(Line(i,2)))/X_Line(i)==0]; %��·����
end
%����ƽ������ָ���Ǹ��ڵ��ƽ�⣬�տ�ʼ��ʱ��ֱ��������·���߶���PL�ǲ��еģ�
%���ԵĻ���Ӧ�ø�����ĩ�ڵ㣬Ҳ���ǹ��ʵ��������׽ڵ�����ĩ�ڵ㸺���ֽڵ���
%���ո��ڵ���ӣ����԰���·����PL������ʣ�µľ��Ƿ�����븺�ɹ���ƽ��
C = [C;Pg(1)-PL(1)-PL(3)==0]; %����ƽ��
C = [C;-Load+PL(1)-PL(2)==0]; %����ƽ��
C = [C;Pg(2)+PL(2)+PL(3)==0]; %����ƽ��
ops=sdpsettings('verbose',0);
%���
result = optimize(C,z,ops);
if result.problem == 0    %���ɹ�
    Pg_star=double(Pg)
    PL_star=double(PL)
    Delta_star=double(d)
    z_star=double(z)
    else
    disp('�������г���');
end