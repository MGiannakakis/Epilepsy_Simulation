function  DataCreateStim(n)
load('connectome_refined')

%Weights between regions
W1 = squareform(subject_connectivity (n,:));
W1 = 0.1*log(W1);

for i = 1:82
    for j=1:82
        if W1(i,j) == -Inf
           W1(i,j)=0;
        end
    end
end

%Weights within regions
iw = [15; 12; 15; 14; 0; 20; 16; 8];
W2 = ones(8,82);
for  i= 1:82
    W2(:,i) = iw;
end
if n>40 %if epileptic
 ie = [16; 11.5; 14.5; 14; 0; 20; 16; 8]; 
 W2(:,15) = ie;
 W2(:,39) = ie;
 W2(:,40) = ie;
end 

%delays
CDL=  squareform(subject_distance(1,:));
CDL = ceil(CDL/10);
CDL (isnan(CDL))=0 ;

d1 = zeros(19,1);
d2 = zeros(19,246);
d = zeros(246,1);

WStim = cell(4,1);
 WStim(1,1) = {W1}; % Weights
 WStim(2,1) = {d1(1)} ; %Time
 WStim(3,1) = {d2(1,:)}; %initial values
 WStim(4,1) = {W2};
 filename1 = ['WithStim' num2str(n)];
save(filename1,'WStim','d1','d2','d','CDL');

end
