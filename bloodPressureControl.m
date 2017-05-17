function bloodPressureControl
%   variable initialization
global README;
README = 'readme.pdf';
%   open main window
H = open('main.fig');
%   pointers to objects of the main window write in the structure handles
handles = guihandles(H);
%   initialize the data structure of the main window
 par.dataPath = 'path.dat';           
 par.edt_u1Res = 0;
 par.edt_u2Res = 0;
 par.edt_y1Res = 0;
 par.edt_y2Res = 0;
set(handles.chx1,'Value',1)
%   save structure 
guidata(handles.win_main,par)
%   connect window buttons with callback functions
set(handles.btn_calc,'Callback',{@btn_calc_Callback,handles})
set(handles.btn_opt,'Callback',{@btn_opt_Callback,handles})
set(handles.btn_hlp,'Callback',{@btn_hlp_Callback,handles})
set(handles.btn_quit,'Callback',{@btn_quit_Callback,handles})

%   callback function for button "Выход" on the main window
function btn_quit_Callback(~,~,handles)
%   variable initialization
global X1; 
%   get information about main window 
par=guidata(handles.win_main);
%   if marked "Добавть мои данные в статистику"
if  isequal(get(handles.chx1,'Value'),1)
    %   transform values (pessure and dose) in string
    x1 = str2num(get(handles.edt1,'String'));
    x2 = str2num(get(handles.edt2,'String'));
    u1 = str2num(get(handles.ans1,'String'));
    u2 = str2num(get(handles.ans2,'String'));
    %   validation
    if isempty(x1)||isempty(x2)||isempty(u1)||isempty(u2)
        warndlg('Остались незаполненные поля','Ошибка записи в файл')
    elseif x1<=70 || x1>=240 || x2<=40 || x2>=140
        warndlg('Недопустимые значения давления','Ошибка записи в файл')
    elseif u1<0||u2<0||u1>20||u2>20
         warndlg('Недопустимые значения дозы','Ошибка записи в файл')
    else
    %   create a structure for writing to a file    
	dataset = {x1, x2, u1, u2};
    %   open file (where is the path&name of the file for data recording) 
    fid = fopen(par.dataPath, 'rb'); 
    %   if file cannot be opened
        if fid == -1 
        	errordlg('Файл не найден','Ошибка'); 
        end 
        %   variable initialization
        B='';                             
        cnt=1; 
        %   character read
        while ~feof(fid) 
        	[V,N] = fread(fid, 1, 'int16=>char');  
            if N > 0 
            	B(cnt)=V; 
            	cnt=cnt+1; 
            end 
        end
    fclose(fid);
    path = B;
    %   creation the cell name to record
    xlRange1 = 'A';
    [row,~] = size(X1);
    xlRange2 = num2str(row+1);
    xlRange = [xlRange1 '' xlRange2];
    %   write to file
    xlswrite(path, dataset,'', xlRange)
    %   close main window
    delete(handles.win_main)
    end
else
    %   do not save values to the file, just close the window
    delete(handles.win_main)
end

%   callback function for button "Помощь" on the main window
function btn_hlp_Callback(~,~,~)
%   open window
h = open('help.fig');
%   pointers to objects of the window "Помощь" write in the structure 
%   handles_hlp
handles_hlp = guihandles(h);
%   connect window buttons with callback functions
set(handles_hlp.btn_hlpPDF,'Callback',{@btn_hlpPDF_Callback,handles_hlp})

%   callback function for button "Открыть полную инструкцию" on the window
%   help
function btn_hlpPDF_Callback(~,~,h)
%   variable initialization (global value should be initialized in each
%   function)
global README;
%   open pdf file
open(README)
%   close window
delete(h.win_hlp)

%   callback function for button "Опции" on the main window
function btn_opt_Callback(~,~,handles)
%   open window
h = open('option.fig');
%   pointers to objects of the window "Опции" write in the structure 
%   handles_оpt
handles_opt = guihandles(h);
par = guidata(handles.win_main);
%   open file (where is the path&name of the file for data recording)
fid = fopen(par.dataPath, 'rb'); 
	if fid == -1 
    	errordlg('Файл не найден','Ошибка'); 
	end 
	B='';                             
	cnt=1; 
    %   read from file (where is the path&name of the file for data
    %   recording)
	while ~feof(fid) 
        [V,N] = fread(fid, 1, 'int16=>char');  
        if N > 0 
            B(cnt)=V; 
            cnt=cnt+1; 
        end 
	end
