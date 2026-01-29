function y=AB_HAZARD_INT1_ALLOMETRY(ydat,xdat,BETA)%the function which returns the error
global npars DIVELOG  TAUH2 TAUHE TAUN2 Q II DUMMY_DOSE CC%needed for GET_FUNCTION, i.e. to supply the number of parameters
DUMMY_DOSE=zeros(length(xdat), 1);%dummy holder for looking at changes in P(DCS) during decompression
CC=1;%dummy counter
if (ydat==0 & xdat==0 & BETA==1e-10)
   npars = 3;%;%B1=H2 B2=He B3=N2 B=gain is to be estimated as part of dose
   y=0;
   return
   
else
    n=0;%BETA(3); %if not using n, ; out line 26 in GET_DOSE_ALLOMETRY 
    thr=BETA(3);%if not using Thr set line27 to 0 in GET_DOSE_ALLOMETRY
    
   dose1=BETA(2).*GET_DOSE_ALLOMETRY(DIVELOG,ydat,xdat,BETA(1),n,thr);%BETA(uuu) is a gain factor?
   %dose2=BETA(4).*GET_DOSE_ALLOMETRY(DIVELOG,ydat,xdat,BETA(3),n,thr);%last number is the scaling factor for the mass exponent
   %dose=exp(BETA(2)).*GET_DOSE_ALLOMETRY(DIVELOG,ydat,xdat,BETA);%BETA(uuu) is a gain factor?
  
   u=1;
   c=length(ydat);
   
   dose=(dose1);%+(dose2);%+BETA(7).*xdat(II,2);%+BETA(8).*xdat(II,3)+BETA(9).*xdat(II,4)+BETA(10).*xdat(II,5);
  %dose1=dose+BETA(7).*xdat(II,2);%+BETA(8).*xdat(II,3)+BETA(9).*xdat(II,4)+BETA(10).*xdat(II,5)
   %d=length(Q);
  % for i=1:c
      %new_dose_array(u)=dose1;
     new_dose_array=dose;
     save('dose', 'dose', '-ascii');
     %dose
     %keyboard
     % u=u+1;
   %end   
   for i=1:length(ydat)
      % n(i)=1.0-exp(-dose);% FOR NULL MODEL
      n(i)=1.0-exp(-new_dose_array(i));% a simple minded approach to see if we can justify the use of 2 tau
   end
   
   %n'
   %keyboard
   %save('DUMMY_DOSE','DUMMY_DOSE','-ascii')
   y=n';
end   
return