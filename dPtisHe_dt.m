%this is the function to call by ODE45 also include
%global variables for BETA, Pamb, Tau, and A(bugrate)
%this is the equation for the tissue tension
function dPtisHe= dPtisHe_dt(count,PHetis,deltat)
global DIVELOG MY TAUN2 TAUHE%MY_f is a scalar and different than MY(an array of change of rates)
myHe=MY(count,2);%the change in PambHe pressure
%t1=DIVELOG(count,1)%time n
%t0=DIVELOG(count-1,1)%time n-1
%deltat=(DIVELOG(count,1)-DIVELOG(count-1,1));
pambHe=DIVELOG(count-1,4);%Pamb=partial pressure of H2=driving pressure for H2

%TAU=40;%define tau as one of the BETA's
%dPtis=MY*(t(n)-t(n-1))+(Pamb(t(n-1))-MY*Tau-Ptis(t(n-1))*[1-exp(-((t(n)-t(n-1))/Tau)]+Ptis(t(n-1))
dPtisHe=myHe*deltat+(pambHe-myHe*TAUHE-PHetis)*(1-exp(-deltat/TAUHE))+PHetis;%for H2 the equation needs to take into consideration the bugrate
 
%dPtisN2=myN2*deltat+(pambN2-myN2*TAUN2-PN2tis)*(1-exp(-deltat/TAUN2))+PN2tis;%for H2 the equation needs to take into consideration the bugrate 
return