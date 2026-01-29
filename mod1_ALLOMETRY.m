%P[N,BETA]=the matrix keeping the partial derivatives, 
%G[1,BETA]=graident vector= an array of size beta, i.e. one gradient for each beta
%, A[BETA,BETA]=the var-covar matrix, e1[N,1]=the error of estimate 1,
%e2[N,BETA]=the error for each Y,X data pair and beta
function mod1_ALLOMETRY(b_num,ydat,xdat,ll)%Remember that column one of W is y-data
global BETA G SO A N T2 
global Z %Z is used in mod 6 to avoid recomputation of p for the SSE case, in the LL case it is not used since we need to recompute new partials,  since creation of an array of dummy x-values p needs to be computed
p=zeros(length(ydat),b_num); %partial derivative in module 2 is by size= [N,b_num]
e1=E_ALLOMETRY(ydat,xdat,ll); %function call to get error vector
if ll==0%ll=test statement to see if Log-like or least squares
   SO=sum(-e1);%for log-likelihood 
else   
   SO=sum(e1.^2);%for least squares, this number is correst!!!!
end   
T2=T2+1;
for i=1:b_num
      BETA(i)=BETA(i)*1.001;%BETA gets changed temporarily
      e2(:,i)=E_ALLOMETRY(ydat,xdat,ll); %e2 is the new error term to be compared to E1  
      BETA(i)=BETA(i)/1.001;%Beta gets changed back
      s(:,i)=(e1-e2(:,i));  %s=temp array to hold subtracted values for each X Y pair, to dec. # calc   
end    
for i=1:b_num
   p(:,i)=s(:,i)/(BETA(i)*0.001);%creating the partial derivative for each y and beta      
end   
Z=p;%needed if SSE in mod 6 
for i=1:b_num
   if ll==0
      G(i)=sum(-p(:,i));%gradient vector for log-likelihood
   else
      G(i)=sum((p(:,i).*e1));%gradient vector determining the next step, array multiplication is used and not matrix multiplication
   end   
end
for i=1:b_num
   for j=1:b_num
      A(i,j)=sum(p(:,i).*p(:,j));%variance-covariance vector
    end
end
disp('calling mod2')
mod2_ALLOMETRY(b_num,ydat,xdat,ll);
return
