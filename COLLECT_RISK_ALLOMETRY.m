%modified collect risk function  
function [r,flagH2, flagHe, flagN2]= COLLECT_RISK_ALLOMETRY(tempH2,tempHe,tempN2, ptisH2, ptisHe, ptisN2, count,r,flagH2, flagHe, flagN2,thr)

%tempH2 tempHe and tempN2 are Ptis at count-1

global BETA DIVELOG MY
myH2=0;%MY(count,1);%set H2 and He to 0 for allometry we are only doing air dives
myHe=0;%MY(count,2);
myN2=MY(count,3);
pambH2=0;%DIVELOG(count-1,3);
pambHe=0;%DIVELOG(count-1,4);
pambN2=DIVELOG(count-1,5);
my_pamb=(DIVELOG(count,2)-DIVELOG(count-1,2))/(DIVELOG(count,1)-DIVELOG(count-1,1));
pamb=DIVELOG(count-1,2);
t0=DIVELOG(count-1,1);
t1=DIVELOG(count, 1);
%we will consider risk to be the integrated tissue tension minus the ambient 
%pressure of the inert gases, i.e. wwill not consider the absolut pressure
%Thus O2 will not be considered and N2 be assumed negligible
deltat=t1-t0;%the deltat
%pamb=pambHe+pambH2;%ambient pressure of the inert gases
%ptis=ptisH2+ptisHe;%tissue gas tension of inert gases
%my=myHe+myH2;%collected decompression rate for the two inert gase
%for integration tempH2 and tempHe are Ptis at count, while ptisH2 and ptisHe are the "updated" ptis at t=DIVELOG(1,count)+tcross

temp_r=INTEGRATE_ALL_RISK_ALLOMETRY(tempH2,tempHe,tempN2, t0,t1,count,pambH2,pambHe,pambN2,pamb,thr);%H2 and He removed
%temp_r=INTEGRATE_ALL_RISK_ALLOMETRY(tempH2,tempHe,tempN2, t0,t1,count,pambH2,pambHe,pambN2,pamb);
  

if temp_r<0
   temp_r=0;
end   
r=temp_r+r;%sum all risk
return
