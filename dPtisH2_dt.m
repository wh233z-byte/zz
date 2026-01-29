%this is the function to call by ODE45 also include
%global variables for BETA, Pamb, Tau, and A(bugrate)
%this is the equation for the tissue tension
function dPtisH2= dPtisH2_dt(count,PH2tis,deltat)
global DIVELOG MY BETA  TAUH2 II%MY_f is a scalar and different than MY(an array of change of rates)
%bug=0;%used when only control data w/o ch4 is to be tested 


myH2=MY(count,1);%the change in PambH2 pressure
%t1=DIVELOG(count,1)%time n
%t0=DIVELOG(count-1,1)%time n-1
%deltat=(DIVELOG(count,1)-DIVELOG(count-1,1));
pambH2=DIVELOG(count-1,3);%Pamb=partial pressure of H2=driving pressure for H2
%TAU=40;%define tau as one of the BETA's
%dPtis=MY*(t(n)-t(n-1))+(Pamb(t(n-1))-MY*Tau-Ptis(t(n-1))*[1-exp(-((t(n)-t(n-1))/Tau)]+Ptis(t(n-1))
%tautemp=TAUH2+bug;
dPtisH2t=myH2*deltat+(pambH2-myH2*TAUH2-PH2tis)*(1-exp(-deltat/TAUH2))+PH2tis;%for H2 the equation needs to take into consideration the bugrate

if dPtisH2t<0
   dPtisH2=0;
else
   dPtisH2=dPtisH2t;
end
%dPtisH2

return