function [w,jd] = getvel(cdf,uvar,vvar,start,stop)
%  GETVEL Gets time-series vector data from an EPIC style netcdf file,
%         allowing the user to grab the whole time-series, or
%         specify start and stop time.
%
%   USAGE:
%       [w,jd] = getvel(cdf,uvar,vvar);  % gets whole series
% or
%       [w,jd] = getvel(cdf,var,start,stop);
%
%        
if(nargin<5),
 [u,jd]=getts(cdf,uvar);
 [v,jd]=getts(cdf,vvar);
else
 [u,jd]=getts(cdf,uvar,start,stop);
 [v,jd]=getts(cdf,vvar,start,stop);
end
w=u(:)+sqrt(-1)*v(:);
