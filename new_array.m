%Reshapes the array so that there will be one column for the dependent
%variable Y and the independent variables X according to how many
%independent variables there are i.e. N2
function y= new_array(W,N2)
v=0; %coounter in the for loop
col=N2+1; %col gets total number of columns
row=length(W)/col;%this is the number of data points in each column, i.e. rows 
for i=1:row
   for k=1:col
      v=v+1; 
      temp(i,k)=W(v);
   end
end
y=temp;   %returns the reshaped matrix with Y in the first column and then the x'es
return