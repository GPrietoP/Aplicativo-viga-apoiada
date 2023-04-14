% Esse programa abre uma interface que resolve o problema de uma
% biapoiada com uma carga concentrada em qualquer posição do vão,
% através do método dos elementos finitos
%
% Alunos:                          RA:
% Beatriz de Souza Silva           11024516
% Gabriel Prieto Paris             11052516 
% Haroldo de Oliveira Brito Filho  11110814 
% Ricardo Oliveira da Mata         11036313 
% Lucas Paradinovic Coelho         11201721086 
function varargout = Viga_Interface(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Viga_Interface_OpeningFcn, ...
                   'gui_OutputFcn',  @Viga_Interface_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before Viga_Interface is made visible.
function Viga_Interface_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Viga_Interface_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)

% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)

% --- Executes on mouse press over axes background.
function axes3_ButtonDownFcn(hObject, eventdata, handles)


function edit2_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
clc
b = eval(get(handles.edit2, 'string')); % [m] - Base da seção 
h = eval(get(handles.edit3, 'string')); % [m] - Altura da seção
E = eval(get(handles.edit4, 'string')); % [kPa] - Módulo de elasticidade
Lt = eval(get(handles.edit5, 'string')); % [m] - Comprimento total da viga
L1 = eval(get(handles.edit6, 'string')); % [m] - Posição da aplicação da força a partir do apoio da esquerda
f = [0; 0; 0]; % [kN] - forças externas aplicada nos graus de liberdade livres
f(2) = -eval(get(handles.edit7, 'string')); % [kN] - Carga concentrada para baixo
L2 = Lt - L1; % [m] - Comprimento do elemento 2 
I = b*h^(3)/12; % [m^4] - Momento de inércia 

%% Escrevendo a matriz de rigidez de cada elemento
k1 = FEM.BeamElementStiffness(E,I,L1);
k2 = FEM.BeamElementStiffness(E,I,L2);

%% Escrevendo a matriz de rigidez global
K = zeros(6,6);
K = FEM.BeamAssemble(K,k1,1,2);
K = FEM.BeamAssemble(K,k2,2,3);

%% Aplicando as condições de contorno
k = [K(2:3,2:3) K(2:3,6); K(6,2:3) K(6,6)]; % Aplicando a eliminação Gaussiana, os valores com posição (x,y) em nós restritos são eliminados

%% Resolvendo as equações
u = k\f; % [m] - Descolamentos livres
%% Pós processamento
fprintf('------------------------------------------------\n')
fprintf('# Todos os deslocamentos dos nós em m e rad \n')
U = [0; u(1); u(2); 0; 0; u(3)]
fprintf('# Todas as forças nos nós em kN \n')
F = K*U
fprintf('------------------------------------------------\n')
fprintf('------------------------------------------------\n')
fprintf('# Deslocamentos nos nós do elemento da esquerda em m e rad \n')
u1 = [U(1); U(2); U(3); U(4)] % Deslocamentos nos nós do elemento 1
fprintf('# Deslocamentos nos nós do elemento da direita em m e rad \n')
u2 = [U(3); U(4); U(5); U(6)] % Deslocamentos nos nós do elemento 2
fprintf('# Forças nos nós do elemento da esquerda em kN \n')
f1 = k1*u1 % Forças nos nós do elemento 1
fprintf('# Forças nos nós do elemento da direita em kN \n')
f2 = k2*u2 % Forças nos nós do elemento 2
fprintf('------------------------------------------------\n')

%% Diagrama de força
axes(handles.axes1)
FEM.BeamElementShearDiagram(f1, f2, L1, L2)
hold on
x = [0; Lt];
y = [0 ; 0];
viga = plot(x,y,'k');
set(viga,'LineWidth',[3])
legend('Cisalhamento','Viga')
title('Diagrama de força')
xlabel('Comprimento da viga [m]')
ylabel('Força [kN]')
hold off

%% Diagrama de momento
axes(handles.axes2)
FEM.BeamElementMomentDiagram(f1, f2, L1, L2)
hold on
x = [0; Lt];
y = [0 ; 0];
viga = plot(x,y,'k');
set(viga,'LineWidth',[3])
set(gca,'ydir','reverse')
legend('Momento','Viga')
title('Diagrama de Momento')
xlabel('Comprimento da viga [m]')
ylabel('Momento [kN.m]')
hold off

%% Gráfico da deformação
C1 = F(2);
C2 = F(6)-F(5)*Lt;
C3 = (E*I*U(3)/L1) - (F(1)*L1^(2)/6) - (C1*L1/2);
C4 = (F(1)*L1^(2)/2) + C1*L1 + C3 - (F(5)*L1^(2)/2) - C2*L1;
C6 = -(F(5)*Lt^(3)/6) - (C2*(Lt)^(2)/2) - C4*Lt;
xSol1 = 0:0.1:L1;
xSol2 = L1:0.1:Lt;
def1 = (1/(E*I))*(F(1)*xSol1.^(3)/6 + C1*xSol1.^(2)/2 + C3*xSol1);
def2 = -(1/(E*I))*(F(5)*xSol2.^(3)/6 + C2*xSol2.^(2)/2 + C4*xSol2 + C6);
def = [def1 def2];
xSol = [xSol1 xSol2];
axes(handles.axes3)
plot(xSol, def)
hold on
[m,i] = max(abs(def));
Maximo = plot(xSol(i),-m,'ro','markerfacecolor','r');
viga = plot(x,y,'k');
text(xSol(i)+0.1*xSol(i),-m+0.05*m,sprintf('(%.10f, %.10f) m',xSol(i), m))
set(viga,'LineWidth',[3])
title('Deformação da Viga')
xlabel('Comprimento da viga [m]')
ylabel('Deformação [m]')
legend('Viga deformada','Deslocamento máximo', 'Viga sem carregamento')
hold off

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
