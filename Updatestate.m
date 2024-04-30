function state = Updatestate(state,beta,alpha,p,delta,r_I,r_A,side)

%% 初始化
    judge_susceptible = zeros(state.number_of_susceptible,1);
    judge_exposed = zeros(state.number_of_exposed,1);
    judge_infectious = zeros(state.number_of_infectious,1);
    judge_asymptomatic = zeros(state.number_of_asymptomatic,1);
    %% 计算第i个易感者的邻域范围内有多少个感染者
for i =1:state.number_of_susceptible
    number_of_infectious = zeros(2*side);
    for j = -side:side
        for k = -side:side
            %% 防止超界(防止撞墙已经于NewPosition.m)中设计
            if state.Position_of_susceptible(i,1)+j <=0 || state.Position_of_susceptible(i,1)+j >=size(state.map,2)
                j_1 = 0;
            else
                j_1 = j;
            end
            if state.Position_of_susceptible(i,2)+k <=0 || state.Position_of_susceptible(i,2)+k >=size(state.map,1)
                k_1 = 0;
            else
                k_1 = k;
            end

            number_of_infectious(j+side+1,k+side+1) = sum(state.Position.infectious_Matrix(state.Position_of_susceptible(i,1)+j_1,state.Position_of_susceptible(i,2)+k_1))+ ...计算邻域范围内的感染者个数 
            sum(state.Position.asymptomatic_Matrix(state.Position_of_susceptible(i,1)+j_1,state.Position_of_susceptible(i,2)+k_1));%计算邻域范围内的无症状感染者个数
        end
    end
    %% 进行求和(分两步求和,方便报错检查)
number_of_infectious_1 = sum(number_of_infectious);
number_of_infectious_2 = sum(number_of_infectious_1);
    %% 判断是否被感染
    if rand <= f(number_of_infectious_2,beta)
        judge_susceptible(i) = 1;% 若judge_exposed(i) = 1则表示此时第i个易感者被感染,若为0则未被感染
    else 
        judge_susceptible(i) = 0;
    end
end
%% 携带者转化判定
for i=1:state.number_of_exposed
    if rand <= alpha%确诊
        if rand <= p
        judge_exposed(i) = 1;%转化为感染者
        else 
        judge_exposed(i) = 2;%转化为无症状感染者
        end
    else
        judge_exposed(i) = 0;%保持不变
    end
end
%% 感染者转化判定
if state.number_of_infectious >0
    for i = 1:state.number_of_infectious
        if rand <= r_I
            judge_infectious(i) = 1;%康复
        else
            judge_infectious(i) = 0;%保持不变
        end
    end
end
%% 无症状感染者转化判定
if state.number_of_asymptomatic >0
    for i = 1:state.number_of_asymptomatic
        if rand >= r_A
            if rand <= delta
                judge_asymptomatic(i) = 2;%转化为感染者
            else
                judge_asymptomatic(i) = 0;%保持不变
            end
        else 
            judge_asymptomatic(i) = 1;%转化为康复者
        end
    end
end
%% 总结
J_S_1 = find(judge_susceptible == 1);% S \to E
J_E_1 = find(judge_exposed == 1);% E \to I
J_E_2 = find(judge_exposed == 2);% E \to A
J_A_1 = find(judge_asymptomatic == 1);% A \to R
J_A_2 = find(judge_asymptomatic == 2);% A \to I
J_I_1 = find(judge_infectious == 1);% I \to R

%% Update阶段

%% 更新S
state.number_of_susceptible = state.number_of_susceptible - length(J_S_1);%更新易感者人数
S_to_E = zeros(length(J_S_1),2);
for i = 1: length(J_S_1)
    S_to_E(i,:) = state.Position_of_susceptible(J_S_1(i),:);
end
state.Position_of_susceptible(J_S_1,:) = [];%在易感者中删去携带者

%% 更新E
E_to_I = zeros(length(J_E_1),2);
E_to_A = zeros(length(J_E_2),2);
for i = 1:length(J_E_1)
    E_to_I(i,:) = state.Position_of_exposed(J_E_1(i),:);
end
for i = 1:length(J_E_2)
    E_to_A(i,:) = state.Position_of_exposed(J_E_2(i),:);
