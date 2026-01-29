function savedata1(u)
%creating a filename as date-time to save data
%not working
global A
timearray = clock;
month = int2str(timearray(2));
   if length(month)<2
      month = ['0' month];
   end
day = int2str(timearray(3));
   if length(day)<2
      day = ['0' day];
   end
hour = int2str(timearray(4));
   if length(hour)<2
      hour = ['0' hour];
   end
minute = int2str(timearray(5));
   if length(minute)<2
      minute = ['0' minute];
   end
u=u';
filename = [month day '-' hour minute '.csv'];
file=num2str(filename);
fid = fopen(file,'w');
fprintf(fid, 'log-like BETA  std.error  coeff.of var\n')
%fprintf(fid, 'YHAT SEYHAT        YMAX          YMIN\n');
%fprintf(fid,'%2.0f %12.8f %12.8f %12.8f\n',u);
fprintf(fid,' %12.8f  %12.8f %12.8f %12.8f \n',u);
fprintf(fid,'%12.8f\n',A);
fclose(fid);
return
   


