t = 24*3600 %Duration in seconds
n = 68 % Patient Index
parfor i=1:2
    if rem(i,2)==0
   DataCreateStim(n) 
   RunStim(t,n);
    else
   DataCreateNoStim(n)
   RunNoStim(t,n));
    end
end


