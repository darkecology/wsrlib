function []=make_ts(cdf,v,vnames,lat,lon,start,dt,wdepth,idepth,units,cmt,mn)
% MAKE_TS    Creates netCDF time series with EPIC conventions 
%           from evenly spaced time series data.  This version
%           assumes that all time series variables are at the 
%           same latitude, longitude, and depth.
%
%  USAGE: []=make_ts(cdf,v,vnames,lat,lon,start,dt,wdepth,idepth,units,cmt,mn);
%
% where:
%  cdf  = cdf file name to file to be created
%  v = matrix of time series in columns
%  vnames = character matrix with names of variables, 1 per row
%  lat  = latitude
%  lon  = longitude
%  start = [yyyy mm dd hh mi sc] 
%  dt    = time interval in seconds
%  wdepth = water depth in meters
%  idepth = instrument depth in meters
%  units = character matrix with units of variables, 1 per row
%  cmt = character string comment
%  mn = mooring character string identifier
%
%  Rich Signell   7-9-92  rsignell@crusty.er.usgs.gov
%
cmt=cmt';
if(~exist('mn')),
  mn='xxxx'
else
  mn=mn(:)';
end
[m,n]=size(v);
%
% if only 1 time series, it's ok if it's a row vector
if(m==1),v=v',[m,n]=size(v);end;
%
[mm,nn]=size(vnames);
[mu,nu]=size(units);
if(mm~=n),
  disp(' must have a name for each variable')
  return
end
% Create netCDF file 
cdfid = mexcdf('create',cdf,'CLOBBER');
% Suppress error messages from netCDF
[rcode]= mexcdf('setopts',0);
%
% Define dimensions
dims(1) = mexcdf('dimdef',cdfid,'time',m);
dims(2) = mexcdf('dimdef',cdfid,'depth',1);
dims(3) = mexcdf('dimdef',cdfid,'lat',1);
dims(4) = mexcdf('dimdef',cdfid,'lon',1);

% Define variables
%
lonid   = mexcdf('vardef',cdfid,'lon','FLOAT',1,dims(4));
  mexcdf('attput',cdfid,lonid,'units','CHAR',-1,'degrees');
%
latid   = mexcdf('vardef',cdfid,'lat','FLOAT',1,dims(3));
  mexcdf('attput',cdfid,latid,'units','CHAR',-1,'degrees');
%
depthid = mexcdf('vardef',cdfid,'depth','FLOAT',1,dims(2));
  mexcdf('attput',cdfid,depthid,'units','CHAR',-1,'m');
%
for i=1:n,
  varnam=vnames(i,:);
  vind=find(varnam==' ');
  if(length(vind)>0),
    varnam=varnam(1:min(vind)-1);
  end
  varid(i) = mexcdf('vardef',cdfid,varnam,'FLOAT',4,dims);
  % longname is same as variable name with underscores replaced by blanks
  lind=find(varnam=='_');
  longname=varnam;
  for j=1:length(lind)
    longname(lind(j))=' ';
  end
  mexcdf('attput',cdfid,varid(i),'long_name','CHAR',-1,longname);
  mexcdf('attput',cdfid,varid(i),'units','CHAR',-1,units(i,:));
  % specify valid_range based on the min and max values of the good data 
  vr1=min(v(:,i));
  vr2=max(v(:,i));
  mexcdf('attput',cdfid,varid(i),'valid_range','FLOAT',2,[vr1 vr2]);
end
%
timeid  = mexcdf('vardef',cdfid,'time','LONG',1,dims(1));
  mexcdf('attput',cdfid,timeid,'units','CHAR',-1,'Julian days');
  mexcdf('attput',cdfid,timeid,'epic_code','LONG',1,624);
%
time2id = mexcdf('vardef',cdfid,'time2','LONG',1,dims(1));
  mexcdf('attput',cdfid,time2id,'units','CHAR',-1,...
'milliseconds from midnight');

% Create time base
t0=start(4)*3600+start(5)*60+start(6);
jul0=floor(julian(start));

t=[t0:dt:t0+dt*(m-1)];
time2=rem(t,3600*24)*1000;
time=floor(t/(3600*24))+jul0;

stop=gregorian(time(end));
[stop(4),stop(5),stop(6)]=ms2hms(time2(end));

% Create Global attributes
mexcdf('attput',cdfid,'GLOBAL','latitude','FLOAT',1,lat(1));
mexcdf('attput',cdfid,'GLOBAL','longitude','FLOAT',1,lon(1));
mexcdf('attput',cdfid,'GLOBAL','water_depth','FLOAT',1,wdepth(1));
mexcdf('attput',cdfid,'GLOBAL','base_date','SHORT',3,start(1:3));
mexcdf('attput',cdfid,'GLOBAL','start_time','LONG',6,start);
mexcdf('attput',cdfid,'GLOBAL','stop_time','LONG',6,stop);
mexcdf('attput',cdfid,'GLOBAL','DATA_TYPE','CHAR',-1,'TIME');
mexcdf('attput',cdfid,'GLOBAL','COORD_SYSTEM','CHAR',-1,'GEOGRAPHICAL');
mexcdf('attput',cdfid,'GLOBAL','COMMENT','CHAR',-1,cmt(:));
mexcdf('attput',cdfid,'GLOBAL','MOORING','CHAR',-1,mn(:));
%
% End define mode
mexcdf('endef',cdfid);

% Store coordinate (independent) variables
mexcdf('varput1',cdfid,lonid,0,lon(1));
mexcdf('varput1',cdfid,latid,0,lat(1));
mexcdf('varput1',cdfid,depthid,0,idepth(1));
mexcdf('varput',cdfid,timeid,0,m,time);
mexcdf('varput',cdfid,time2id,0,m,time2);
%
% Store data (dependent) variables 
for i=1:n,
   v(:,i)=replace(v(:,i),NaN,1.e35);
   mexcdf('varput',cdfid,varid(i),[0 0 0 0],[m 1 1 1],v(:,i));
end
%
% Close netCDF file
mexcdf('close',cdfid);
disp([cdf ' created'])
