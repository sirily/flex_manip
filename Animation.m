function [sys,x0,str,ts] = Animation(t,x,u,flag, Config)
%sf_PaintObject Рисование объектов
%

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Инициализация %
  %%%%%%%%%%%%%%%%%%
  case 0,
     [sys,x0,str,ts]=mdlInitializeSizes(Config);

  %%%%%%%%%%%%%%%%%%%%%%%%%
  % Не используемые флаги %
  %%%%%%%%%%%%%%%%%%%%%%%%%
  case {1 , 3},
     sys=[];
     
  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
     sys = [];
     if Config.E
       mdlUpdate(t,x,u,Config);
     end;
  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u,Config);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
     sys=[];
otherwise
  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  error('unhandled flag');
end

% end sf_PaintObject
%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes(Config)

%
% Set Sizes Matrix
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 0;
sizes.NumInputs      = 3;
    
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialise the initial conditions
%
x0  = [];

%
% str is always an empty matrix
%
str = [];

%
% initialise the array of sample times
%
ts  = -1; % inherited sample time

if ~Config.E
   return
end

%
% Инициализируем рисунок
%

% Ищем рисунок
h_f=findobj('type','figure','Tag','Lorien anim');
   
if isempty(h_f)       
  h_anim=figure;       
  set(h_anim, 'Tag','Lorien anim');
else
  h_anim=h_f;
end;

handle = get(h_anim,'userdata');

set(h_anim,'name','Animation Figure', ...
           'renderer','zbuffer','resize','on', ...
           'position',[0, 50, Config.S*Config.a, Config.S*Config.h]);
h_del = findobj(h_anim,'type','axes');
delete(h_del); 
figure(h_anim);
handle.axes(1)=axes;
axis([0 Config.a 0 Config.b 0 Config.h]);
set(handle.axes(1),'visible','on', ...
                   'units','normal', ...
                   'drawmode','fast'); 

%handle.crane1 = plot3([0 0], [0 0], [0 Config.h]);
%handle.crane2 = plot3([Config.b Config.b], [0 0], [0 Config.h]);
%handle.crane3 = plot3([0 0], [Config.a Config.a], [0 Config.h]);
%handle.crane4 = plot3([Config.b Config.b], [Config.a Config.a], [0 Config.h]);

[bvv,ff] = get_box(Config.X0(2), Config.X0(1), Config.X0(3), Config.f, Config.d, 0.2);
handle.box = patch('Vertices',bvv,'Faces',ff,...
                   'FaceVertexCData',hsv(8),'FaceColor','flat');
handle.legend = legend(handle.box, strcat(num2str(Config.X0(1)), '; ', num2str(Config.X0(2)),'; ', num2str(Config.X0(3))));
[vv,ff] = get_box(0.15, 0.15, Config.h, 0.15, 0.15, Config.h);
handle.crane1 = patch('Vertices',vv,'Faces',ff,...
                      'FaceVertexCData',hsv(6),'FaceColor','flat');
[vv,ff] = get_box(Config.a - 0.15, 0.15, Config.h, 0.15, 0.15, Config.h);
handle.crane2 = patch('Vertices',vv,'Faces',ff,...
                      'FaceVertexCData',hsv(6),'FaceColor','flat');
[vv,ff] = get_box(0.15, Config.b - 0.15, Config.h, 0.15, 0.15, Config.h);
handle.crane3 = patch('Vertices',vv,'Faces',ff,...
                      'FaceVertexCData',hsv(6),'FaceColor','flat');
[vv,ff] = get_box(Config.a - 0.15, Config.b - 0.15, Config.h, 0.15, 0.15, Config.h);
handle.crane4 = patch('Vertices',vv,'Faces',ff,...
                      'FaceVertexCData',hsv(6),'FaceColor','flat');
handle.line1 = patch([0.15, bvv(5,1)], [0.15, bvv(5,2)], [Config.h, bvv(5,3)], [0 0 0]);
handle.line2 = patch([Config.a - 0.15, bvv(6,1)], [0.15, bvv(6,2)], [Config.h, bvv(6,3)], [0 0 0]);
handle.line3 = patch([0.15, bvv(8,1)], [Config.b - 0.15, bvv(8,2)], [Config.h, bvv(8,3)], [0 0 0]);
handle.line4 = patch([Config.a - 0.15, bvv(7,1)], [Config.b - 0.15, bvv(7,2)], [Config.h, bvv(7,3)], [0 0 0]);

view([Config.X0(2), Config.X0(1), 5]);
set(h_anim,'userdata',handle);

grid on;

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function mdlUpdate(t,x,u, Config)

%
% Ищем рисунок
%
h_anim=findobj('type','figure','Tag','Lorien anim');

if isempty(h_anim)
    %Рисунок был закрыт пользователем
    return
end;

[bvv,ff] = get_box(u(2), u(1), u(3), Config.f, Config.d, 0.2);


handle = get(h_anim,'userdata');
set(handle.box, 'Vertices',bvv,'Faces',ff);
set(handle.line1, 'XData', [0.15, bvv(5,1)], 'YData', [0.15, bvv(5,2)], 'ZData', [Config.h, bvv(5,3)]);
set(handle.line2, 'XData', [Config.a - 0.15, bvv(6,1)], 'YData', [0.15, bvv(6,2)], 'ZData', [Config.h, bvv(6,3)]);
set(handle.line3, 'XData', [0.15, bvv(8,1)], 'YData', [Config.b - 0.15, bvv(8,2)], 'ZData', [Config.h, bvv(8,3)]);
set(handle.line4, 'XData', [Config.a - 0.15, bvv(7,1)], 'YData', [Config.b - 0.15, bvv(7,2)], 'ZData', [Config.h, bvv(7,3)]);
if ishandle(handle.legend)
    set(handle.legend, 'string', strcat(num2str(u(1)), '; ', num2str(u(2)),'; ', num2str(u(3))));
end;


set(h_anim,'userdata',handle);


% end mdlUpdate

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u, Config)
    
   sys = ceil(t/Config.U)*Config.U+Config.U;

% end mdlGetTimeOfNextVarHit

function [VV, FF] = get_box(X,Y,Z, f, d, h)
         %  X   Y   Z
    VV = [X-f/2,  Y-d/2, Z-h;
          X+f/2,  Y-d/2, Z-h;
          X+f/2,  Y+d/2, Z-h;
          X-f/2,  Y+d/2, Z-h;
          X-f/2,  Y-d/2, Z;
          X+f/2,  Y-d/2, Z;
          X+f/2,  Y+d/2, Z;
          X-f/2,  Y+d/2, Z];
    FF = [1 2 6 5;
          2 3 7 6;
          3 4 8 7;
          4 1 5 8;
          1 2 3 4;
          5 6 7 8];

