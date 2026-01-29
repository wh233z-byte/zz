%this function uses the trapezoid rule to estimate an
%integral. From Cheney Numerical mathematics and computation
%p.197. This is slightly modified but follows the general
%trapezoid rule
function r=INTEGRATE_ALL_RISK_ALLOMETRY(PH2tis,PHetis,PN2tis, t0,t1,count,pambH2, pambHe,pambN2,pamb,Thr)
global DIVELOG MY BETA DUMMY_DOSE CC
%Thr is threshold which is passed as a parameter
%Thr=exp(BETA(4));
%PH2tis and PHetis are Ptis at count, tempH2 and tempH3 are ptis at count-1
deltat=t1-t0;
cross_over_flag=0;%initially set to 0, set to 1 for upper cross over, i.e. if f_of_a=negative, 
cross_over_end_flag=0;%set to 1 if lower crossover i.e. f_of_b=negative Ptis<Pamb occurs during the interval
%if both cross over are negative and my_pamb=0 no cross over will occur, thus no integration necessary set sum=0 and return

%h=0.09;%set h=0.04, thus it will be equal for all deltat
%n=(t1-t0)/h;%n set to 120 for default, error analysis showed
if deltat>60 %for long interval check deltat 600 times
    n=20000;
   h=(t1-t0)/n;%dividing the interval[t0,t1] into n subdivisions
else
   h=0.09;%set h=0.04, thus it will be equal for all deltat
   n=(t1-t0)/h;%n set to 120 for default, error analysis showed that the error is minimal at this large n
   
end   
sum=0;
%dividing the interval[t0,t1] into n subdivisions
PAMB=pamb;%DIVELOG(count-1,2); %ambient pressure at start node
my_pamb=(DIVELOG(count,2)-DIVELOG(count-1,2))/(DIVELOG(count,1)-DIVELOG(count-1,1));
f_of_a=(0+0+PN2tis-PAMB-Thr)/PAMB;
%f_of_a=(PH2tis+PHetis+PN2tis-PAMB-Thr)/PAMB;%the result of f(x) at start
temppambH2=0;%DIVELOG(count-1,3);%to adjust for the time when crossover occurs
temppambHe=0;%DIVELOG(count-1,4);%newnewenwewn
temppambN2=DIVELOG(count-1,5);
DIVELOG(count-1,3)=0;%pambH2;
DIVELOG(count-1,4)=0;%pambHe;%newnewnewnew
DIVELOG(count-1,5)=pambN2;%newnewnewnew

%dPtisH2_dt(count,PH2tis,deltat)+dPtisHe_dt(count,PHetis,deltat)
f_of_b=(0+dPtisN2_dt(count,PN2tis,deltat)-(PAMB+my_pamb*deltat)-Thr)/(PAMB+my_pamb*deltat);%make sure Pamb is ambient N2 pressure as O2 is not included
%f_of_b=(dPtisH2_dt(count,PH2tis,deltat)+dPtisHe_dt(count,PHetis,deltat)+dPtisN2_dt(count,PN2tis,deltat)-(PAMB+my_pamb*deltat)-Thr)/(PAMB+my_pamb*deltat);

pambH2=0;%pambH2;%pambH2 is the adjustedDIVELOG(count-1,4);%the tissue tension at time t0
pambHe=0;%pambHe;%pambHe is the adjustedDIVELOG(count-1,3);%the tissue tension at time t0
pambN2=pambN2;
if f_of_a<0 %when Ptis < Pamb
   f_of_a=0;
   cross_over_flag=1;%ptis<pamb at start of interval
end
if f_of_b<0
   f_of_b=0;
   cross_over_end_flag=1;%ptis<pamb at end of interval
end
%%%%%%%%%%%%%June 15, 2009, this must be some error control as it looks for
%%%%%%%%%%%%%Ptis<Pamb at the start and end of interval and that there is
%%%%%%%%%%%%%no pressure change. This may have to be change in case if
%%%%%%%%%%%%%there is a pressure change inside the node
if cross_over_flag==1 & cross_over_end_flag==1 & my_pamb==0
   r=0;
   return
end
sum=1/2*(f_of_a+f_of_b);
DUMMY_DOSE(CC,1)=sum;
DUMMY_DOSE(CC,2)=PN2tis;

CC=CC+1;
tempPH2tis=0;%PH2tis;
tempPHetis=0;%PHetis;
tempPN2tis=PN2tis;
temppamb=PAMB;
initt=0;
for i=1:n-1
   t=initt+i*h;
   PH2tis= 0;%dPtisH2_dt(count,tempPH2tis,t);%updates tissue PH2 at time t, this can be set to zero for allometry as there is no H2
   PHetis= 0;%dPtisHe_dt(count,tempPHetis,t);%updates tissue PH2 at time t, this can be set to zero for allometry as there is no He
   PN2tis= dPtisN2_dt(count,tempPN2tis,t);
   PAMB=temppamb+my_pamb*t;
   DUMMY_DOSE(CC,2)=PN2tis;
   sum_temp=(PH2tis+PHetis+PN2tis-PAMB-Thr)/PAMB;
   if sum_temp<0 %Ptiss< Pamb no risk being collected
      sum=sum+0;
      DUMMY_DOSE(CC)=sum;
   else
      sum=sum+sum_temp;%add only when Ptis>Pamb
      DUMMY_DOSE(CC)=sum;
   end
 
   CC=CC+1;
end      
DIVELOG(count-1,3)=0;%temppambH2;%reset DIVELOG
DIVELOG(count-1,4)=0;%temppambHe;
DIVELOG(count-1,5)=temppambN2;

sum=sum*h;


%temp
r=sum;%return only r=Ptis integrated from t0-t1
return