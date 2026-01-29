%This function asks the user for the file containing the dive data
function y=GET_ALLOMETRY_DIVE_DATA
global MY N DIVELOG %DIVELOG is global and used by other functions to call
N
%n=N;
%N=3;%debugging erase eafterwards
MY=0;%Change in partial pressure of MY(:,1)= He,and MY(:,2)=H2 MY(:,3)=N2, this is a remnant from the old H2 biochemical decompression but I only used H2 and He in that so data file needs an additional column for N2
%the chosen function, contains the anme of the function and its destination
% select model
disp('Please provide the name of the data array of the dive profile.');
[filename,pathname]=uigetfile('*.csv');%gives the name of file and path
disp(['Data file name for dive data: ' filename]);%displays the file name chosen
fullfilename=[pathname filename];
DIVELOG=dlmread(fullfilename,',');%reads the data array data col1:time, col2:Pamb, col3:PHe, col4:PH2, col5:PN2, col6:3 is a marker for end of decompression
%%%%Getting the MY array=change in pressure, i.e. compression decompresson%%%%
count=0;
for i=1:N %for each observation
   count=count+1;
   if (count~=1)
      MY(count,1)=0;%these should line up with the end of obs in DIVELOG
      MY(count,2)=0;
      MY(count,3)=0; %for N2
  end   
   while DIVELOG(count,1)>=0
      if (count==1)%first observation my =0
         MY(count,1)=0;  
         MY(count,2)=0;
         MY(count,3)=0;%for N2
      elseif DIVELOG(count,1)==-1|DIVELOG(count,1)==0%put zero in the observation separator column, i.e. where DIVELOG has -1
         MY(count,1)=0;        
         MY(count,2)=0;
         MY(count,3)=0; %For N2
      else   
         MY(count,1)=(DIVELOG(count,3)-DIVELOG(count-1,3))/(DIVELOG(count,1)-DIVELOG(count-1,1));%gets rate of compr/decomp  
         MY(count,2)=(DIVELOG(count,4)-DIVELOG(count-1,4))/(DIVELOG(count,1)-DIVELOG(count-1,1));%gets rate of compr/decomp  
         MY(count,3)=(DIVELOG(count,5)-DIVELOG(count-1,5))/(DIVELOG(count,1)-DIVELOG(count-1,1));%N2gets rate of compr/decomp  
      end%checks so last reading doesn't include 1   
      count=count+1; %continue to next node  
   end        
end 
MY(count,1)=-9; %signifies EOF
MY(count,2)=-9; %signifies EOF
MY(count,3)=-9; %For N2
%y=[DIVELOG MY];
y=DIVELOG;%returns s, i.e. the whole data array
return