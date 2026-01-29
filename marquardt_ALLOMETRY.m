function marquardt_ALLOMETRY()
% marquardt.m
% fits data by function specified in AB_funcname(ydat,xdat,BETA)
% uses the marquardt procedure 
% The program is created to allow the use for mixed gas (heliox and air)
% there is a H2 in the program which is a remnant from the old biochecmical
% decompression program and it can be used for O2. Column order for all
% gases are H2, He and N2, either the H2 or H2 can be used for O2 if needed
% or else H2 and He can probably be zerod out to allow faster completion of
% the program but that needs to be tested.

%Pamb needs to be either the ambient pressure for the inert gas or else the
%sum of all gases used

clear all;

   format long;
set(0,'RecursionLimit',2000)
   % read data from text file
   % input file has records of format {Y,X(1), X(2),...X(k)
   %we only allow one independent variable to begin with
   %We've defined arrays and vectors that will change and which needs
   %to be accesed through the whole program as global variables, while
   %the other variables that must not be changed are passed to each function
   global A B G Z FUNCNAME DIVELOG  TAUH2 TAUHE TAUN2 ACT%Matrices to be used 
   %T1=#iterations, N=#of data points, BETA=starting beta, N2=# of independent variables
   global SO N BETA N2 L CONV T1 T2 
   global DUMMYBETA %holds last BETA values and LL
   %OPTIONS 
   %OPTIONS=odeset('RelTol',1e-1,'AbsTol',[1e-6]);

   %global funcname npars %the name of the function to be used and the # of parameters
   %%%%%%%%%%%%%%%%%%%%%%INITILIZATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   SO=0;   %initializing the standard error
   %ll=0;%If the function is using log-likelihood ll==0 least squares ll==1
   %These need to be either input from data file or supplied by user
   T1 = 1;%input('Enter the number of iterations? ');
   N2 = 5;%input('Enter the number of independent variables? '); %time of DCS, body mass, %if not entered correctly you may get an error in the e (error0 calculation as it mistakes log-likelihood for SSE
   L = 1;%input('Enter the starting Lambda? ');
   CONV = 0.1;%input('Enter the convergence criterion? ');
   T2 = 0;%actual number of iterations

 %%%%%%%%%%%%%%%%%%%%%%FUNCTION CALL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   s=GET_DATA;%gets the data array s that hold dependent and independent variables, y=DCS outcome 1/0, x1=body mass x2=species1 x3=species2 etc save as a txt file
   w = new_array(s,N2);  %the data array
   ydat=w(:,1);         %ydat gets Y-data DCS outcome 1=DCS 0= no DCS
  for i=1:N2; 
      xdat(:,i)=w(:,i+1);     %xdat gets x data
   end   
     %Q=GET_NUMBER_OF_SIMILAR_DIVES;%June 15, 2009, Not sure what this is
     %0
     %for??????
   N=length(ydat);
   
   DIVELOG=GET_ALLOMETRY_DIVE_DATA;%this gets the name of the dive data array column1: time, column2: Pamb col3:PN2 col4: PO2 col5: -3 is end of deco save this as a csv file
   b_num=GET_FUNCTION;%gets the function from the user and the number of parameters  
   ll=binary(ydat)%binary determines if ll=0 or 1
   A=zeros(b_num,b_num);%VARIANCE-COVARIANCE matrix init. to zeros for size of it
   G=zeros(b_num,1);%gradient vector initialized
   %inBETA=[1 0.06 0.5] 
   inBETA=[0.86] %no dog model A
   %inBETA=[0.5 0.1 0.97 1.21 370 0.02 -1] %no dog model 5
   %inBETA=[106 0.0079 0.37 -0.068 0.053 16.3] %no dog model C
   %inBE0.35TA=[0.27 1.19 0.75 -0.87 227 0.012] %no dog model R-8
   %inBETA=[0.27 1.19 0.75 -0.87 227 0.012] %no dog model R-8 modified
   
  % inBETA=[0.001 0.01 0.01 -1 0.5 0.01 -1 -1 -1 -1] 
   %set(0,'RecursionLimit',2000);
   for it=1:1 % do to 6exp(tau1
      % for dt=1:1 %exp(gain1
        %for zt=1:1%thr
              %for qt=1:1%n
                  %for gt=1:1%%exp(tau
                     % for ut=1:1%exp(gain 2)
                         % for kt=1:1
                              %for ft=1:3
                               %   for vt=0:2
                                %      for ht=0:2
                          %for opo=1:4%exp(thr2
                L=1.0; %reset starting lambda
                A=zeros(b_num,b_num);%VARIANCE-COVARIANCE matrix init. to zeros for size of it
                G=zeros(b_num,1);%gradient vector initialized
                SO=0;
                T2=0;
                T1=100;
it
%dt
%zt
%qt
%gt
%ut
%kt
%ft
%vt
%

%opo
     BETA(1)=(inBETA(1));%*10^it; %tau1%no pig
     %BETA(2)=(inBETA(2));%*10^dt;%gain1
     %BETA(3)=(inBETA(3));%+zt;%n
     %BETA(4)=(inBETA(4));%*10^qt;%thr1
     %BETA(5)=(inBETA(5));%*10^gt;%+gt*4);%tau2
    %BETA(6)=(inBETA(6));%*10^ut;%Gain2
 
    %BETA(7)=inBETA(7)*10^kt;%+opo*3;
     %BETA(8)=inBETA(8)*10^ft;
    % BETA(9)=inBETA(9)+vt;
%BETA(10)=inBETA(10)+ht
    
                mod1_ALLOMETRY(b_num,ydat,xdat,ll);%begin parameter search mod1-mod5
      
      %u=[BETA  iteration T2]
  
      %u=mod8_8(b_num,ydat,xdat,N-b_num,ll);%get confidence region and return conf. region data
      %mod5_5(b_num,0,0,ll)
      %savedata(u);%save data to date and time
                  end
           %   end
         %  end
      %end
       %end
      % end
            %      end
             % end
  %      end
 %      end
   
  return

   