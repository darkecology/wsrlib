function [ mstruct ] = matlab_narr_proj( )
%MATLAB_NARR_PROJ Get NARR projection parameters in MATLAB mstruct format
%
% This is suitable for use with MATLAB Mapping Toolbox functions
%   mfwdtrans: from lat,lon --> x,y
%   minvtrans: from x,y --> lat, lon
%
% E.g:
%
%    mstruct = matlab_narr_proj();
%    [x,y] = mfwdtran(mstruct, lat, lon);
%    [lat, lon] = minvtran(mstruct, x, y);

mstruct = defaultm('lambert');
mstruct.mapparallels = [50 50];
mstruct.origin = [0 -107 0];
mstruct = defaultm(mstruct);

end

