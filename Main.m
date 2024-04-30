%%%%%%%%%%%%%%%%%%%%%%%
% 本程序为带边界的元胞自动机程序
% Author: Liu Ou
%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
parameter = readmatrix("参数.xlsx");
S0 = parameter(1);
E0 = parameter(2);
beta = parameter(3);
alpha = parameter(4);
p = parameter(5);
delta = parameter(6);
r_I = parameter(7);
r_A = parameter(8);
side = parameter(9);
%map = readmatrix("map.xlsx");
map = readmatrix("map.xlsx");
[row,col] = find(map);
Position_of_map = [row,col];
iteration= 400;%设置总迭代次数
[initial_S0,initial_E0] = initial(map,S0,E0);
%% 创建位置矩阵结构体
Position = struct( ...
    'susceptible_Matrix',zeros(1), ...
    'exposed_Matrix',zeros(1), ...
    'infectious_Matrix',zeros(1), ...
    'asymptomatic_Matrix',zeros(1), ...
    'recover_Matrix',zeros(1));
%% 创建综合结构体
state = struct( ...%设置结构体
    'Position_of_susceptible',initial_S0 ,...
    'Position_of_exposed',initial_E0 ,...
    'Position_of_infectious',zeros(1,2), ...
    'Position_of_asymptomatic',zeros(1,2), ...
    'Position_of_recovered',zeros(1,2), ...
    'number_of_susceptible',S0 , ...
    'number_of_exposed',E0, ...
    'number_of_infectious',0, ...
    'number_of_recovered',0, ...
    'number_of_asymptomatic',0, ...
    'map',map, ...
    'Position',Position, ...
    'Iteration',0, ...
    'Max_Iteration',iteration, ...
    'point',true,...
    'new_I',[],...
    'new_A',[],...
    'point_Position',[65,24]);
%% 准备迭代
data_folder = './Fig_fit/'; %生成sijv_vaccination名字的文件夹
if ~isfolder(data_folder)  %低版本Matlab，使用isidr()函数；高版本Matlab，使用isfolder()函数
    mkdir(data_folder);
end
for i = 1:iteration
    state.Iteration = i;% 更新当前迭代次数
    %% 设置更新函数
    state = NewPosition(map,state);%更新位置
    state = TransMatrix(state);%将位置转化为矩阵
    Plotstate(state,Position_of_map);%绘图
    axis([0,size(map,1),0,size(map,2)])%设置坐标系
    Position_of_susceptible(i)=getframe(gcf);%逐帧存放  
    if i == 1 || 40 || 80 || 120 || 160 || 200 || 300 || 400 || 800
        C = char("Picture"+num2str(i));
        filename = [data_folder,C ]; %图形保存在data_folder文件夹中
       print(gcf, filename, '-djpeg', '-r300');
    end
    hold off
    state = Updatestate(state,beta,alpha,p,delta,r_I,r_A,side);%更新状态
     %% 记录人数
        S(i) = state.number_of_susceptible;
        A(i) = state.number_of_asymptomatic;
        I(i) = state.number_of_infectious;
        R(i) = state.number_of_recovered;
        
end
sum(state.new_I+state.new_A)
figure
plot(S);
figure
plot(A+I);
figure
plot(R);
video_Position_of_Susceptible = VideoWriter('video_Position_of_Susceptible');
open(video_Position_of_Susceptible);
for k = 1:iteration
   writeVideo(video_Position_of_Susceptible,Position_of_susceptible(k));%Vedio写入
end
close(video_Position_of_Susceptible);