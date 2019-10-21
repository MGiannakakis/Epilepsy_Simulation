t = 400 ;
Parray = [68 68];
%[47 47 48 48 51 51 53 53 54 54 55 55];
% [58 58 61 61 62 62 68 68 71 71 74 74];
 
 
tic
   
parfor i=1:2
    if rem(i,2)==0
   DataCreateStim(Parray(i)) 
   RunStim(t,Parray(i));
    else
   DataCreateNoStim(Parray(i))
   RunNoStim(t,Parray(i));
    end
end
toc

