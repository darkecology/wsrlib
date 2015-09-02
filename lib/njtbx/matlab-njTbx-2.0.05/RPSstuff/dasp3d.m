function xfac=dasp3d(lat,xvert)
% DASP3D sets data aspect ratio to 1
% or if optional lat is supplied, crude projection
% Usage: xfac=dasp(lat); 
% where: lat = latitude in degrees
% xfac : the ratio lon/lat
if(nargin==2),
   if (isnan(lat)),
      set(gca,'DataAspectRatioMode','auto');
   else
      xfac=cos(lat*pi/180);
      set (gca, 'DataAspectRatio', [1 xfac 111111/xvert] );
   end
else
   set (gca, 'DataAspectRatio', [1 1 1] );
end
