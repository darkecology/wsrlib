function result=nj_info(ncRef)
%NJ_INFO - Get detail info about dataset.
%
% Usage:
%   info=nj_info(ncRef);
% where,
%   ncRef - Reference to netcdf file. It can be either of two
%           a. local file name or a URL (OpenDAP, ncml) or
%           b. An 'mDataset' matlab object, which is the reference to already
%              open netcdf file.
%              [ncRef=mDataset(uri)]
% returns,      
%   info - text info
%
% e.g.:
%  ncRef='http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/test/bora_feb.nc';
%  info=nj_info(ncRef);
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.

result = [];
if nargin < 1, help(mfilename), return, end
isNcRef=0;

try
    if (isa(ncRef, 'mDataset')) %check for mDataset Object
        nc = ncRef;
        isNcRef=1;
    else
        % open CF-compliant NetCDF File as a Common Data Model (CDM) "Grid Dataset"
        nc = mDataset(ncRef);         
    end
    switch nargin
        case 1       
            result=nc.getInfo;   
         otherwise, error('MATLAB:nj_info:Nargin',...
                    'Incorrect number of arguments');         
    end
    %cleanup only if we know mDataset object is for single use.
    if (~isNcRef)
        nc.close();
        clear nc;
    end
    
catch 
    %gets the last error generated 
    err = lasterror();    
    disp(err.message); 
end


