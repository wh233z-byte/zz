%debugged 990606, gives correct values for SSE estimation
%debugged 990622 gives correct values for SSE and LL

function mod2_ALLOMETRY(b_num,ydat,xdat,ll)
global L BETA G A 
A
%A=var-covar matrix
%G=gradient vector
for i=1:b_num
   for j=1:b_num
      q(i,j)=A(i,j)/(sqrt((A(i,i)*A(j,j))));%The ./operator makes sure that it is division by normal algebra
   end
   G(i)=G(i)/sqrt(A(i,i));   
end
disp('calling mod3')
mod3_ALLOMETRY(b_num,ydat,xdat,q,ll);
return
