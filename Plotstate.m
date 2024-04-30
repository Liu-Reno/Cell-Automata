function Plotstate(state,Position_of_map)
        %% 易感者
        scatter(state.Position_of_susceptible(:,1),state.Position_of_susceptible(:,2),15,[126/256,211/256,33/256],"filled");
        hold on
        %% 携带者
        scatter(state.Position_of_exposed(:,1),state.Position_of_exposed(:,2),15,[248/256,231/256,28/256],"filled");
        hold on
        %% 感染者
        if state.number_of_infectious > 0
            scatter(state.Position_of_infectious(:,1),state.Position_of_infectious(:,2),15,[208/256,2/256,27/256],"filled");
            hold on
        end
        %% 无症状感染者
        if state.number_of_asymptomatic > 0
            scatter(state.Position_of_asymptomatic(:,1),state.Position_of_asymptomatic(:,2),15,[245/256,166/256,35/256],"filled");
            hold on
        end
        %% 康复以及疫苗
        if state.number_of_infectious > 0
            scatter(state.Position_of_recovered(:,1),state.Position_of_recovered(:,2),15,[74/256,144/256,226/256],"filled");
        %% 绘制边界
        scatter(Position_of_map(:,1),Position_of_map(:,2),3,[155/156,155/256,155/256],"square","filled");

end