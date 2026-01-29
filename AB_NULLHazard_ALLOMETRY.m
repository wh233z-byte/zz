function y=AB_NULLHazard_ALLOMETRY(ydat,xdat,BETA)%the function which returns the error
global npars DIVELOG N%needed for GET_FUNCTION, i.e. to supply the number of parameters
if (ydat==0 & xdat==0 & BETA==1e-10)
   npars = 1;%B1=H2 B2=He B1 is to be estimated as part of dose
   y=0;
   return
else
dose=BETA(1).*ones(N,1);
save('dose', 'dose', '-ascii');
%dose
%dose=exp(BETA(2)).*GET_DOSE_5(DIVELOG,ydat,xdat,BETA);%gets the dose for all dive profiles and with the current Beta's
%dose=BETA(2).*dose+BETA(3).*delP;
for i=1:N
   n(i)=1.0-exp(-dose(i));% a simple minded approach to see if we can justify the use of 2 tau
end   
%e=exp(BETA(1));%for null model set npars=1 percent out b2 and e and run until convergence

%n=e./(1+e);%
y=n';
end   
return