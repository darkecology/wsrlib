function []=write_gnome_curv(cdfout,lon,lat,jdmat,u,v,depth,sigma,title);
% WRITE_GNOME_CURV Writes curvilinear GNOME-compatible NetCDF
% Usage: write_gnome_curv(cdfout,lon,lat,jdmat,u,v,depth,sigma,title);
% Inputs:
%     CDFOUT: name for output GNOME-compatible netcdf file
%     LON and LAT: 2D arrays of lon/lat (decimal degrees, west negative)
%     U, V: 4D arrays (t,z,y,x) of east and north velocity (m/s).  Note
%       that it is assumed that u,v are colocated at the lon,lat points and
%       indicate true eastward and northward velocities (not grid-relative
%       velocities).
%     JDMAT: time vector (Matlab DATENUM format)
%     DEPTH: 2D array of model depths (m).  Depths should be -99999. or NaN
%       at land values.  This will be used to make a land mask.
%     SIGMA: sigma level column vector for u,v vertical positions (nondimensional) 
%     TITLE:   text string to appear in GNOME file
%
% Note: Currently GNOME only uses the top layer currents, so to save space
%      I only write one layer to the netcdf file.  
%      Used this way, U has dimensions (NZ 1 NY NX), and sigma is a single
%      arbitrary value (like 0).

nc=netcdf(cdfout,'clobber');

[nt,nz,ny,nx]=size(u);

% dimensions
nc('y')=ny;
nc('x')=nx;
nc('sigma')=nz;
nc('time')=0;   % Time is the unlimited (record) dimension

% variables

nc{'lat'}=ncfloat('y','x');
nc{'lat'}.long_name='Latitude';
nc{'lat'}.units='degrees_north';

nc{'lon'}=ncfloat('y','x');
nc{'lon'}.long_name='Longitude';
nc{'lon'}.units='degrees_east';

nc{'sigma'}=ncfloat('sigma');
nc{'sigma'}.long_name='Sigma';
nc{'sigma'}.units='sigma_level';
nc{'sigma'}.positive='down';
nc{'sigma'}.standard_name='ocean_sigma_coordinate';
nc{'sigma'}.formula_terms='sigma: sigma eta:zeta depth:depth';

nc{'mask'}=ncfloat('y','x');
nc{'mask'}.long_name='land mask';
nc{'mask'}.units='nondimensional';

nc{'time'}=ncfloat('time');
nc{'time'}.long_name='Time';
nc{'time'}.units=['hours since 2000-01-01 00:00:00 00:00'];

nc{'depth'}=ncfloat('y','x');
nc{'depth'}.long_name='Bathymetry';
nc{'depth'}.units='meters';

nc{'u'}=ncshort('time','sigma','y','x');
nc{'u'}.long_name='Eastward Water Velocity';
nc{'u'}.units='m/s';
nc{'u'}.FillValue_=ncshort(-9999);
nc{'u'}.scale_factor=ncfloat(0.01);
nc{'u'}.add_offset=ncfloat(0.0);


nc{'v'}=ncshort('time','sigma','y','x');
nc{'v'}.long_name='Northward Water Velocity';
nc{'v'}.units='m/s';
nc{'v'}.FillValue_=ncshort(-9999);
nc{'v'}.scale_factor=ncfloat(0.01);
nc{'v'}.add_offset=ncfloat(0.0);


nc.Conventions='COARDS';
nc.file_type='Full_Grid';
nc.grid_type='CURVILINEAR';
nc.z_type='sigma';
nc.model='POM';
nc.title=title;

% depth & land mask
iland=find(isnan(depth) | depth==-99999.);

mask=ones(size(depth));
mask(iland)=0;

nc{'time'}(1:nt)=(jdmat-datenum([2000 1 1 0 0 0]))*24;   % convert from Matlab time 
nc{'lat'}(:)=lat;
nc{'lon'}(:)=lon;
nc{'sigma'}(:)=abs(sigma);
nc{'depth'}(:)=depth;
nc{'mask'}(:)=mask;
nc{'u',1}(1:nt,:,:,:)=u;
nc{'v',1}(1:nt,:,:,:)=v;

close(nc);