end
J_E = union(J_E_1,J_E_2);
state.number_of_exposed = state.number_of_exposed - length(J_E) + size(S_to_E,1);%更新携带者人数
state.Position_of_exposed(J_E,:) = [];%在携带者中删除流出部分
State_P_E = size(state.Position_of_exposed,1);
for i = size(state.Position_of_exposed,1)+1:state.number_of_exposed
    state.Position_of_exposed(i,:) = S_to_E(i - State_P_E,:);% 更新携带者位置
end


%% 更新A
if state.number_of_asymptomatic >0
A_to_R = zeros(length(J_A_1),2);
A_to_I = zeros(length(J_A_2),2);
for i = 1:length(J_A_1)
    A_to_R(i,:) = state.Position_of_asymptomatic(J_A_1(i),:);
end
for i = 1:length(J_A_2)
    A_to_I(i,:) = state.Position_of_asymptomatic(J_A_2(i),:);
end

J_A = union(J_A_1,J_A_2);
state.number_of_asymptomatic = state.number_of_asymptomatic - length(J_A) + size(E_to_A,1);%更新无症状感染者人数
state.Position_of_asymptomatic(J_A,:) = [];%在无症状感染者中删去流出部分
State_P_A = size(state.Position_of_asymptomatic,1);
for i = size(state.Position_of_asymptomatic,1)+1:state.number_of_asymptomatic
    state.Position_of_asymptomatic(i,:) = E_to_A(i- State_P_A,:);% 更新无症状感染者位置
end
state.new_A(state.Iteration)=size(E_to_A,1);
else
    for i = 1:size(E_to_A,1)
    state.Position_of_asymptomatic(i,:) = E_to_A(i,:);% 更新无症状感染者位置
    end
    state.number_of_asymptomatic = length(J_E_2);
    A_to_I = [];
    A_to_R = [];
end


%% 更新I
if state.number_of_infectious >0
    I_to_R = zeros(length(J_I_1),2);
    for i = 1:length(J_I_1)
    I_to_R(i,:) = state.Position_of_infectious(J_I_1(i),:);
    end
  state.number_of_infectious = state.number_of_infectious - length(J_I_1) + size(A_to_I,1) + size(E_to_I,1);
  state.Position_of_infectious(J_I_1,:) = [];
  State_P_I = size(state.Position_of_infectious,1);
  for i = size(state.Position_of_infectious,1)+1:state.number_of_infectious - size(A_to_I,1)
    state.Position_of_infectious(i,:) = E_to_I(i-State_P_I,:);
  end
  State_P_I = size(state.Position_of_infectious,1);
  for i = size(state.Position_of_infectious,1)+1 : state.number_of_infectious
    state.Position_of_infectious(i,:) = A_to_I(i-State_P_I,:);
  end
  state.new_I(state.Iteration) = size(E_to_I,1);
else
    I_to_R = [];
    state.number_of_infectious = state.number_of_infectious +  size(A_to_I,1) + size(E_to_I,1);
    if state.number_of_infectious - size(A_to_I,1) >= 1
      for i = 1: state.number_of_infectious - size(A_to_I,1)
      state.Position_of_infectious(i,:) = E_to_I(i,:);
      end
    end

        State_P_I = size(state.Position_of_infectious,1);
     if state.number_of_infectious >1
  for i = size(state.Position_of_infectious,1)+1 : state.number_of_infectious
    state.Position_of_infectious(i,:) = A_to_I(i-State_P_I,:);
  end
     end
end

%% 更新R

for i = state.number_of_recovered+1 :state.number_of_recovered+ size(A_to_R,1) + size(I_to_R,1)
    if i- state.number_of_recovered <= size(A_to_R,1)
    state.Position_of_recovered(i,:) = A_to_R(i-state.number_of_recovered,:);
    else
    state.Position_of_recovered(i,:) = I_to_R(i-(state.number_of_recovered+ size(A_to_R,1)),:);
    end
end
state.number_of_recovered = state.number_of_recovered+ size(A_to_R,1) + size(I_to_R,1);

end

%% 设置感染率叠加函数
function a = f(number_of_infectious,beta)
if number_of_infectious*beta <= 0.9
    a = number_of_infectious;
else
    a = 0.9;
end
end