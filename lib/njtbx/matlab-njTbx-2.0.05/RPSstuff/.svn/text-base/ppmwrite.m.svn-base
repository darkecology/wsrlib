function [X,map]=ppmwrite(ppmfile,style)

%  PPMWRITE writes the current figure in PPM format.
%
%    Usage:  ppmwrite(file)
%       or   ppmwrite(file,style)
%       or   [X,map]=ppmwrite(file)
%
%     file  = string containing name of output file (e.g. 'out.ppm')
%     style = index controling B/W swapping and transparent color
%
%                Swap Black and White   
%                --------------------   
%       style=1        no               
%       style=2        yes              
%
%  Rich Signell (rsignell@usgs.gov)

% this module attempts to correct for strange behavior of "capture",
% therefore it assumes:
% - X is returned with an extra column and row. 
% - the last row of X has a strange color index
% - the background color is the 2nd row in the colormap
% - the opposite color of background is in the 3rd row of the colormap
%
%
%  Rich Signell rsignell@usgs.gov
%
[X,map]=capture;
[m,n]=size(X);
X(:,1)=[];      % delete extra column
X(m,:)=[];      % delete extra row
X(m-1,:)=X(m-2,:);  %copy last row from next to last row 
if(exist('style')~=1),
   style=1;
end
if(style==2),
 map([2 3],:)=map([3 2],:);  % swap black and white
end
writeppm(X,map,ppmfile)