fclose(fid);
%   save the name of the file (file with data)
set(handles_opt.edt_opt,'String',B)
%   connect window buttons to callback functions
set(handles_opt.btn_optDef,'Callback',{@btn_optDef_Callback,handles,handles_opt})
set(handles_opt.btn_optOk,'Callback',{@btn_optOk_Callback,handles,handles_opt})
set(handles_opt.btn_optCancel,'Callback',{@btn_optCancel_Callback,handles_opt})

%   callback function for button "Отмена" on the window Опции
function btn_optCancel_Callback(~,~,handles_opt)
%   close window
delete(handles_opt.win_opt)

%   callback function for button "Принять" on the window Опции
function btn_optOk_Callback(~,~,handles,handles_opt)
%   get string from edit form 
path = get(handles_opt.edt_opt,'String');
%   validation
try
    %   load from xslx file
    [data,~,~] = xlsread(path);
    [col, row] = size(data);
    if col < 50
        warndlg('Размер выборки меньше 50 элементов','Ошибка');
    elseif row ~= 4
        warndlg('Структура выборки не соответствует требованиям','Ошибка');
    else
        par = guidata(handles.win_main); 
        %   open file (where is the path&name of the file for data
        %   recording)
        fid = fopen( par.dataPath, 'wb'); 
        if fid == -1 
            errordlg('Файл не найден','Ошибка'); 
        end
        %   write to file (where is the path&name of the file for data
        %   recording)
        fwrite(fid, path, 'int16');        
        fclose(fid); 
        %   save changed to structures
        guidata(handles.win_main,par)
        guidata(handles_opt.win_opt,par)
        %   close window    
        delete(handles_opt.win_opt)
    end
catch
    errordlg('Указаный файл не найден','Ошибка');
end

%   callback function for button "Оп умолчанию" on the window Опции
function btn_optDef_Callback(~,~,handles, handles_opt)
%   get structure par of the main window
par=guidata(handles.win_main);
%   default value
defoltDataPath = 'data.xlsx'; 
%   set the default value
set(handles_opt.edt_opt,'String',defoltDataPath)
%   close window
guidata(handles_opt.win_opt,par)

%   callback function for button "Рассчитать" on the main window 
function btn_calc_Callback(~,~,handles)
%   global variable initialization
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
%   get input pressure value as string from handles
x1Str = get(handles.edt1, 'String');
x2Str = get(handles.edt2, 'String');
%   transform string to the numbers
x1 = str2num(x1Str);
x2 = str2num(x2Str);
%   validation
if isempty(x1) || isempty(x2)
	warndlg('Остались незаполненные поля (на панели "Ваше давление")','Ошибка ввода');
elseif x1<=70 || x1>=240 || x2<=40 || x2>=140
	warndlg('Введенный уровень давления соответствует критическому состоянию!','Ошибка ввода');
else
    %   save to global variables
	X(1) = x1;
	X(2) = x2;
    %   get structure par of the main window
	par = guidata(handles.win_main);
    %   open file
    fid = fopen(par.dataPath, 'rb'); 
	if fid == -1 
    	errordlg('Файл не найден','Ошибка'); 
	end 
    Str='';
    cnt=1; 
	while ~feof(fid) 
        %   read char by char
    	[V,Num] = fread(fid, 1, 'int16=>char');   
        if Num > 0 
        	Str(cnt)=V; 
        	cnt=cnt+1; 
        end 
	end 
    fclose(fid);
    % cleate waitBar
    wb = waitbar(0,'Рассчет показателей...');
    set(wb,'Name','Пожалуйста, подождите');
    i = 1; 
    %   read data from xlsx file
	[data,~,~] = xlsread(Str);
    [N, ~] = size(data);
                                                                            waitbar(i/15); i=i+1; % this mean, that the loading band is shifted by 1/15 of the length     
    %   matrix-to-vector separation
    %   systolic pressure
    X1 = data(:,1);
                                                                            waitbar(i/15); i=i+1;
    %  diastolic pressure
    X2 = data(:,2);
                                                                            waitbar(i/15); i=i+1;
    %   dose of the first drug
    U1 = data(:,3);
                                                                            waitbar(i/15); i=i+1;
	%   dose of the second drug
    U2 = data(:,4);          
                                                                            waitbar(i/15); i=i+1;
