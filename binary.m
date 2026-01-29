%This function tests if the outcome is binary or not
function y=binary(bin)

for i=1:length(bin)
   if (bin(i)==1) | (bin(i)==0)%if outcome 1 or zero, i.e. binary
      y=0;
   else
      y=1; %if each data not binary it use SSE and set ll=1
      return %if not 1 and 0 return immediatley no sense to continue  
   end
end
return