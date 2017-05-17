%   Creation of the objective function in matrix form for the last minimization 
%   (to find doses in deviations)
function answer4 = fun4(u)
%   global variable initialization
global A;               %   calculate value, coefficient matrix A, pressure-associated 
global B;               %   calculate value, coefficient matrix B, dose-associated
global X;               %   input value, vector current of blood pressure
global Y_pred;          %   y, that we finde by calculate use U
global Y_ref;           %   опорная у, Y(X_ref,U_ref)
global X_ref;           %   опроная Х
    
 yStep4 = Y_pred - Y_ref;
 xRes = X' - X_ref;
 % in matrix form
 answer4 =  norm(yStep4 - (A*xRes + B*u));
end
