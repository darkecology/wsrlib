% SGRID - Simple ROMS grid
% Uses seagrid, m_map, and seawater toolbox
plot_grid = 1;
write_nc = 1;
spherical = 1;

% lat,lon of SW corner
lat0 =  41;
lon0 = -70;
h0 = 10;
BigOmega = 7.29e-5 % angular velocity of earths rotation (rad s-1)
f0 = 2*BigOmega*sin( (pi/180)*lat0 );
% use m-map to get a reference location 
zone = utmzone(lon0)
[Xoff,Yoff]=ll2utm(lon0,lat0,zone)

% ROMS dimensions
% Lm and Mm are number of interior (rho) points in Xi and Eta directions
% .nc files have an extra set of rho points outside the domain

%model_setup = 'LAKE_SIGNELL';
model_setup = 'SED_TOY';
switch upper(model_setup),
 case 'COPY_NC'
  % reads an existing grid and uses rho points to copy it
  gfn = 'sc_grd7.nc';
  
 case 'LAKE_SIGNELL'
  disp(model_setup)
  fn = 'lake_signell_grd.nc';
  Lm = 100;  % number of rho points in psi (left-right) direction
  Mm = 20;  % number of rho points in eta (up-down) direction
  nz = 8; % number of sigma layers in vertical
  Xsize = 64e3;
  Esize = 2e3;
  spherical = 0;
 case 'SED_TOY',
  disp(model_setup)
  fn = 'sed_toy_grid.nc';
  Lm = 7;  % number of rho points in psi (left-right) direction
  Mm = 5;  % number of rho points in eta (up-down) direction
  N = 20;  % number of sigma layers in vertical
  Xsize = 7e2;
  Esize = 5e2;
  spherical = 0;
  dx = Xsize/Lm
  dy = Esize/Mm;

  % This is how we do it if we know the rho point locations
  % offsets (= FORTRAN indices-1)
  [x,y]=meshgrid(0:1:Lm+1,0:1:Mm+1);
  % rho points
  xr = (-dx/2)+x*dx;
  yr = (-dy/2)+y*dy;
 otherwise
  error('No model setup matched')
end


if(0)
  % test with spherical coords
  [rr,dirr] = ...
      meshgrid(logspace(log10(1000),log10(7000),Lm+2),(30:5:(30+(Mm+1)*5)));
  [xr,yr]=xycoord(rr,dirr);
end
if(0)
  % test with rotate
  [rr,dirr]=pcoord(xr,yr);
  dirr = dirr+30.0;
  [xr,yr]=xycoord(rr,dirr);
end
if(0),
%  g = roms_get_grid('test.nc');
  g = roms_get_grid('sc_grd7.nc');
  latr = g.lat_rho;
  lonr = g.lon_rho;
  [nr,nc]=size(latr);
  Mm = nr-2;
  Lm = nc-2;
  zone = utmzone(lonr(1,1))
  [Xoff,Yoff]=ll2utm(lonr(1,1),latr(1,1),zone);
  [xr,yr]=ll2utm(lonr,latr,zone);
  xr = xr-Xoff;
  yr = yr-Yoff;
  spherical=1;
end
  
  
% This is how we do it if we pretend we have to extrapolate rho point locations
% rho points
[x,y]=meshgrid(0:1:Lm+1,0:1:Mm+1);
fprintf(1,'Extrapolating from internal rho points.\n');
%iord = 3; % second order fit
iord = 2; % linear fit
for j=2:Mm+1,
  [Px,S,Mu] = polyfit(Lm-2:Lm+1,xr(j,Lm-2:Lm+1),iord);
  xr(j,Lm+2) = polyval(Px,Lm+2,[],Mu);
  [Px,S,Mu] = polyfit(2:5,xr(j,2:5),iord);
  xr(j,1) = polyval(Px,1,[],Mu);
  [Py,S,Mu] = polyfit(Lm-2:Lm+1,yr(j,Lm-2:Lm+1),iord);
  yr(j,Lm+2) = polyval(Py,Lm+2,[],Mu);
  [Py,S,Mu] = polyfit(2:5,yr(j,2:5),iord);
  yr(j,1) = polyval(Py,1,[],Mu);
