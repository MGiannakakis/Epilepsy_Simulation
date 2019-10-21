function dxdt = modelFun(t,x,Z,param)


dxdt = param{3};%Initial derivative value
P_e = 2; %+ 0.1*randn;% External input to the excitatory region
P_s=1;%  External input to the first inhibitory region
P_d=1;%  External input to the second inhibitory region

a_e=1.3;% Sigmoid constant a for excitatory population 
a_s=2; % Sigmoid constant a for inhibitory population 1
a_d=2;% % Sigmoid constant a for inhibitory population 2
u_e=4;% Sigmoid constant theta for excitatory population
u_s=3.7;%Sigmoid constant theta for inhibotory population 1
u_d=3.7;% Sigmoid constant theta for inhibotory population 1

t_e=0.025;% Excitatory time step
t_s=0.05;% Inhibitory 1 time step
t_d=0.05;% Inhibitory 2 time step


W1 = param{1};%weights between regions
CDL = param{4};%time delays
stim = param{2}; %Stimulation on/off
W2 = param{7};%weights within regions

for  i = 1:82 
  C = 0;
  %Calculating the external input (from other regions) to each region
  for j=1:82
    C = C + (CDL(i,j)>0)*W1(i,j)* Z(j,CDL(i,j) + (CDL(i,j)==0));   
  end
 
  W = W2(:,i);
  
% Stimulated regions Regions: 39 (amygdala), (40 hippocampus),15 (parahippocampal gyrus)
dxdt(i)=(-x(i)+((exp((a_e/(1+W(3)*x(i + 164)))*u_e)/(1+exp((a_e/(1+W(3)*x(i + 164)))*u_e)))- x(i))*(1/(1+exp(-(a_e/(1+W(3)*x(i + 164)))*((W(1)*x(i)+ P_e - 1.1*((stim >1)&((i==39)|(i==40)|(i==15)))+ ...
        C(1,1))-(u_e+W(2)*x(i+82)))))-1/(1+exp((a_e/(1+W(3)*x(i + 164)))*u_e))))/t_e;% Excitatory population
dxdt(i+82)=(-x(i+82)+((exp(a_s*u_s)/(1+exp(a_s*u_s)))-x(i+82))*(1/(1+exp(-a_s*((W(4)*x(i)+P_s)-(u_s+ W(5)*x(i+82)))))-1/(1+exp(a_s*u_s))))/t_s; % Inhibitory population 1
dxdt(i+164)=(-x(i+164)+((exp(a_d*u_d)/(1+exp(a_d*u_d)))-x(i+164))*(1/(1+exp(-a_d*((W(6)*x(i)+P_d)-(u_d+W(7)*x(i+82)+W(8)*x(i+164)))))-1/(1+exp(a_d*u_d))))/t_d; %Inhibitory population 2
end
