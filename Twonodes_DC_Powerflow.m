clear;clc;close all;
%���ڵ�ֱ������
X12 = 0.2;
S_B = 100;
P12_Max = 150/S_B;
L2 = 400/S_B;
a = [3;4.05];
b = [20;18.07];
c = [100;98.87];
Pmin = [28;90]/S_B;
Pmax = [206;284]/S_B;
%���߱���
Pg = sdpvar(2,1);
P12 = sdpvar(1,1);
d = sdpvar(2,1);
%Ŀ�꺯��
z = 0;
for i=1:2
    z = z + a(i)*Pg(i)*Pg(i)+b(i)*Pg(i)+c(i);
end
%���Լ��
C = [];
C = [C;Pg>=Pmin];  %������
C = [C;Pg<=Pmax];
C = [C;Pg(1)==P12]; %��·����
C = [C;(d(1)-d(2))/X12==P12]; %��·ֱ�������ǹ��ǲ�/�翹
C = [C;P12<=P12_Max]; %��·��������
C = [C;d(1)==0]; %ƽ��ڵ㹦�ǲο�
C = [C;Pg(2)+P12==L2]; %����ƽ��
ops=sdpsettings('verbose',0);
%���
result = optimize(C,z,ops);
if result.problem == 0    %���ɹ�
    Pg_star=double(Pg)
    P12_star=double(P12)
    Delta_star=double(d)
    z_star=double(z)
    else
    disp('�������г���');
end