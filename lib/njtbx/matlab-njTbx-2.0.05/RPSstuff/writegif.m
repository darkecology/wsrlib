function [X,map]=writegif(file,style)
% 
%  WRITEGIF writes the current figure in GIF format
%   by writing PPM image, then shelling out to call ppmtogif.
%
%    Usage:  writegif(file)
%       or   writegif(file,style)
%       or   [X,map]=writegif(file)
%
%     file  = string containing name of output file (e.g. 'out.gif')
%     style = index controling B/W swapping and transparent color
%
%                Swap Black and White     Make Background Color Transparent
%                --------------------     ---------------------------------
%       style=1        no                     no
%       style=2        no                     yes
%       style=3        yes                    no
%       style=4        yes                    yes
%

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
%X(:,1)=[];      % delete extra column
%X(m,:)=[];      % delete extra row
%X(m-1,:)=X(m-2,:);  %copy last row from next to last row 
if(exist('style')~=1),
   style=1;
end
if(style==3|style==4),
 map([2 3],:)=map([3 2],:);  % swap black and white
end
ppmfile=[file '.ppm'];
writeppm(X,map,ppmfile)
%
if(style==2|style==4),
 arg=sprintf('rgbi:%3.3d/%3.3d/%3.3d ',map(2,:))
 cmd=['!ppmquant 256 '  ppmfile ' | ppmtogif -interlace -transparent '];
 cmd=[cmd  arg  ' > ' file] ;
else
 cmd=['!ppmquant 256 ' ppmfile ' | ppmtogif -interlace  > ' file];
end
eval(cmd) 
eval(['! rm ' ppmfile]);
