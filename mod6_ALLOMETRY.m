%This module is a copy of the subroutine in Bailey and Homer 1976
%Not working and needs debugging, does not produce the correct output
%debugged 990818
function y=mod6_ALLOMETRY(b_num,ydat,xdat,df,ll)
global A Z N BETA%Z is a matrix containing the partial derivative p() from mod1
T=1/(df);
T=1.96+T*(2.3724+T*(2.8227+T*(2.5561+T*1.5897)));
if df<=1.1
   T=12.706
end
V1=zeros(N,1);
VYHAT=zeros(N,1);
disp(['YHAT, SEYHAT,  YTOP95,  YBOT95']);
%Zis the partial derivative from mod1=saves calculations if lots of data
yones=ones(length(xdat),1);
p=zeros(N,b_num); %partial derivative in module 2 is by size= [N,b_num]
e1=E(yones,xdat); %function call to get error vector or LL also F in the NMRI programs
for i=1:b_num
      BETA(i)=BETA(i)*1.001;%BETA gets changed temporarily
      e2(:,i)=E(yones,xdat); %e2 is the new error term to be compared to E1  
      BETA(i)=BETA(i)/1.001;%Beta gets changed back
      s(:,i)=(e1-e2(:,i));  %s=temp array to hold subtracted values for each X Y pair, to dec. # calc   
end 
for i=1:b_num
   p(:,i)=s(:,i)/(BETA(i)*0.001);%creating the partial derivative for each y and beta      
end  
for q=1:N
   for i=1:b_num
      for j=1:b_num
         V1(q)=V1(q)+(p(q,i).*p(q,j).*A(i,j));%variance-covariance vector
      end
   end      
end
SEYHAT=sqrt(abs(V1)); %the seyhat of the estimate
YHAT=exp(e1);    %for LL estimation
err_maxmin=T*SEYHAT;
YMIN=max(0,exp(e1-err_maxmin));
YMAX=min(1,exp(e1+err_maxmin));

%needs debugging 990622
%ymin = min(ydat);
%ymax = max(ydat);

%yrange = ymax - ymin;

%yplotmin = ymin - 0.05*yrange;
%yplotmax = ymax + 0.05*yrange;


plot(xdat,YHAT,'b:p',xdat,YMIN,'c-',xdat,YMAX,'m+')
y=[xdat YHAT YMIN YMAX];

return


