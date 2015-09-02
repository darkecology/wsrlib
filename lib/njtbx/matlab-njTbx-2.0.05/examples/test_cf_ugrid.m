% TEST_CF_UGRID - Read CF-UGRID convention data from ADCIRC, FVCOM and ELCIRC
%
% A more general program library would first get
% grid attributes, check 0-based vs. 1-based, CCW vs CW, grid location
% and convert to standard internal data model, but this script demonstrates
% using NcML to convert existing files to the draft UGRID standard which
% uses the "grid" attribute to point to the connectivity array.
%
% This demo uses njTBX API rather than high level functions.
%
% Rich Signell(rsignell@usgs.gov)

%% Specify input variables
uris = {'adcirc.ncml', 'fvcom.ncml', 'elcirc.ncml', 'zirino.ncml', 'selfe.ncml'};
vars={'zeta','zeta','zeta','zeta','zeta'};
itimes=[30 8 280 2 15];  % which time steps to read from each file

%% Make njTBX API calls & plot data
for i=1:length(uris) 
    uri=fullfile(njtbxroot, 'examples', 'data', uris{i});    
    var=vars{i};
    itime=itimes(i);

    % SHOULDN'T HAVE TO CHANGE BELOW HERE
    tic
    %initialize dataset object
    nc=mDataset(uri);
    %get variable object
    nc_var = nc{var};    
    % read data at specified time step (all nodes)    
    zeta=nc_var(itime,:);

    % Find the coordinate variables
    % Here we assume the order of coordinate variables in the
    % "coordinates" attribute are ordered 'T Y X', which would break
    % for any other order, but illustrates finding the coordinate variable
    % names by use of the coordinates attribute.   In the future we will
    % use a Matlab/NetCDF-Java class that works like that of structured grid, where
    % each variable listed is checked to see what type of coordinate variable
    % it is, using rules based on what type of units it finds, etc.

    s=getAttributes(nc_var);
    coords=s.coordinates;
    ind=strfind(coords,' ');

    Y_var=coords(ind(1)+1:ind(2)-1); % assume here that Y is 2nd
    X_var=coords(ind(2)+1:end);  % assume here that X is third

    % get lon,lat, time
    lon=nc{X_var}(:);
    lat=nc{Y_var}(:);   
    jdmat=getTimes(nc_var,itime);

    % get grid variable name (inference array)
    G_var=getAttributes(nc_var,'grid');    

    % get data from grid variable (connectivity array)
    grid=nc{G_var}(:);
    %grid=nj_varget(uri,G_var);
    [m,n]=size(grid);
    % need to check for orientation of connectivity array
    if m==3,
        grid=grid.';
    elseif n~=3
        disp('Error:Currently handling triangles only');return
    end  
  

   % plot data
   
    figure(i)
    lon(abs(lon)>200)=NaN;  % eliminate any lon/lat outside of range
    lat(abs(lat)>200)=NaN;
    trisurf(grid,lon,lat,zeta);shading interp;view(2);colorbar
    title(sprintf('%s - %s (%s): %s',uris{i},var,s.units,datestr(jdmat)));

    % set aspect ratio for lon/lat plot based on mean latitude
    set (gca, 'DataAspectRatio', [1 cos(gmean(lat(:))*pi/180) 1] );
    
      % cleanup
    close(nc); 
    toc
end

