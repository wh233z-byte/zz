%NOT WORKING 991019
%This module is a modification of the subroutine in Bailey and Homer 1976
%This is a new idea where instead of taking each data point
%I create a data array of values to compute the yhat, ymin, and ymax
%LL and SSE =works fine 
function y=mod8_ALLOMETRY(b_num,ydat,xdat,df,ll)
global A N Z BETA DIVELOG%Z is a matrix containing the partial derivative p() from mod1
T=1/(df);
T=1.96+T*(2.3724+T*(2.8227+T*(2.5561+T*1.5897)));
if df<=1.1
   T=12.706
end
xdat=GET_DOSE_3(DIVELOG,ydat,xdat,BETA);%dummy to use dose as x-variable
xmin = min(xdat);               %gets minimum x
xmax = max(xdat);               %gets max x
%xrange = xmax - xmin;           %gets the range of values
%newx = linspace(xmin,xmax,xrange+1)'%creates a data array of values at each whole number from xmin to xmax in order
newx = linspace(xmin,xmax,100+1)';%creates a data array of values at each whole number from xmin to xmax in order

%++++++++++++++++++++++++++++BEGIN IF ELSE+++++++++++++++++++
if ll==0%if LL=set all outcome to 1 and reestimate partials based on this
   V1=zeros(length(newx),1);%initializing
   YHAT=zeros(length(newx),1);%initializing
   yones=ones(length(newx),1);%creates an array with all ones for use in making conf. region
   p=zeros(length(newx),b_num); %partial derivative in module 2 is by size= [N,b_num]
   e1=E(yones,newx,ll); %function call to get error vector or LL also F in the NMRI programs
   for i=1:b_num
      BETA(i)=BETA(i)*1.001;%BETA gets changed temporarily
      e2(:,i)=E(yones,newx,ll); %e2 is the new error term to be compared to E1  
      BETA(i)=BETA(i)/1.001;%Beta gets changed back
      s(:,i)=(e1-e2(:,i));  %s=temp array to hold subtracted values for each X Y pair, to dec. # calc   
   end 
   for i=1:b_num
      p(:,i)=s(:,i)/(BETA(i)*0.001);%creating the partial derivative for each y and beta      
   end  
   for q=1:length(newx)
      for i=1:b_num
         for j=1:b_num
            V1(q)=V1(q)+(p(q,i).*p(q,j).*A(i,j));%variance-covariance vector
         end
      end      
   end
   SEYHAT=sqrt(abs(V1)); %the seyhat of the estimate
%if ll==0
   YHAT=exp(e1);    %for LL estimation
   err_maxmin=T*SEYHAT;%for LL estimation
   YMIN=max(0,exp(e1-err_maxmin));%The lower end of the 95%CL region
   YMAX=min(1,exp(e1+err_maxmin));%The upper end of the 95%CL region  
%end IF   
else %if the estimate is continuous variables and uses SSE estimation
   V1=zeros(length(xdat),1);%initializing
   YHAT=zeros(length(xdat),1);%initializing
   e1=E(ydat,xdat,ll); %function call to get error vector or LL also F in the NMRI programs
   for q=1:length(xdat)
      for i=1:b_num
         for j=1:b_num
           V1(q)=V1(q)+(Z(q,i).*Z(q,j).*A(i,j));%variance-covariance vector, uses Z vector from mod1
         end
      end      
   end
   SEYHAT=sqrt(abs(V1)); %the seyhat of the estimate
   YHAT=ydat-e1;  %as defined in Bailey and Homer 
   YMAX=YHAT+T*SEYHAT; %for SSE estimation
   YMIN=YHAT-T*SEYHAT;
end
%+++++++++++++++++END IF ELSE STATEMENT++++++++++++++++++++++++++

plot(newx,YHAT,'b:p',newx,YMIN,'c-',newx,YMAX,'c-')
disp(['X   YHAT,         SEYHAT,    YMAX,     YMIN'])
u=[newx, YHAT, SEYHAT, YMAX, YMIN];
u=num2str(u);
disp(u)
y=u;%return data to marquardt 
return


