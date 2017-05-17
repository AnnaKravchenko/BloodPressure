%   Find reserens point
function [yRef, xRef, uRef, index] = fun3(~)
%   global variable initialization
global N;               %   statistical value, row-size of input dataset
global X1;              %   statistical value, top blood pressure from dataset
global X2;              %   statistical value, botton blood pressure from dataset
global U1;              %   statistical value, dose of medicine1 
global U2;              %   statistical value, dose of medicine2
global A;               %   calculate value, coefficient matrix A, pressure-associated 
global B;               %   calculate value, coefficient matrix B, dose-associated
global C;               %   calculate value, coefficient vector c, noise-associated

val = zeros(1,(N-1));   %   initiation array
%form an array in extended form
 for k = 1:1:(N-1)
     val(1,k) = sqrt((X1(k+1)-A(1)*X1(k)-A(2)*X2(k)+B(1)*U1(k)+B(2)*U2(k)-C(1))^2 + ...
                (X2(k+1)-A(3)*X1(k)-A(3)*X2(k)+B(3)*U1(k)+B(4)*U2(k)-C(2))^2);
 end
 [~, index] = min(val); %   find min in array, save just index
%find current elements
 xRef = [X1(index); X2(index)]; 
 uRef = [U1(index); U2(index)];
 yRef = A*xRef + B*uRef + C;
end