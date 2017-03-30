function [X] = dSolver(L, a, b, d, f, h)
%Решение прямой задачи о положении

global L_;
global C_;
L_ = L;
C_ = [a, b, d, f, h];

x0 = [0 0 0 0 0 0];           % Make a starting guess at the solution
options=optimset('Display','off');   % Option to display output
[x, ff, outf] = fsolve(@myfun,x0,options);  % Call optimizer

if ~(outf == 1)
    L
    x
end;

switch outf,
    case 2, 
        error('Ошибка при решении прямой задачи по положению. Change in x was smaller than the specified tolerance.');
    case 3,
        error('Ошибка при решении прямой задачи по положению. Change in the residual was smaller than the specified tolerance.');
    case 4,
        error('Ошибка при решении прямой задачи по положению. Magnitude of search direction was smaller than the specified tolerance.');
    case 0,
        error('Ошибка при решении прямой задачи по положению. Number of iterations exceeded options.MaxIter or number of function evaluations exceeded options.FunEvals.');
    case -1,
        error('Ошибка при решении прямой задачи по положению. Algorithm was terminated by the output function.');
    case -2,
        error('Ошибка при решении прямой задачи по положению. Algorithm appears to be converging to a point that is not a root. ');
    case -3,
        error('Ошибка при решении прямой задачи по положению. Trust radius became too small.');
    case -4,
        error('Ошибка при решении прямой задачи по положению. Line search cannot sufficiently decrease the residual along the current search direction.');
end;

A = x;

d = 2;
f = 1.2;
h = 15;

X = [ L(2).*sin(A(2)).*sin(A(5)) + f/2;
      L(2).*sin(A(2)).*cos(A(5)) + d/2;
      h - L(2).*cos(A(2))];

% 1 - a1
% 2 - a2
% 3 - a3
% 4 - b1
% 5 - b2
% 6 - b3

function F = myfun(x)
global L_;
global C_;

a = C_(1);
b = C_(2);
d = C_(3);
f = C_(4);

%a = 50;
%b = 20;
%d = 2;
%f = 1.2;
L = L_;

F = [L(1).*sin(x(1)).*sin(x(4)) + L(2).*sin(x(2)).*sin(x(5)) - b + f;
     L(1).*sin(x(1)).*cos(x(4)) - L(2).*sin(x(2)).*cos(x(5));
     L(2).*sin(x(2)).*cos(x(5)) + L(3).*sin(x(3)).*cos(x(6)) - a + d;
     L(2).*sin(x(2)).*sin(x(5)) - L(3).*sin(x(3)).*sin(x(6));
     L(1).*cos(x(1)) - L(2).*cos(x(2));
     L(2).*cos(x(2)) - L(3).*cos(x(3))];

