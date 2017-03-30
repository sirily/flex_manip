function [L] = iSolver(X, a, b, d, f, h)
%Решение обратной задачи о положении
bxf = (b - X(1) - f/2)^2;
yd  = (X(2) - d/2)^2;
hz  = (h - X(3))^2;
xf  = (X(1) - f/2)^2;
ayd = (a - X(2) - d/2)^2;

L = [sqrt(bxf + yd + hz);
     sqrt(xf + yd + hz);
     sqrt(xf + ayd + hz);
     sqrt(bxf + ayd + hz)];
 