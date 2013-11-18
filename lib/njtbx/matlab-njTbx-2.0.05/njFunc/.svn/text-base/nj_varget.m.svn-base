function data=nj_varget(ncRef,var,start, count, stride)
% NJ_VARGET - get variable data from local NetCDF file, NetCDF URL or OpenDAP URL
%
% Usage:
%   data=nj_varget(file,var,start,count,stride);
% where,
%  ncRef - Reference to netcdf file. It can be either of two
%           a. local file name or a URL  or
%           b. An 'mDataset' matlab object, which is the reference to already
%              open netcdf file.
%              [ncRef=mDataset(uri)]
%  var  =  variable to extract%           
%  start = A 1-based array specifying the position in the file to begin reading or corner of a
%          hyperslab e.g [1 2 1]. Specify 'inf' for last index.
%          The values specified must not exceed the size of any
%          dimension of the data set.
%  count = A 1-based array specifying the length of each dimension to read. e.g [6 10 inf]. 
%          Specify 'inf' to get all the values from start index.
%  stride = A 1-based array specifying the interval between the
%           values to read. e.g [1 2 2] or empty []
% returns,
%   data - matlab array
% 
% e.g,       
%     Any of these URI types will work:
%     Local NetCDF:  ncRef='bora_feb.nc';
%     Remote NetCDF: urincRef='http://coast-enviro.er.usgs.gov/models/test/bora_feb.nc';
%     OpenDAP:       ncRef='http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/test/bora_feb.nc';
%     Local NcML:    ncRef='bora_feb.ncml';
%     Remote NcML:   ncRef='http://coast-enviro.er.usgs.gov/models/test/bora_feb.ncml';
%
%   Any of these syntaxes will return the surface temperature values
%   from the first time step: Assuming Array shape is [8,20,60,160]         
%           
%     Using 'start' 'count' 'stride' arrays to specify indexing%
%     t=nj_varget(ncRef,'temp',[1 1 1 1],[1 1 30 inf],[1 1 2 2]); % get surface temp from first time step 
%          
%     The following will return the entire longitude variable
%     t=nj_varget(ncRef,'lon');  % get all the lon values
%
%     NOTE: If using 'ncRef=mDataset(uri)' object as input to 'nj_varget' then 
%           call ncRef.close() after all calls to nj_varget or any other function 
%           to make sure netcdf dataset pointer is properly disposed.
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.

%initialize
data=[];
isNcRef=0;
if nargin < 2, help(mfilename), return, end

try 
   if (isa(ncRef, 'mDataset')) %check for JDataset Object
        nc = ncRef;
        isNcRef=1;
    else
        % open CF-compliant NetCDF File as a Common Data Model (CDM) "Grid Dataset"
        nc = mDataset(ncRef);         
    end    
    % get the mVar object
    ncVar = getVar(nc,var);    
    myShape = ncVar.getShape();
    myArgin = nargin;
    
    if (myArgin == 4) 
        stride = ones(1, length(myShape));
        myArgin = myArgin + 1;
    end
    
    switch myArgin
        case 2
            %read the entire volume
            data = ncVar(:);            
        case 5                                  
            data =getData(ncVar,start,count,stride);    
        otherwise, error('MATLAB:nj_varget2:Nargin',...
                        'Incorrect number of arguments'); 
    end 
    
    %cleanup only if we know mDataset object is for single use.
        if (~isNcRef)
            nc.close();
        end
 
catch 
    %gets the last error generated 
    err = lasterror();    
    disp(err.message); 
end

    
end
