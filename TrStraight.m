%function [D] = TrStraight
global vmax;
global a;
global tmax;
global phi1; 
global phi2;
global kx;
global ky;
%Выбор траектории движения
x0 = 7.5;
y0 = 7.5;
z0 = 1.035;
x1 = 0;
y1= 0;
z1 = 0;

p1 = x1-x0;
p2 = y1-y0;
p3 = z1-z0;
s = sqrt(p1^2+p2^2+p3^2); 
%нахождение закона скорости
midv = 10;

tmax = s/midv;

A = [-1      0.2*tmax;
    0.6*tmax (0.2*tmax)^2];
B = [0 s];
V = A^(-1)*B';
vmax = V(1);
a = V(2);

%t = 0:0.1:tmax;
syms t;
v = a.*t;%*(t<=0.2*tmax) + vmax*(t>0.2*tmax & t<=0.8*tmax) + (vmax - a*(t - 0.8*tmax))*(t>=0.8*tmax);
%разложение вектора скорости по координатам
phi1 = asin(p3/s);
phi2 = atan(p2/p1);
%коэффициенты знака
kx = (-1)*(p1<0) + 1*(p1>=0);
ky = (-1)*(p2<0) + 1*(p2>=0);
%проeкции скоростей
vx = v*cos(phi1)*cos(phi2)*kx;
vy = v*cos(phi1)*sin(abs(phi2))*ky;
vz = v*sin(phi1);
%законы движения по координатам
x = int(vx, t);
subs(x, t, t1);
%y = quad(@vely,0,tmax);
%z = quad(@velz,0,tmax);
%D = [x y z];
