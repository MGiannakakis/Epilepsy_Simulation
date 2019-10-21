function y = history12(t,a)
d1 = a{5}; %Previous time values
d2 = a{6}; % Previous solution values

d = d1 - t ;
a = abs(d);
[dmin,k] = min(a);

y = d2(k,:);

end