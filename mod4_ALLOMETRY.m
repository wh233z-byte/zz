%debugged 990622 gives correct values for SSE and LL

function mod4_ALLOMETRY(b_num,ydat,xdat,q,p,ll)%qonly needed for recursive call to mod3
global L BETA G SO A CONV T1 T2 FINALBETA 

crash=isnan(BETA(1));%checks if BETA is NaN, if so it gives crash=1, otherwise crash=0

if T1<0
   disp(['print results']);
   mod5_ALLOMETRY(b_num,ydat,xdat,ll);
elseif T1<=T2 | crash==1%you're out of iterations or prograaams has chrashed
   crash
   tt2=num2str(T2);
   disp(['Iteration number: ' , tt2]);
   T1=T1-1;
   L=0;
elseif abs(p./BETA)< CONV %if any is larger than conv do another interation
      disp(['CONVERGENCE']);
      T1=-1;
      L=0;
      mod1_ALLOMETRY(b_num,ydat,xdat,ll);
else    
   BETA=BETA+p%modify BETA(parameters) by adding their partial derivatives
   %if BETA(1)<1.5
    %  BETA(1)=abs(BETA(1));
   %end
      BETA
   disp('inside mod4')
   e=E_ALLOMETRY(ydat,xdat,ll);%E should return the error for each X Y pair, i.e. no for loop necessary
   if ll==0
      s1=sum(-e);
      ss1=num2str(-s1);
      disp(['Log-likelihood for next B= ' , ss1]);
   else   
      s1=sum(e.^2);%summing up the squared errors
      ss1=num2str(s1); %changed to positive from negative
      disp(['SSE for next B= ' , ss1]);
   end   
   if s1>SO
      L=L*10;
      BETA=BETA-p;%the estimate was worse and L is incremented by then, BETA is modified back to its 
      %original value and module 3 is called again, this is not counted as an iteration
      mod3_ALLOMETRY(b_num,ydat,xdat,q,ll);%Recursive call to mod3
   else
      L=L/10;
      mod1_ALLOMETRY(b_num,ydat,xdat,ll);%call mod1 again and start over from scratch, i.e new iteration
   end
end
return
       
       