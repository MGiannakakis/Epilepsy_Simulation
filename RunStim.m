%Attempt with stimulation
function a = RunStim(t,n)

%% Set up
%options = odeset('InitialStep',1e-04,'MaxStep',0.001);
options = optimoptions('patternsearch','UseParallel', true, 'UseCompletePoll', true, 'UseVectorized', true );
modelHandle=@modelFun;

filename = ['WithStim' num2str(n)];
load(filename);
x_ini= WStim{3,end}; %Intitial values
t_ini = WStim{2,end};
t_end= t + t_ini ; %Simulation time
timestep=0.001;
parameters = cell(7,1);

W1 = WStim{1,end}; %Weights
W2 = WStim{4,end}; %Weights

delay = [0.001,0.002,0.003,0.004,0.005,0.006,0.007,0.008,0.009,...
        0.01,0.011,0.012,0.013,0.014,0.015,0.016,0.017,0.018,0.019,0.020,0.021,0.022];   %Possible delays
        
ini = size(WStim,2);
mem_end = (t_end-t_ini)/50;%Snapshots
temp = cell(4,size(WStim,2));
temp = WStim;
WStim = cell(4,ini + mem_end);
WStim(:,1:ini) = temp;


ending = t_end/ timestep;
beginning = t_ini/timestep;
rng(123,'twister')

az = 1000* t_ini ; % step counter
stim = 1; %Stimulation is off
stab = W2(1,1)+ W2(2,1)+ W2(3,1) + W2(4,1) + W2(6,1) ;

%% Main for-loop
for a = beginning:10:ending
    if a >= az
    disp(az/1000);
    az = az +10000;
    end
    
     rt =  rem (az/1000, 86400);
    if (rt > 200 )&&(rt < 2000)
        stim = 2; % Turn simulation on
    else
       stim = 1;  %Turn simulation off
    end
    
 
parameters(1)={W1};  
parameters(2)={stim};
parameters(3)={d};
parameters(4)={CDL};
parameters(5)={d1}; 
parameters(6)={d2};
parameters(7)={W2};


c = a*timestep;
tRange = c: timestep :c + 0.009 ; 
sol = dde23(modelHandle,delay,@history12,tRange,options, parameters);
    d1= sol.x';
    d2= sol.y';
    
    
   x_ini = d2(end,:);
  %[~,dy] = gradient(d2, mean(diff(tRange)));
   d = sol.yp(:,end);
   
   if rem(a,50000)==0 % Take snapshots every 50 sec
    WStim(1,a/50000 +1) = {W1}; % Weights
    WStim(2,a/50000 +1) = {d1(1)} ; %Time
    WStim(3,a/50000 +1) = {d2(1,:)}; % Population Activity 
    WStim(4,a/50000 +1) = {W2}; % Internal Weights
      save(filename,'WStim','d1','d2','d');
   end 
  
  for s = 1:82 %Updating weights
    for j = 1:82
        if W1(s,j)~=0 
        W1(s,j)= max(W1(s,j) + 0.1*d2(max(size(d2,1)-CDL(s,j),1),j)*(d2(end,s)- d2(max(size(d2,1)-1,1),s)),0);
        end
    end
    W2(1,s) = W2(1,s) + 0.05*d2(end,s)*(d2(end,s)- d2(max(size(d2,1)-1,1),s));
    W2(2,s) = W2(2,s) + 0.05*d2(end,s+82)*(d2(end,s)- d2(max(size(d2,1)-1,1),s));
    W2(4,s) = W2(4,s) + 0.05*d2(end,s)*(d2(end,s+82)- d2(max(size(d2,1)-1,1),s+82));
    W2(3,s) = W2(3,s) + 0.05*d2(end,s+164)*(d2(end,s)- d2(max(size(d2,1)-1,1),s));
    W2(6,s) = W2(6,s) + 0.05*d2(end,s)*(d2(end,s+164)- d2(max(size(d2,1)-1,1),s+164));
    
    
    
end
w1 = sum (W1,1); %Normalising weights
W1 = rdivide(W1,w1);

h = W2(1,:)+ W2(2,:) + W2(4,:)+ W2(6,:) + W2(3,:);
W2(1,:) = stab* W2(1,:)./ h;
W2(2,:) = stab* W2(2,:)./ h;
W2(3,:) = stab* W2(3,:)./ h;
W2(4,:) = stab* W2(4,:)./ h;
W2(6,:) = stab* W2(6,:)./ h;
  
 for k=1:82 %Maintaining symmetry in the weights between regions
     for l =k:82
          w = (W1(k,l)+W1(l,k))/2;
          W1(k,l)=w;
          W1(l,k)=w;
      end
 end
 
end 
   
%% 
%toc   
save(filename,'WStim','d1','d2','d','CDL');
end