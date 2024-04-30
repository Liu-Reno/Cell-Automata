function [S,E] = initial(map,S0,E0)
n = S0+E0;%设置初始总人数
mapmartix = map;%导出地图
row = size(mapmartix,1);
list = size(mapmartix,2);
Position = zeros(n,2);
for i = 1:n% 给每个人的位置进行赋值
    stop = 0;% 设置停止判断
    while stop ==0 % 确保人不会出现在不该出现的位置
    p_list = randperm(list,1);
    p_row = randperm(row,1);
    if mapmartix(p_row,p_list) == 0% 确保人不会出现在限制区域
        stop = 1;
    end
    end
    Position(i,1) = p_row;
    Position(i,2) = p_list;
end
%% 对于位置进行赋值
S = Position(1:S0,1:2);
E = Position(S0+1:S0+E0,1:2);
end