%STEP#1 First minimization: find matrix A, matrix B, vector c
x0Min1 = zeros(1,10); % start point
AMin1 = [0, 0, 0, 0, 1, 0, 0, 0, 0, 0;...
         0, 0, 0, 0, 0, 1, 0, 0, 0 ,0;...
         0, 0, 0, 0, 0, 0, 1, 0, 0, 0;...
         0, 0, 0, 0, 0, 0, 0, 1, 0, 0]; %   constraint coefficients
bMin1 = zeros(1,4); %   constraint values
%   minimization
[abc, ~] = fmincon(@fun1,x0Min1,AMin1,bMin1);
%   save all as vectors
  A = [abc(1), abc(2), abc(3), abc(4)];
  B = [abc(5), abc(6), abc(7), abc(8)];
  C = [abc(9), abc(10)];
                                                                            waitbar(i/15); i=i+1;
%STEP#2 Second minimization: find doses u1, u2
 u0Min2 = [0 0 0 0]; % start point
 AMin2 = [-1, 0, 0, 0;...
           0,-1, 0, 0;...
           1, 0, 0, 0;...
           0, 1, 0, 0;...
           0, 0, 1, 0;...
           0, 0, 0, 1;...
           0, 0, -1, 0;...
           0, 0, 0, -1]; %   constraint coefficients
 bMin2 = [0, 0, 20, 20, 140, 90, -120, -80]; %   constraint values
 %  minimization                                                                          
 [u, ~] = fmincon(@fun2, u0Min2, AMin2, bMin2);     
 %  save doses to global variables                                                      waitbar(i/15); i=i+1;
 U(1,1) = round2(u(1));
 U(1,2) = round2(u(2));
 %  set values ??to the corresponding tags in the main window
 set(handles.ans1,'String',roundn(U(1),-1))
 set(handles.ans2,'String',roundn(U(2),-1))
                                                                            waitbar(i/15); i=i+1;
%   I change A and B. Now it is a real matrix, not vectors
%   С - column
A = [A(1:2);A(3:4)];
B = [B(1:2);B(3:4)];
C = C';
%   find pressure for tomorrow
Y_pred = A*X' + B*U' + C;   
                                                                            waitbar(i/15); i=i+1;
%  set values ??to the corresponding tags in the main window
set(handles.ans3,'String',roundn(Y_pred(1),-1))
set(handles.ans4,'String',roundn(Y_pred(2),-1))
                                                                            waitbar(i/15);i=i+1;
%STEP#3 Find reference point
[Y_ref, X_ref, uRef, ~] = fun3; 
                                                                            waitbar(i/15); i=i+1;
%STEP#4 Last minimization: Resistance to disturbances, find y*, u* 
uBond = U' - uRef;  % start point
u0Min4 = uBond;
aMin4 = [-1, 0;...
          0,-1;...
          1, 0;
          0, 1]; %   constraint coefficients
bMin4 = [0,0,uBond(1),uBond(2)];%   constraint values
                                                                            waitbar(i/15); i=i+1;
%   minimization
[uRes, ~] = fmincon(@fun4,u0Min4,aMin4,bMin4);
%  round values ??to 0-5-10-15-20
uRes(2) = round2(uRes(2));
uRes(1) = round2(uRes(1));
                                                                            waitbar(i/15); i=i+1;
%   find current pressure value in deviations
xRes = X' - X_ref;
%   calculate tomorrow pressure in deviations
yRes = A*xRes + B*uRes + C;                
                                                                            waitbar(i/15); 
%  set values ??to the corresponding tags in the main window
set(handles.edt_u1Res,'String',roundn(uRes(1),-1))
set(handles.edt_u2Res,'String',roundn(uRes(2),-1))
set(handles.edt_y1Res,'String',roundn(yRes(1),-1))
set(handles.edt_y2Res,'String',roundn(yRes(2),-1))
%   close waitBar
delete(wb);
end