function degstring=degmins(degrees,ndigit);
% DEGMINS Creates a degrees and minutes label for use in MAPAX routine.
%
% Usage:  degstring=degmins(degrees,ndigit);
%
%    Inputs:  degrees = decimal degrees
%             ndigit  = number of decimal places for minutes
%
%    Outputs: degstring = string containing label
% Version 1.0 Rocky Geyer (rgeyer@whoi.edu)
% Version 1.1 J.List (jlist@usgs.gov)
%             fixed bug
% Version 1.2 W. Sheldon (wsheldon@wiegert.marsci.uga.edu) corrected
%   rounding errors when fractional minutes specified, and added
%   support for precision beyond 2 decimal places
%
% Version 1.3 R. Signell (rsignell@usgs.gov) use 2.2d format 
%   for minutes with no decimal places so that labels line up
% 
degrees=degrees(:);

for i=1:length(degrees);

   if degrees(i)<0
     degrees(i)=-degrees(i);
   end

   deg(i,1)=floor(degrees(i));
   deg(i,2)=(degrees(i)-deg(i,1))*60;
   if ndigit==0;
     degstring(i,:)=sprintf('%3d%s%2.2d%s',deg(i,1),...
                    setstr(176),round(deg(i,2)),'''');
   else
     %modified by W. Sheldon to handle fractional minutes at any precision
     format_str = ['%3d%s%' num2str(ndigit+3) '.' num2str(ndigit) 'f%s'];
     degstring(i,:)=sprintf(format_str,deg(i,1),...
                    setstr(176),round(deg(i,2)*10^ndigit)/10^ndigit,'''');
   end
   
end

