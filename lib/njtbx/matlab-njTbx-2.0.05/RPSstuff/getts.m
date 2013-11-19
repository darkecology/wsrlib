function [var,jd,ln,units,lat,lon,idepth,wdepth] = getts(cdf, var,start,stop)
%  GETTS  Gets time-series data from from an EPIC style netcdf file, 
%         allowing the user to grab the whole time-series, or 
%         specify start and stop time.
%
%   USAGE:
%       [var,jd] = getts(cdf,var);  % gets whole series
% or
%       [var,jd] = getts(cdf,var,start,stop);
% or
%   [var,jd,long_name,units,lat,lon,idepth,wdepth] = getts(cdf, var,start,stop);
%
%     outputs: var = time series vector
%              jd  = julian day vector
%              long_name = long_name for label
%              units = data units
%              lat = latitude of data 
%              lon = longitude of data 
%              idepth = instrument depth of data 
%              wdepth = water depth of data 
%
%     inputs:  cdf = netcdf file name
%              var = netcdf variable name
%              start = optional start time  [yyyy mm yy dd hr mi]
%              stop = optional stop time  [yyyy mm yy dd hr mi]
%
% Example:
% [var,jd,l] = getts('time.cdf', 'salinity');   % get all salinity data
% or
% [var,jd,l] = getts('time.cdf', 'salinity', [1990 7 1 0 0 0],[1990 9 1 0 0 0]);
%

%
%Rich Signell               |  rsignell@crusty.er.usgs.gov
%U.S. Geological Survey     |  (508) 457-2229  |  FAX (508) 457-2310
%Quissett Campus            |  
%Woods Hole, MA  02543      | 
%
% Show usage if too few arguments.
%
% needs FILL_ATTNAMES, FILL_VARNAMES, CHECK_STRING, JULIAN, THUMBFIN
if nargin~=2 & nargin~=4,
   help getts;
   return;
end
%
% Open netCDF file
%
% eliminate trailing blanks from name
ind=find(cdf==' ');
if(~isempty(ind)),cdf=cdf(1:ind-1);end
 
[cdfid,rcode ]=mexcdf('open',cdf,'NOWRITE');
if rcode < 0
   s = [ 'mexcdf: ncopen: rcode = ' int2str(rcode) ];
   disp (s)
   return
end

%
%
% Suppress netCDF error messages

[rcode] = mexcdf('setopts', 0);
%
% Get variable id
%
[varid,rcode]=mexcdf('varid',cdfid,var);
if ( rcode < 0 | varid < 0 )
   disp([ 'MexCDF error:  Couldn''t find variable ' var]) 
   return
end

[var_name,var_type,nvdims,var_dim,natts,rcode]=mexcdf('varinq',cdfid,varid);
attstring = fill_attnames(cdfid, varid, natts);
%
%
% time stuff
%
% Check for time variable
[ndims, nvars, ngatts, recdim, rcode] =  mexcdf('inquire', cdfid);
if rcode < 0
   s = [ 'mexcdf: inquire: rcode = ' int2str(rcode) ];
   disp (s)
   return
end
varstring = fill_varnames(cdfid, nvars);
pos = check_string('time', varstring, nvars);
if pos > 0
  [timevid,rcode] = mexcdf('varid',cdfid,'time');
else
   disp(['file ' cdf 'does not variable named time'])
   return
end
%
% Check for time2 variable (for EPIC files)
pos = check_string('time2', varstring, nvars);
if pos > 0
   [time2vid,rcode] = mexcdf('varid',cdfid,'time2');
   epic=1;
else
   epic=0;
end
%% Find length of time variable  (time must be 1 dimensional)
[timevnam,ttype,ntdims,t_dim]=mexcdf('varinq',cdfid,timevid);
[timednam,n,rcode]=mexcdf('diminq',cdfid,t_dim);
if (epic),
% time is julian day
  jd=mexcdf('varget',cdfid,timevid,0,n);
  ms=mexcdf('varget',cdfid,time2vid,0,n);
  jd=jd+ms/3600/1000/24; 
else,
  base_date=mexcdf('attget',cdfid,'GLOBAL','base_date');
  jd0=julian(base_date(1),base_date(2),base_date(3));
% time is "units" from base_date
  t1=mexcdf('varget',cdfid,timevid,0,n);
  [units]=mexcdf('attget',cdfid,timevid,'units');
  if(units(1:7)=='seconds'),
    jd1=t1/3600/24;
  elseif (units(1:12)=='milliseconds'),
    jd1=t1/3600/24/1000;
  else
    disp('invalid time units')
    return
  end
  jd=jd0+jd1;
end
%
% Automagically get all the data if slab is not specified
  for n=1:nvdims,
    dimid=var_dim(n);
    [dim_name,dim_size,rcode]=mexcdf('diminq',cdfid,dimid);
    cvid(n)=mexcdf('varid',cdfid,dim_name);  % get coordinate variable ids
    corner(n)=0;
    count(n)=dim_size;
  end
if(nargout>2),
% get lat,lon and instrument depth
  idepth = mexcdf('varget1',cdfid,'depth',0);
  lat = mexcdf('varget1',cdfid,'lat',0);
  lon = mexcdf('varget1',cdfid,'lon',0);
  lonatt=mexcdf('attget',cdfid,'lon','epic_code');
  if(lonatt==500),
    lon=-lon
  end
end
if nargin==4,
  start_jd=julian(start)-(5.e-9);
  stop_jd=julian(stop)+(5.e-9);
  ind=find(jd>=start_jd & jd<=stop_jd);
  if(isempty(ind)),
    return
  end
  corner(1)=(ind(1)-1);
  count(1)=(max(ind)-min(ind))+1;
  jd=jd(ind);
end
%
% Get slab
% 
[values,rcode] = mexcdf('varget',cdfid,varid,corner,count);
var=values(:);

if(nargout>2),
% get long_name, units, and water depth
ln=mexcdf('attget',cdfid,varid,'long_name');
units=mexcdf('attget',cdfid,varid,'units');
wdepth=mexcdf('attget',cdfid,'global','water_depth');
end
pos = check_string('valid_range', attstring, natts);
if pos > 0
  valid_range = mexcdf('attget',cdfid,varid,'valid_range');
  var=thumbfin(var,valid_range(1),valid_range(2));
end
mexcdf('close',cdfid);
