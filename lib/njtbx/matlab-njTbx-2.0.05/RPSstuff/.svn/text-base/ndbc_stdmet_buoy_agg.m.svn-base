function filename=ndbc_stdmet_buoy_agg(buoyid,urlbase,dodsbase);
%Genenerate NcML for aggregating the NDBC stdmet Buoy data
% Usage: filename=ndbc_stdmet_buoy_agg(buoyid,[urlbase],[dodsbase]);
%   Input: buoyid:  string with buoyid (e.g. '44013')
%          urlbase: base URL for opendap directory listing
%          dodsbase: base URL for opendap data URL 
%
%   Outputs: NcML file name (string) [e.g. 'buoy_44013_agg.ncml']
%          (and generated NcML file on disk)
% Example:
% buoyid='44013';
% urlbase='http://dods.ndbc.noaa.gov/thredds/catalog/data/stdmet/';
% dodsbase='http://dods.ndbc.noaa.gov/thredds/dodsC/data/stdmet/';
% ncml_filename=buoy_agg(buoyid); 
% cf_info(ncml_filename)

% This function constructs the URL of the top level OpenDAP directory, 
% returns the contents of the this directory as a string using "urlread", 
% finds the list of filenames that match the buoyid, and then 
% constructs the NcML which makes up the aggregation for this buoy.

% The constructed directory URL should end up something like this: 
%   http://dods.ndbc.noaa.gov/thredds/catalog/data/stdmet/44013/catalog.html';
% The OpenDAP URLs should look something like this
%   http://dods.ndbc.noaa.gov/thredds/dodsC/data/stdmet/44013/44013h1984.nc

if nargin==1,
  urlbase='http://dods.ndbc.noaa.gov/thredds/catalog/data/stdmet/';
  dodsbase='http://dods.ndbc.noaa.gov/thredds/dodsC/data/stdmet/';
end

url=[urlbase buoyid '/catalog.html'];
s=urlread(url); 
% try to find the filenames within the HTML
f1=strfind(s,['<tt>' buoyid 'h']);  %specific to this HTML
f2=strfind(s,'.nc</tt>');   % specific to this HTML
filename=sprintf('buoy_%s_agg.ncml',buoyid);
fid=fopen(filename,'wt');
fprintf(fid,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fid,'<netcdf xmlns="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">\n');
fprintf(fid,'   <aggregation dimName="time" type="joinExisting">\n');
jd0=-999;
for i=1:length(f1)-1;
    ncfile=s(f1(i)+4:f2(i)+2);   % specific to this HTML
    dodsurl=sprintf('%s%s/%s',dodsbase,buoyid,ncfile)
    jd1=nj_varget(dodsurl,'time');
    if jd0>jd1(1),
      sprintf('Warning: %s greater than %s: time not monotonic',datestr(jd0),datestr(jd1(1)))
    end
    jd0=jd1(end); %last time value
    ncoords=length(jd1);
    % add "ncoords" to NcML for speed
    fprintf(fid,'<netcdf location="%s" ncoords="%d"/>\n',dodsurl,ncoords);
end
% handle last one differently
last_file=s(f1(end)+4:f2(end)+2);
dodsurl=sprintf('%s%s/%s',dodsbase,buoyid,last_file)
jd2=nj_varget(dodsurl,'time');
ind=find(jd2>jd1(end));
str1=sprintf('%12d',jd2(ind));

fprintf(fid,'<netcdf location="%s" coordValue="%s" />\n',dodsurl,str1);
fprintf(fid,'   </aggregation>\n');
fprintf(fid,'   <attribute name="Conventions"  value="CF-1.0"/>\n');
fprintf(fid,'</netcdf>\n');

fclose(fid);
disp([filename ' created!'])

    