end
for i=2:Lm+1
  [Px,S,Mu] = polyfit(Mm-2:Mm+1,xr(Mm-2:Mm+1,i)',iord);
  xr(Mm+2,i) = polyval(Px,Mm+2,[],Mu);
  [Px,S,Mu] = polyfit(2:5,xr(2:5,i)',iord);
  xr(1,i) = polyval(Px,1,[],Mu);
  [Py,S,Mu] = polyfit(Mm-2:Mm+1,yr(Mm-2:Mm+1,i)',iord);
  yr(Mm+2,i) = polyval(Py,Mm+2,[],Mu);
  [Py,S,Mu] = polyfit(2:5,yr(2:5,i)',iord);
  yr(1,i) = polyval(Py,1,[],Mu);
end
% corner points
for j=[1 Mm+2],
  [Px,S,Mu] = polyfit(Lm-2:Lm+1,xr(j,Lm-2:Lm+1),iord);
  xr(j,Lm+2) = polyval(Px,Lm+2,[],Mu);
  [Px,S,Mu] = polyfit(2:5,xr(j,2:5),iord);
  xr(j,1) = polyval(Px,1,[],Mu);
  [Py,S,Mu] = polyfit(Lm-2:Lm+1,yr(j,Lm-2:Lm+1),iord);
  yr(j,Lm+2) = polyval(Py,Lm+2,[],Mu);
  [Py,S,Mu] = polyfit(2:5,yr(j,2:5),iord);
  yr(j,1) = polyval(Py,1,[],Mu);
end

% psi points
if(~spherical),
  xp = x(1:end-1,1:end-1)*dx; 
  yp = y(1:end-1,1:end-1)*dy;
else
  % psi points by interpolation from rho-point locations
  meth = '*spline'; %  or '*linear';
  [ix,iy]=meshgrid(.5:1:Lm+.5,.5:1:Mm+.5);
  xp = interp2(x,y,xr,ix,iy,meth);
  yp = interp2(x,y,yr,ix,iy,meth);
end
% u points
if(~spherical),
  xu = x(1:end,1:end-1)*dx;
  yu = (-dy/2)+y(1:end,1:end-1)*dy;
else
  % u points by interpolation from rho-point locations
  [ixu,iyu]=meshgrid(.5:1:Lm+.5,0:1:Mm+1);
  xu = interp2(x,y,xr,ixu,iyu,meth);
  yu = interp2(x,y,yr,ixu,iyu,meth);
end
% v points
if(~spherical),
  xv = (-dx/2)+ x(1:end-1,1:end)*dx;
  yv = y(1:end-1,1:end)*dy;
else
  % v points by interpolation from rho-point locations
  [ixv,iyv]=meshgrid(0:1:Lm+1,.5:1:Mm+.5);
  xv = interp2(x,y,xr,ixv,iyv,meth);
  yv = interp2(x,y,yr,ixv,iyv,meth);
end

% use m_map routines to get lat/lon w/ UTM projection
[lon_rho,lat_rho]=utm2ll(Xoff+xr,Yoff+yr,zone);
[lon_psi,lat_psi]=utm2ll(Xoff+xp,Yoff+yp,zone);
[lon_u,lat_u]=utm2ll(Xoff+xu,Yoff+yu,zone);
[lon_v,lat_v]=utm2ll(Xoff+xv,Yoff+yv,zone);
[Xdist,phaseangle]=sw_dist( [lat_psi(1,1);lat_psi(1,end)],...
			    [lon_psi(1,1);lon_psi(1,end)],'km');
[Ydist,phaseangle]=sw_dist( [lat_psi(1,1);lat_psi(end,1)],...
			    [lon_psi(1,1);lon_psi(end,1)],'km');
Xdist = 1000*Xdist;
Ydist = 1000*Ydist;

% deta, dxi from actual x,y locations
% dxi from v points 
% then fill l columns and top/bottom rows
if(spherical)
  % I think this is the way seagrid does it
  dxsg=earthdist(lon_u(:,1:end-1),lat_u(:,1:end-1),...
		 lon_u(:,2:end),lat_u(:,2:end));
  dysg=earthdist(lon_v(1:end-1,:),lat_v(1:end-1,:),...
		 lon_v(2:end  ,:),lat_v(2:end,  :));
  
  % this is the way sw_dist does it
  %angled1=earthang(lon_u(:,1:end-1),lat_u(:,1:end-1),...
  %	       lon_u(:,2:end),lat_u(:,2:end));
  
  % this is the way seagrid does it (but only for u)
  dlonu = diff(lon_u.').';
  dlatu = diff(lat_u.').';
  clatu = cos(lat_u*pi/180);
  clatu(:, end) = [];
  angleru = atan2(dlatu, dlonu .* clatu);
  % can do the same for the v points
  dlonv= diff(lon_v);
  dlatv = diff(lat_v);
  clatv = cos(lat_v*pi/180);
  clatv(end,:) = [];
  anglerv = atan2(dlatv, dlonv .* clatv);
  % repeat outer columns in u, outer rows in v
  angleru = [ angleru(:,1) angleru angleru(:,end) ];
  anglerv = [ anglerv(1,:);anglerv;anglerv(end,:) ];
  % and average their components in complex space to get rho-point angles
  angler = angle( 0.5*( exp(sqrt(-1)*angleru) + exp(sqrt(-1)*(anglerv-pi/2))));
  pm = zeros(Mm+2,Lm+2);
  pn = zeros(Mm+2,Lm+2);
  pm(:,2:end-1) = 1 ./ dxsg;
  pn(2:end-1,:) = 1 ./ dysg;
  for j=2:Mm+1,
    [Px,S,Mu] = polyfit(Lm-2:Lm+1,pm(j,Lm-2:Lm+1),iord);
    pm(j,Lm+2) = polyval(Px,Lm+2,[],Mu);
    [Px,S,Mu] = polyfit(2:5,pm(j,2:5),iord);
    pm(j,1) = polyval(Px,1,[],Mu);
  end
  for i=2:Lm+1
    [Px,S,Mu] = polyfit(Mm-2:Mm+1,pn(Mm-2:Mm+1,i)',iord);
    pn(Mm+2,i) = polyval(Px,Mm+2,[],Mu);
    [Px,S,Mu] = polyfit(2:5,pn(2:5,i)',iord);
    pn(1,i) = polyval(Px,1,[],Mu);
  end
  % corner points
  for j=[1 Mm+2],
    [Px,S,Mu] = polyfit(Lm-2:Lm+1,pm(j,Lm-2:Lm+1),iord);
    pm(j,Lm+2) = polyval(Px,Lm+2,[],Mu);
    [Px,S,Mu] = polyfit(2:5,pm(j,2:5),iord);
    pm(j,1) = polyval(Px,1,[],Mu);
    [Py,S,Mu] = polyfit(Lm-2:Lm+1,pn(j,Lm-2:Lm+1),iord);
    pn(j,Lm+2) = polyval(Py,Lm+2,[],Mu);
    [Py,S,Mu] = polyfit(2:5,pn(j,2:5),iord);
    pn(j,1) = polyval(Py,1,[],Mu);
  end

  dmde = zeros(Mm+2,Lm+2);
  dndx = zeros(Mm+2,Lm+2);
  dmde(2:end-1, :) = 0.5*(1./pm(3:end, :) - 1./pm(1:end-2, :));
  dndx(:, 2:end-1) = 0.5*(1./pn(:, 3:end) - 1./pn(:, 1:end-2));
  for j=2:Mm+1,
    [Px,S,Mu] = polyfit(Lm-2:Lm+1,dmde(j,Lm-2:Lm+1),iord);
    dmde(j,Lm+2) = polyval(Px,Lm+2,[],Mu);
    [Px,S,Mu] = polyfit(2:5,dmde(j,2:5),iord);
    dmde(j,1) = polyval(Px,1,[],Mu);
  end
  for i=2:Lm+1
    [Px,S,Mu] = polyfit(Mm-2:Mm+1,dndx(Mm-2:Mm+1,i)',iord);
    dndx(Mm+2,i) = polyval(Px,Mm+2,[],Mu);
    [Px,S,Mu] = polyfit(2:5,dndx(2:5,i)',iord);
    dndx(1,i) = polyval(Px,1,[],Mu);
  end
  % corner points
  for j=[1 Mm+2],
    [Px,S,Mu] = polyfit(Lm-2:Lm+1,dmde(j,Lm-2:Lm+1),iord);
    dmde(j,Lm+2) = polyval(Px,Lm+2,[],Mu);
    [Px,S,Mu] = polyfit(2:5,dmde(j,2:5),iord);
    dmde(j,1) = polyval(Px,1,[],Mu);
    [Py,S,Mu] = polyfit(Lm-2:Lm+1,dndx(j,Lm-2:Lm+1),iord);
    dndx(j,Lm+2) = polyval(Py,Lm+2,[],Mu);
    [Py,S,Mu] = polyfit(2:5,dndx(j,2:5),iord);
    dndx(j,1) = polyval(Py,1,[],Mu);
  end
elseif(~spherical),
  dxsg = ones(Mm+2,Lm+2)*dx;
  dysg = ones(Mm+2,Lm+2)*dy;
  dxsg(:,:)=1000*dx;
  dysg(:,:)=1000*dy;
  pm = 1 ./ dxsg;
  pn = 1 ./ dysg;
  dmde = zeros(Mm+2,Lm+2);
  dndx = zeros(Mm+2,Lm+2);
  dmde(2:end-1, :) = 0.5*(1./pm(3:end, :) - 1./pm(1:end-2, :));
  dndx(:, 2:end-1) = 0.5*(1./pn(:, 3:end) - 1./pn(:, 1:end-2));
  angler = zeros(Mm+2,Lm+2);
else
  error('huh?')
end

switch upper(model_setup),
 case 'LAKE_SIGNELL'
  error('Lake Signell depths not specified')
 case 'SED_TOY',
  % depth at rho points
  h = h0*ones(Lm+2,Mm+2);  % constant depth
  f = f0*ones(Lm+2,Mm+2);  % no variation in Coriolis
  rmask = ones(Lm+2,Mm+2); % all water
 otherwise
  fprintf(1,'No model setup matched.\n');
end
 

% CRS attempt at computing angled from GRID east, based on 
% u points to left and right
% angled is in degrees, measured CCW from east atan(dy/dx)
% (this is probably correct for rectangular grids
if(0),
angled = zeros(Mm+2,Lm+2);
angled(:,2:end-1) = (180/pi).*atan2(diff(yu,1,2),diff(xu,1,2));
angled(:,1)=angled(:,2);
angled(:,end)=angled(:,end-1);
end

rmask = ones(Mm+2,Lm+2);
umask = zeros(size(rmask));
vmask = zeros(size(rmask));
pmask = zeros(size(rmask));
for i = 2:Lm
  for j = 1:Mm
    umask(j,i-1) = rmask(j, i) * rmask(j,i-1);
  end
end

for i = 1:Lm
  for j = 2:Mm
    vmask(j-1,i) = rmask(j,i)*rmask(j-1,i);
  end
end

for i = 2:Lm
  for j = 2:Mm
    pmask(j-1,i-1)=rmask(j,i)*rmask(j,i-1)*rmask(j-1,i)*rmask(j-1,i-1);
  end
end
pmask = pmask(1:end-1,1:end-1);
umask = umask(1:end,1:end-1);
vmask = vmask(1:end-1,1:end);



if(plot_grid),
  figure(1)
  clf
  plot(xr,yr,'ok')
  hold on
  plot(xp,yp,'--','color',[.7 .7 .7])
  plot(xp',yp','--','color',[.7 .7 .7])
  plot(xp,yp,'.k')
  plot(xu,yu,'xr')
  plot(xv,yv,'sb')
end

% same data in John Wilkins' grd structure
grd.grd_file=fn;
grd.lon_rho=lon_rho;
grd.lat_rho=lat_rho;
grd.mask_rho=ones(Mm,Lm);
grd.angle=zeros(Mm,Lm);
grd.h=h;
grd.lon_psi=lon_psi;
grd.lat_psi=lat_psi;
grd.mask_psi=ones(size(lon_psi));

% Create the ROMs NetCDF file
if(write_nc)
  
nc = netcdf(fn, 'clobber');
if isempty(nc),error('problem opening roms grd_fn'), end
 
%% Global attributes:
disp(' ## Defining Global Attributes...')
nc.type = ncchar('Gridpak file');
nc.gridid = fn;
nc.history = ncchar(['Created by "' mfilename '" on ' datestr(now)]);
nc.CPP_options = ncchar('DCOMPLEX, DBLEPREC, NCARG_32, PLOTS,');
name(nc.CPP_options, 'CPP-options')

disp(' ## Defining Dimensions...')
nc('xi_rho') = Lm+2;
nc('eta_rho') = Mm+2;

nc('xi_psi') = Lm+1;
nc('eta_psi') = Mm+1;

nc('xi_u') = Lm+1;
nc('eta_u') = Mm+2;

nc('xi_v') = Lm+2;
nc('eta_v') = Mm+1;

nc('two') = 2;
nc('bath') = 0; %% (record dimension)
 
%% Variables and attributes:
disp(' ## Defining Variables and Attributes...')
nc{'xl'} = ncdouble; %% 1 element.
nc{'xl'}.long_name = ncchar('domain length in the XI-direction');
nc{'xl'}.units = ncchar('meter');
 
nc{'el'} = ncdouble; %% 1 element.
nc{'el'}.long_name = ncchar('domain length in the ETA-direction');
nc{'el'}.units = ncchar('meter');
 
nc{'JPRJ'} = ncchar('two'); %% 2 elements.
nc{'JPRJ'}.long_name = ncchar('Map projection type');

nc{'JPRJ'}.option_ME_ = ncchar('Mercator');
nc{'JPRJ'}.option_ST_ = ncchar('Stereographic');
nc{'JPRJ'}.option_LC_ = ncchar('Lambert conformal conic');
name(nc{'JPRJ'}.option_ME_, 'option(ME)')
name(nc{'JPRJ'}.option_ST_, 'option(ST)')
name(nc{'JPRJ'}.option_LC_, 'option(LC)')
 
nc{'PLAT'} = ncfloat('two'); %% 2 elements.
nc{'PLAT'}.long_name = ncchar('Reference latitude(s) for map projection');
nc{'PLAT'}.units = ncchar('degree_north');
 
nc{'PLONG'} = ncfloat; %% 1 element.
nc{'PLONG'}.long_name = ncchar('Reference longitude for map projection');
nc{'PLONG'}.units = ncchar('degree_east');
 
nc{'ROTA'} = ncfloat; %% 1 element.
nc{'ROTA'}.long_name = ncchar('Rotation angle for map projection');
nc{'ROTA'}.units = ncchar('degree');
 
nc{'JLTS'} = ncchar('two'); %% 2 elements.
nc{'JLTS'}.long_name = ncchar('How limits of map are chosen');

nc{'JLTS'}.option_CO_ = ncchar('P1, .. P4 define two opposite corners ');
nc{'JLTS'}.option_MA_ = ncchar('Maximum (whole world)');
nc{'JLTS'}.option_AN_ = ncchar('Angles - P1..P4 define angles to edge of domain');
nc{'JLTS'}.option_LI_ = ncchar('Limits - P1..P4 define limits in u,v space');
name(nc{'JLTS'}.option_CO_, 'option(CO)')
name(nc{'JLTS'}.option_MA_, 'option(MA)')
name(nc{'JLTS'}.option_AN_, 'option(AN)')
name(nc{'JLTS'}.option_LI_, 'option(LI)')
 
nc{'P1'} = ncfloat; %% 1 element.
nc{'P1'}.long_name = ncchar('Map limit parameter number 1');
 
nc{'P2'} = ncfloat; %% 1 element.
nc{'P2'}.long_name = ncchar('Map limit parameter number 2');
 
nc{'P3'} = ncfloat; %% 1 element.
nc{'P3'}.long_name = ncchar('Map limit parameter number 3');
 
nc{'P4'} = ncfloat; %% 1 element.
nc{'P4'}.long_name = ncchar('Map limit parameter number 4');
 
nc{'XOFF'} = ncfloat; %% 1 element.
nc{'XOFF'}.long_name = ncchar('Offset in x direction');
nc{'XOFF'}.units = ncchar('meter');
 
nc{'YOFF'} = ncfloat; %% 1 element.
nc{'YOFF'}.long_name = ncchar('Offset in y direction');
nc{'YOFF'}.units = ncchar('meter');
 
nc{'depthmin'} = ncshort; %% 1 element.
nc{'depthmin'}.long_name = ncchar('Shallow bathymetry clipping depth');
nc{'depthmin'}.units = ncchar('meter');
 
nc{'depthmax'} = ncshort; %% 1 element
nc{'depthmax'}.long_name = ncchar('Deep bathymetry clipping depth');
nc{'depthmax'}.units = ncchar('meter');
 
nc{'spherical'} = ncchar; %% 1 element
nc{'spherical'}.long_name = ncchar('Grid type logical switch');
nc{'spherical'}.option_T_ = ncchar('spherical');
nc{'spherical'}.option_F_ = ncchar('Cartesian');
name(nc{'spherical'}.option_T_, 'option(T)')
name(nc{'spherical'}.option_F_, 'option(F)')
 
nc{'hraw'} = ncdouble('bath', 'eta_rho', 'xi_rho');
nc{'hraw'}.long_name = ncchar('Working bathymetry at RHO-points');
nc{'hraw'}.units = ncchar('meter');
nc{'hraw'}.field = ncchar('bath, scalar');
 
nc{'h'} = ncdouble('eta_rho', 'xi_rho');
nc{'h'}.long_name = ncchar('Final bathymetry at RHO-points');
nc{'h'}.units = ncchar('meter');
nc{'h'}.field = ncchar('bath, scalar');
 
nc{'f'} = ncdouble('eta_rho', 'xi_rho');
nc{'f'}.long_name = ncchar('Coriolis parameter at RHO-points');
nc{'f'}.units = ncchar('second-1');
nc{'f'}.field = ncchar('Coriolis, scalar');
 
nc{'pm'} = ncdouble('eta_rho', 'xi_rho');
nc{'pm'}.long_name = ncchar('curvilinear coordinate metric in XI');
nc{'pm'}.units = ncchar('meter-1');
nc{'pm'}.field = ncchar('pm, scalar');
 
nc{'pn'} = ncdouble('eta_rho', 'xi_rho');
nc{'pn'}.long_name = ncchar('curvilinear coordinate metric in ETA');
nc{'pn'}.units = ncchar('meter-1');
nc{'pn'}.field = ncchar('pn, scalar');
 
nc{'dndx'} = ncdouble('eta_rho', 'xi_rho');
nc{'dndx'}.long_name = ncchar('xi derivative of inverse metric factor pn');
nc{'dndx'}.units = ncchar('meter');
nc{'dndx'}.field = ncchar('dndx, scalar');
 
nc{'dmde'} = ncdouble('eta_rho', 'xi_rho');
nc{'dmde'}.long_name = ncchar('eta derivative of inverse metric factor pm');
nc{'dmde'}.units = ncchar('meter');
nc{'dmde'}.field = ncchar('dmde, scalar');
 
nc{'x_rho'} = ncdouble('eta_rho', 'xi_rho');
nc{'x_rho'}.long_name = ncchar('x location of RHO-points');
nc{'x_rho'}.units = ncchar('meter');
 
nc{'y_rho'} = ncdouble('eta_rho', 'xi_rho');
nc{'y_rho'}.long_name = ncchar('y location of RHO-points');
nc{'y_rho'}.units = ncchar('meter');
 
nc{'x_psi'} = ncdouble('eta_psi', 'xi_psi');
nc{'x_psi'}.long_name = ncchar('x location of PSI-points');
nc{'x_psi'}.units = ncchar('meter');
 
nc{'y_psi'} = ncdouble('eta_psi', 'xi_psi');
nc{'y_psi'}.long_name = ncchar('y location of PSI-points');
nc{'y_psi'}.units = ncchar('meter');
 
nc{'x_u'} = ncdouble('eta_u', 'xi_u');
nc{'x_u'}.long_name = ncchar('x location of U-points');
nc{'x_u'}.units = ncchar('meter');
 
nc{'y_u'} = ncdouble('eta_u', 'xi_u');
nc{'y_u'}.long_name = ncchar('y location of U-points');
nc{'y_u'}.units = ncchar('meter');
 
nc{'x_v'} = ncdouble('eta_v', 'xi_v');
nc{'x_v'}.long_name = ncchar('x location of V-points');
nc{'x_v'}.units = ncchar('meter');
 
nc{'y_v'} = ncdouble('eta_v', 'xi_v');
nc{'y_v'}.long_name = ncchar('y location of V-points');
nc{'y_v'}.units = ncchar('meter');
 
nc{'lat_rho'} = ncdouble('eta_rho', 'xi_rho');
nc{'lat_rho'}.long_name = ncchar('latitude of RHO-points');
nc{'lat_rho'}.units = ncchar('degree_north');
 
nc{'lon_rho'} = ncdouble('eta_rho', 'xi_rho');
nc{'lon_rho'}.long_name = ncchar('longitude of RHO-points');
nc{'lon_rho'}.units = ncchar('degree_east');
 
nc{'lat_psi'} = ncdouble('eta_psi', 'xi_psi');
nc{'lat_psi'}.long_name = ncchar('latitude of PSI-points');
nc{'lat_psi'}.units = ncchar('degree_north');
 
nc{'lon_psi'} = ncdouble('eta_psi', 'xi_psi');
nc{'lon_psi'}.long_name = ncchar('longitude of PSI-points');
nc{'lon_psi'}.units = ncchar('degree_east');
 
nc{'lat_u'} = ncdouble('eta_u', 'xi_u');
nc{'lat_u'}.long_name = ncchar('latitude of U-points');
nc{'lat_u'}.units = ncchar('degree_north');
 
nc{'lon_u'} = ncdouble('eta_u', 'xi_u');
nc{'lon_u'}.long_name = ncchar('longitude of U-points');
nc{'lon_u'}.units = ncchar('degree_east');
 
nc{'lat_v'} = ncdouble('eta_v', 'xi_v');
nc{'lat_v'}.long_name = ncchar('latitude of V-points');
nc{'lat_v'}.units = ncchar('degree_north');
 
nc{'lon_v'} = ncdouble('eta_v', 'xi_v');
nc{'lon_v'}.long_name = ncchar('longitude of V-points');
nc{'lon_v'}.units = ncchar('degree_east');
 
nc{'mask_rho'} = ncdouble('eta_rho', 'xi_rho');
nc{'mask_rho'}.long_name = ncchar('mask on RHO-points');
nc{'mask_rho'}.option_0_ = ncchar('land');
nc{'mask_rho'}.option_1_ = ncchar('water');
name(nc{'mask_rho'}.option_0_, 'option(0)')
name(nc{'mask_rho'}.option_1_, 'option(1)')
 
nc{'mask_u'} = ncdouble('eta_u', 'xi_u');
nc{'mask_u'}.long_name = ncchar('mask on U-points');
nc{'mask_u'}.option_0_ = ncchar('land');
nc{'mask_u'}.option_1_ = ncchar('water');
name(nc{'mask_u'}.option_0_, 'option(0)')
name(nc{'mask_u'}.option_1_, 'option(1)')
%		 nc{'mask_u'}.FillValue_ = ncdouble(1);
 
nc{'mask_v'} = ncdouble('eta_v', 'xi_v');
nc{'mask_v'}.long_name = ncchar('mask on V-points');
nc{'mask_v'}.option_0_ = ncchar('land');
nc{'mask_v'}.option_1_ = ncchar('water');
name(nc{'mask_v'}.option_0_, 'option(0)')
name(nc{'mask_v'}.option_1_, 'option(1)')
%		 nc{'mask_v'}.FillValue_ = ncdouble(1);
 
nc{'mask_psi'} = ncdouble('eta_psi', 'xi_psi');
nc{'mask_psi'}.long_name = ncchar('mask on PSI-points');
nc{'mask_psi'}.option_0_ = ncchar('land');
nc{'mask_psi'}.option_1_ = ncchar('water');
name(nc{'mask_psi'}.option_0_, 'option(0)')
name(nc{'mask_psi'}.option_1_, 'option(1)')
%		 nc{'mask_psi'}.FillValue_ = ncdouble(1);

nc{'angle'} = ncdouble('eta_rho', 'xi_rho');
nc{'angle'}.long_name = ncchar('angle between xi axis and east');
nc{'angle'}.units = ncchar('radians');

% Fill the variables with data.
disp(' ## Filling Variables...')

% Projection
mercator = 'ME';
sterogrphic = 'ST';
lambert = 'LC'; % lambert conformal conic
nc{'JPRJ'}(:) = mercator;
nc{'spherical'}(:) = 'T';   % T or F -- uppercase okay?

nc{'xl'}(:) = Xsize;
nc{'el'}(:) = Esize;

nc{'f'}(:) = f;
nc{'x_rho'}(:) = xr;
nc{'y_rho'}(:) = yr;

nc{'x_psi'}(:) = xp;
nc{'y_psi'}(:) = yp;

nc{'x_u'}(:) = xu;
nc{'y_u'}(:) = yu;

nc{'x_v'}(:) = xv;
nc{'y_v'}(:) = yv;

nc{'lon_rho'}(:) = lon_rho;
nc{'lat_rho'}(:) = lat_rho;

nc{'lon_psi'}(:) = lon_psi;
nc{'lat_psi'}(:) = lat_psi;

nc{'lon_u'}(:) = lon_u;
nc{'lat_u'}(:) = lat_u;

nc{'lon_v'}(:) = lon_v;
nc{'lat_v'}(:) = lat_v;

nc{'h'}(:) = h;

nc{'mask_rho'}(:) = rmask;
nc{'mask_psi'}(:) = pmask;
nc{'mask_u'}(:) = umask;
nc{'mask_v'}(:) = vmask;

nc{'angle'}(:) = angler;
nc{'pm'}(:) = pm;
nc{'pn'}(:) = pn;
nc{'dmde'}(:) = dmde;
nc{'dndx'}(:) = dndx;

% Final size of file:
s = size(nc);
disp([' ## Dimensions: ' int2str(s(1))])
disp([' ## Variables: ' int2str(s(2))])
disp([' ## Global Attributes: ' int2str(s(3))])
disp([' ## Record Dimension: ' name(recdim(nc))])
 
endef(nc)
close(nc)
end % write_nc