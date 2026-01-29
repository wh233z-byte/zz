%This functionasks the user for the function to use.  the function
%supplied gives the program the number of parameters and asks the user
%for initial values
function y=GET_FUNCTION
global FUNCNAME %FUNCNAME is global and used by other functions to call
%the chosen function, contains the anme of the function and its destination
% select model
[funcfilename, pathname] = ...
uigetfile('AB_*.m','Select model function file');
FUNCNAME = strtok(funcfilename, '.');
%THE BELOW COMMAND IS HOW TO EVALUATE THE FUNCTION I.E. CALL FUNCNAME
%string = ['u=' funcname '(ydat,W,BETA);'];%creates a string to be used in eval
%eval(string);  %the driver to call the function
Z = [1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 ];   % dummy vector
string = ['dummy=' FUNCNAME '(0,0,Z);'];
eval(string);           % dummy call to funcc to get npars
clear Z;
global npars      
global BETA  
for i = 1:npars%get intial betas from user
   num_param = int2str(i);
   ask_value = ['Enter initial value for beta(' num_param '): '];
   BETA(i) = input(ask_value);
end   
y=npars;
return