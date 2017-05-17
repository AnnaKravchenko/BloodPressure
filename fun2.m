%   Creation of the objective function in expanded form for the second minimization 
%   (to find doses)
function answer2 = fun2(u)
%   global variable initialization
global A;               %   calculate value, coefficient matrix A, pressure-associated 
global B;               %   calculate value, coefficient matrix B, dose-associated
global C;               %   calculate value, coefficient vector c, noise-associated
global X;               %   input value, vector current of blood pressure
% In matrix form ||Y - (A*x + B*U + c)||^2
answer2 = ...
    (u(3)-(A(1)*X(1)+A(2)*X(2)+B(1)*u(1)+B(2)*u(2)+C(1)))^2+...
    (u(4)-(A(3)*X(1)+A(4)*X(2)+B(3)*u(1)+B(4)*u(2)+C(2)))^2;
end