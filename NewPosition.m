function state = NewPosition(map,state)
%% 更新易感者位置
for i = 1:state.number_of_susceptible
    stop = 0;
    %% 设置移动步长行列均为-1到1
    while stop == 0
    list = randperm(3,1);
    list = list-2;
    row = randperm(3,1);
    row = row-2;
    r = [list,row];
    P = r;


    if state.Position_of_susceptible(i,1)+P(1) >0 && state.Position_of_susceptible(i,2)+P(2) >0
    if abs(state.Position_of_susceptible(i,1)+P(1)) < size(map,1) && abs(state.Position_of_susceptible(i,2)+P(2)) < size(map,2) && abs(state.Position_of_susceptible(i,1)+r(1)) >0 && abs(state.Position_of_susceptible(i,2)+r(2)) >0%% 判断是否超越边界
     if map(abs(state.Position_of_susceptible(i,1)+P(1)),abs(state.Position_of_susceptible(i,2)+P(2))) == 0%判断是否会撞墙
        stop = 1;
     end
    end
    end
    end
        %% 更新位置
    state.Position_of_susceptible(i,1) = abs(state.Position_of_susceptible(i,1)+P(1));
    state.Position_of_susceptible(i,2) = abs(state.Position_of_susceptible(i,2)+P(2));
end
%% 更新携带者位置
for i = 1:state.number_of_exposed
        stop = 0;
    %% 设置移动步长行列均为-1到1
    while stop == 0
    list = randperm(3,1);
    list = list-2;
    row = randperm(3,1);
    row = row-2;
    r = [list,row];
   P = r;

    if state.Position_of_exposed(i,1)+r(1) >0 && state.Position_of_exposed(i,2)+r(2) >0
    if abs(state.Position_of_exposed(i,1)+r(1)) < size(map,1) && abs(state.Position_of_exposed(i,2)+r(2)) < size(map,2) && abs(state.Position_of_exposed(i,1)+r(1)) >0 && abs(state.Position_of_exposed(i,2)+r(2)) >0%% 判断是否超越边界
     if map(abs(state.Position_of_exposed(i,1)+r(1)),abs(state.Position_of_exposed(i,2)+r(2))) == 0%判断是否会撞墙
        stop = 1;
     end
    end
    end
    end
        %% 更新位置
    state.Position_of_exposed(i,1) = abs(state.Position_of_exposed(i,1)+P(1));
    state.Position_of_exposed(i,2) = abs(state.Position_of_exposed(i,2)+P(2));
end
%% 更新染病者位置
if state.number_of_infectious ~= 0
    for i = 1:state.number_of_infectious
        stop = 0;
    %% 设置移动步长行列均为-1到1
    while stop == 0
    list = randperm(3,1);
    list = list-2;
    row = randperm(3,1);
    row = row-2;
    r = [list,row];
    %% 判断是否越界
    
    if state.point == 1
         P_0 = state.point_Position;
         P1 = P_0 - state.Position_of_infectious(i,:);
         P = 0.08*P1;
    else
    list = randperm(3,1);
    list = list-2;
    row = randperm(3,1);
    row = row-2;
    r = [list,row];
   P = r;
    end
    if abs(state.Position_of_infectious(i,1)+P(1)) >= size(map,1)
        P(1) = -1;
    end
    if abs(state.Position_of_infectious(i,2)+P(2)) >= size(map,2)
        P(2) = -1;
    end
    if abs(state.Position_of_infectious(i,1)+P(1)) <= 0
        P(1) = 1;
    end
    if abs(state.Position_of_infectious(i,2)+P(2)) <= 0
        P(2) = 1;
    end
    if round(state.Position_of_infectious(i,1)+P(1)) >0 && round(state.Position_of_infectious(i,2)+P(2)) >0
    if abs(round(state.Position_of_infectious(i,1)+P(1))) < size(map,1) && abs(round(state.Position_of_infectious(i,2)+P(2))) < size(map,2)%% 判断是否超越边界
       % if map((state.Position_of_infectious(i,1)+P(1)),abs(state.Position_of_infectious(i,2)+P(2))) == 0
        stop = 1;
       % end
    end
    end
    end
        %% 更新位置
    state.Position_of_infectious(i,1) = abs(round(state.Position_of_infectious(i,1)+P(1)));
    state.Position_of_infectious(i,2) = abs(round(state.Position_of_infectious(i,2)+P(2)));
    end
end
%% 更新无症状感染者位置
if state.number_of_asymptomatic ~= 0
    for i = 1:state.number_of_asymptomatic
        stop = 0;
    %% 设置移动步长行列均为-1到1
    while stop == 0
    list = randperm(3,1);
    list = list-2;
    row = randperm(3,1);
    row = row-2;
    r = [list,row];

    P = r;


    if state.Position_of_asymptomatic(i,1)+P(1) >0 && state.Position_of_asymptomatic(i,2)+P(2) >0
    if abs(state.Position_of_asymptomatic(i,1)+P(1)) < size(map,1) && abs(state.Position_of_asymptomatic(i,2)+P(2)) < size(map,2) %% 判断是否超越边界
     if map(abs(state.Position_of_asymptomatic(i,1)+P(1)),abs(state.Position_of_asymptomatic(i,2)+P(2))) == 0%判断是否会撞墙
        stop = 1;
     end
    end
    end
    end
        %% 更新位置
    state.Position_of_asymptomatic(i,1) = abs(state.Position_of_asymptomatic(i,1)+P(1));
    state.Position_of_asymptomatic(i,2) = abs(state.Position_of_asymptomatic(i,2)+P(2));
    end

end
if state.number_of_recovered ~= 0
     for i = 1:state.number_of_recovered
        stop = 0;
    %% 设置移动步长行列均为-1到1
    while stop == 0
    list = randperm(3,1);
    list = list-2;
    row = randperm(3,1);
    row = row-2;
    r = [list,row];
    P = r;
    if state.Position_of_recovered(i,1)+P(1) >0 && state.Position_of_recovered(i,2)+P(2) >0
    if abs(state.Position_of_recovered(i,1)+P(1)) < size(map,1) && abs(state.Position_of_recovered(i,2)+P(2)) < size(map,2) %% 判断是否超越边界
    %if map(abs(state.Position_of_recovered(i,1)+P(1)),abs(state.Position_of_recovered(i,2)+P(2))) == 0%判断是否会撞墙
        stop = 1;
    %end
    end
    end
    end
        %% 更新位置
    state.Position_of_recovered(i,1) = abs(state.Position_of_recovered(i,1)+P(1));
    state.Position_of_recovered(i,2) = abs(state.Position_of_recovered(i,2)+P(2));
     end
end
end
function w = weight(state)
w = 1 - 0.1*state.Iteration/state.Max_Iteration ;
end