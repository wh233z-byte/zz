function y=GET_DOSE_ALLOMETRY(DIVELOG,ydat,xdat,betatau, n,thr)

global N MY  MY TAU TAUN2 II BUG ACT TAUN2TEMPALLOMETRY BETA%N=#observations, MY=rate of cahnge in partial pressure


%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%
%TAUH2temp=BETA(1);%These make sure that Beta(1) to Beta(3) are not dedicated to tau
%TAUHEtemp=BETA(1);%
%TAUN2temp=beta;
%TAUH2=(TAUH2temp);%June 15 2009, WHY ARE THESE TRANSFORMED HERE???????
%TAUHE=(TAUHEtemp);%these were exp(TAHUHetemp) before and I am not sure why?
%TAUN2=(TAUN2temp);

%get N+1 for count since we have -1 at first row
temp_divelog=DIVELOG; %a temp array to save the DIVELOG array which is manipulated during cross over search
count=0;
r=zeros(N,2);%initializing integrated risk array
dose=zeros(N,1);%initializing DOSE array         
pambsum=zeros(N,2);%integrated Pamb array
PH2tis=0;%DIVELOG(1,3);%tissue tension for any gas should be the surface equivalent, assumption is that animal is saturated at this pressure
PHetis=0;%DIVELOG(1,4);
PN2tis=DIVELOG(1,5);%
for i=1:N %for each observation
   II=i;%used in dPtis_H2_dt to keep track of variable array
   ntemp=n;%+BETA(7).*xdat(II,5);%+BETA(8).*xdat(II,3)+BETA(9).*xdat(II,4)+BETA(10).*xdat(II,5);%pig, dog, rat hamster
   TAUN2TEMPALLOMETRY=(betatau);%.*(xdat(II,1)^ntemp); %to scale tau for body mass as sTAU=TAU/MB^n
   thrtemp=thr;%+BETA(7).*xdat(II,5);%+BETA(8).*xdat(II,3);%+BETA(9).*xdat(II,4)+BETA(10).*xdat(II,5);
   count=count+1;
   flag1=0;%notifies when decompression has begun, i.e. when divelog(#,6)==3
   flagH2=0; %when =1 notifies first time Pamb<Ptis, =2 when switch back
   flagHe=0;
   flagN2=0;
   while DIVELOG(count,1)>=0%perform DOSE calculation at each node until -1=END OF DIVE or END of Decompression
      if (DIVELOG(count,6)==3)%3is the notification for start of decomp in the DIVELOG file
         flag1=1;%switch decompression to true
      end   
      %my is the rate of compression or decomp
      if (count==1) | (DIVELOG(count-1,1)==-1)%this is for the very first observation with no -1 falg in the above row, or first time in new observation
         PH2tis=0;%DIVELOG(1,3);%tissue tension for any gas should be the surface equivalent, assumption is that animal is saturated at this pressure
         PHetis=0;%DIVELOG(1,4);
         PN2tis=DIVELOG(1,5);%
      else   %DIVELOG(:,1)=time elapsed,DIVELOG(:,2)=Pamb,DIVELOG(:,3)=PHeamb, DIVELOG(:,4)=PH2amb, DIVELOG(:,5)=PN2amb, Divelog(#,6)=3 upon decompression
         if (flag1==1)%decompression do washout 
         
           %%%%%%%%%%%%%Washout-PtisH2%%%%%%%%%PH2tis & PHetis are set to 0
           %%%%%%%%%%%%%to reduce computation
            deltat=(DIVELOG(count,1)-DIVELOG(count-1,1));           
            tempH2=0;%PH2tis;%is the tissue pressure at count-1, i.e. old Ptis
            PH2tis=0;%dPtisH2_dt(count,PH2tis,deltat);            
           %%%%%%%%%%%%%Washout-PtisHe%%%%%%%%%%%%%           
            tempHe=0;%PHetis;%is the tissue pressure at count-1
            PHetis=0;%dPtisHe_dt(count,PHetis,deltat);  
            %%%%%%%%%%%%%Washout-PtisN2%%%%%%%%%%%%%           
            tempN2=PN2tis;%is the tissue pressure at count-1
            PN2tis=dPtisN2_dt(count,PN2tis,deltat);
            
            [r(i,1),flagH2, flagHe, flagN2]= COLLECT_RISK_ALLOMETRY(tempH2,tempHe,tempN2, PH2tis, PHetis, PN2tis, count,r(i,1),flagH2, flagHe, flagN2,thrtemp);   
            
         else  %if washin calculate PtisH2 and PthisHe but if 1 skip for calc delP==FASTER PRoCEDURE SKIPS WASHOUT AT DECOMP STOP =11ATM
            deltat=(DIVELOG(count,1)-DIVELOG(count-1,1));
     %%%%%%%%%%%%%Washin-PtisH2%%%%%%%%%%%%%         
            tempH2=0;%PH2tis;
            PH2tis= 0;%dPtisH2_dt(count,PH2tis,deltat);
     %%%%%%%%%%%%%Washin-PtisHe%%%%%%%%%%%%%    
            tempHe=0;%PHetis;
            PHetis=0;%dPtisHe_dt(count,PHetis,deltat);
     %%%%%%%%%%%%%Washin-PtisN2%%%%%%%%%%%%%    
            tempN2=PN2tis;
            PN2tis=dPtisN2_dt(count,PN2tis,deltat);
            %dose(count,1)=PH2tis+PHetis+PN2tis;
         end   
         
      end 
      count=count+1; %continue to next node  
   end   
end  

%dose
DIVELOG=temp_divelog;%re-establish original divelog since it's global
y=r(:,1);%return only 1st column
return