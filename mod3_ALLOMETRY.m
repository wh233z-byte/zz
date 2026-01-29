%debugged 990622 gives correct values for SSE and LL

function mod3_ALLOMETRY(b_num,ydat,xdat,q,ll)
global L BETA G A

p=zeros(1,b_num);
for i=1:b_num
   q(i,i)=q(i,i)*(1+L); %adds the gradient vector to q
end
c=inv(q);                %the inverse of q
for i=1:b_num
   for j=1:b_num
      p(i)=p(i)+c(i,j)*G(j);%estimate new partials
   end
   p(i)=p(i)/sqrt(A(i,i));
end
disp('calling mod4')
if BETA(1)==NaN %when the program "chrases due to singular matrix inversion or something end program by setting T2=T1, ie. one more iteration then stop
   T2=T1;
   not_numbrt=0
end

mod4_ALLOMETRY(b_num,ydat,xdat,q,p,ll);
return

