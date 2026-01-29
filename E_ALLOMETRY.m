function y=E_ALLOMETRY(ydat,xdat,ll)
%B_NUM=number of parameters, W=the data array where col 2:N2+1 contains the independent variables
%N2=number of independent variables
global FUNCNAME 
global BETA
str = ['v=' FUNCNAME '(ydat,xdat,BETA);'];%creates a string to be used in eval
eval(str);  %the driver to call the function
for i=1:length(ydat)%to be used when v cannot be 0
   if v(i)<=0
      v(i)=10^-50;%making the error really large
   elseif v(i)>=1
      v(i)==1-10^-50;%   
   end   
end  

if ll==0 %if LL=compute log-likelihood for each observation
   m=ydat.*log(v)+(1.0-ydat).*log(1.0-v);
else %if SSE return the error estimate
   m=ydat-v;
end 
save('v', 'v', '-ascii');
y=m;%returns LL or SSE also called F in all NMRI programs
