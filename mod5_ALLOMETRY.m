%the module calculating the final result and printing it
%debugged and working, just need to modify print statements
%990609 print statements modified
%debugged 990622 gives correct values for SSE and LL

function mod5_ALLOMETRY(b_num,ydat,xdat,ll)%not needed t1 t2 l
global BETA SO N A FINAL_RESULTS DIVELOG
df = length(ydat)-b_num;%the degrees of freedom
if ll==0
   V=1;%for the log-like case
   so=num2str(-SO);
   disp(['Final log-likelihood=   ',so]);
   %%%%%%%%%%%%%%%%TEMP%%%%%%%%%%%%%%%
   %dose=exp(BETA(1)).*GET_DOSE_5_4(DIVELOG,ydat,xdat,BETA)%gets the dose for all dive profiles and with the current Beta's
   %dose=dose%(:,1);%+dose(:,2)

   %for i=1:N
   %   n(i)=1.0-exp(-dose(i));% a simple minded approach to see if we can justify the use of 2 tau
   %end   
  %n'
  %%%%%%%%%%%%%%%%%%TEMP%%%%%%%%%%%%%%%%%%   
else   
   V=SO./df;%summing up the squared errors, i.e. variance
   V1=sqrt(V);%stdev
   v=num2str(V);
   v1=num2str(V1);
   so=num2str(SO);
   disp(['Variance=   ',v]);
   disp(['Std.dev=    ',v1]);
   disp(['Final SSE=  ',so]); 
end   
C=inv(A);
A=V*C;        %Var-covar matrix
for i=1:b_num
   D(i)=sqrt(A(i,i));%D=std. error of parameter
end
D2=D./BETA; %coefficient of variation
b=num2str(BETA);
d=num2str(D);
d2=num2str(D2);
disp(['Parameters=                 ',b]);
disp(['Std. Error of Parameters=   ',d]);
disp(['Coeff of var=               ',d2])
disp(['Var-Covar matrix= ']);
disp(A)
u=[-SO BETA D D2];
savedata1(u);%to be able to get global variables to save when convergence has occured 

return