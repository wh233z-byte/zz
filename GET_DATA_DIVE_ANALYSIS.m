%This function asks the user for the data array and inputs it into an array
function y=GET_DATA %holds the variables 
disp('Please provide the name of for the array of outcome data.');
[filename,pathname]=uigetfile('*.txt','Outcome Data File Name');%gives the name of file and path
disp(['Data file name: ' filename]);%displays the file name chosen
fullfilename=[pathname filename];
in = fopen(fullfilename,'rt');%fopen(filename,permission), rt=rad and write a txt file
s = fscanf(in,'%f');%reads the entire file into an array, file needs to have the y and x variables column wise
                       %i.e.Y, X(1), X(2), X(3), ...X(N2) etc 
y=s;%returns s, i.e. the whole data array
fclose(in); %closes data file
return
                       