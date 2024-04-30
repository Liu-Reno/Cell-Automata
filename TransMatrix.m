function state = TransMatrix(state)

%% 开始构建位置矩阵
map= zeros(size(state.map,1),size(state.map,2));%制造一个空地图
state.Position.susceptible_Matrix = map;
state.Position.exposed_Matrix = map;
state.Position.infectious_Matrix = map;
state.Position.asymptomatic_Matrix = map;
state.Position.recover_Matrix = map;
for i = 1:state.number_of_susceptible
    state.Position.susceptible_Matrix(state.Position_of_susceptible(i,1),state.Position_of_susceptible(i,2)) = 1;%将有人所在的位置赋值为1
end
for i = 1:state.number_of_exposed
    state.Position.exposed_Matrix(state.Position_of_exposed(i,1),state.Position_of_exposed(i,2)) = 1;
end
for i = 1:state.number_of_infectious
    state.Position.infectious_Matrix(state.Position_of_infectious(i,1),state.Position_of_infectious(i,2)) = 1;
end
for i = 1:state.number_of_asymptomatic
    state.Position.asymtomatic_Matrix(state.Position_of_asymptomatic(i,1),state.Position_of_asymptomatic(i,2)) = 1;
end
for i = 1:state.number_of_recovered
    state.Position.recover_Matrix(state.Position_of_recovered(i,1),state.Position_of_recovered(i,2)) = 1;
end