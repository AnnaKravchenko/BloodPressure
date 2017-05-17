%full model step-by-step

%all global variable and meaning
global N;               %   statistical value, row-size of input dataset 
global X1;              %   statistical value, top blood pressure from dataset
global X2;              %   statistical value, botton blood pressure from dataset
global U1;              %   statistical value, dose of medicine1 
global U2;              %   statistical value, dose of medicine2
global A;               %   calculate value, coefficient matrix A, pressure-associated 
global B;               %   calculate value, coefficient matrix B, dose-associated
global C;               %   calculate value, coefficient vector c, noise-associated
global X;               %   input value, vector current of blood pressure
global U;               %   u, that we finde by minimizatiomn (step2)
global Y_pred;          %   y, that we finde by calculate use U
global Y_ref;           %   опорная у, Y(X_ref,U_ref)
global X_ref;           %   опроная Х



data = xlsread('data.xlsx', 'Data');
[N, ~] = size(data);
    X1 = data(:,1);
    X2 = data(:,2);
    U1 = data(:,3);
    U2 = data(:,4); 
    
%STEP#1 First minimization: find A, B, c
x0Min1 = zeros(1,10);
AMin1 = [0, 0, 0, 0, 1, 0, 0, 0, 0, 0;...
         0, 0, 0, 0, 0, 1, 0, 0, 0 ,0;...
         0, 0, 0, 0, 0, 0, 1, 0, 0, 0;...
         0, 0, 0, 0, 0, 0, 0, 1, 0, 0];
bMin1 = zeros(1,4);

[abc, ~] = fmincon(@fun1,x0Min1,AMin1,bMin1);
  A = [abc(1), abc(2), abc(3), abc(4)];
  B = [abc(5), abc(6), abc(7), abc(8)];
  C = [abc(9), abc(10)];
 
X(1) = input('Текущее верхнее давление: ');
X(2) = input('Текущее нижнее давление: ');


%STEP#2 Second minimization: find u1, u2
 u0Min2 = [0 0 0 0];
 AMin2 = [-1, 0, 0, 0;...
           0,-1, 0, 0;...
           1, 0, 0, 0;...
           0, 1, 0, 0
           0, 0, 1, 0;...
           0, 0, 0, 1;...
           0, 0, -1, 0;...
           0, 0, 0, -1];
 bMin2 = [0, 0, 20, 20, 140, 90, -120, -80];
 
[u, ~] = fmincon(@fun2, u0Min2, AMin2, bMin2);       %   recommended dose
disp ('Рекомендованная доза лекарств')
U = u(1,1:2); 
disp(U')
% Меняю А и В. Тепрь она настоящие матрицы, а не векторы.
% С - столбец
A = [A(1:2);A(3:4)];
B = [B(1:2);B(3:4)];
C = C';
disp ('Предполагаемое давление завтра')
Y_pred = A*X' + B*U' + C   %   predictable blood pressure 

%STEP#3 Find reference point
[Y_ref, X_ref, uRef, ~] = fun3; % точка рефераенса, найденная по мотивам статистики


%STEP#4 Last minimization: Resistance to disturbances, find y*, u* 

uBond = U' - uRef;
u0Min4 = uBond;
aMin4 = [-1, 0;...
          0,-1;...
          1, 0;
          0, 1];
bMin4 = [0,0,uBond(1),uBond(2)];

[uRes, ~] = fmincon(@fun4,u0Min4,aMin4,bMin4);
disp ('Рекомендованная доза лекарств в отклонениях')
disp (uRes)
disp ('Предполагаемое давление завтра в отклонениях')
 xRes = X' - X_ref;
 yRes = A*xRes + B*uRes + C










