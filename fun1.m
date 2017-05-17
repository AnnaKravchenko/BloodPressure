%   Creation of the objective function in expanded form for the first minimization (to find
%   A, B, c)
function answer1 = fun1(vector)
%   global variable initialization
global N;               %   statistical value, row-size of input dataset 
global X1;              %   statistical value, top blood pressure from dataset
global X2;              %   statistical value, botton blood pressure from dataset
global U1;              %   statistical value, dose of medicine1 
global U2;              %   statistical value, dose of medicine2

f = 0;
    for k = 1:1:(N-1)
        %   This is what we have after parentheses are expanded in the
        %   matrix form of the record ||Y - A*x + B*u - c||^2
            fIteration = ...
            (X1(k+1) - vector(1)*X1(k) - vector(2)*X2(k) + vector(5)*U1(k) + vector(6)*U2(k) - vector(9))^2 +...
            (X2(k+1) - vector(3)*X1(k) - vector(4)*X2(k) + vector(7)*U1(k) + vector(8)*U2(k) - vector(10))^2; 
            f = f + fIteration;  
    end
answer1 = f/(N-1);
end