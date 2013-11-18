function [p1,p2]=iso_plot(data,g,iso_value,vax);
%ISO_PLOT - Plots an isosurface from data returned from cf_tslice
% Usage:[p1,p2] =iso_plot(data,g,iso_value,vax);
% Inputs:  data = 3D data array 
%             g = structure of geo coordinates for data (g.lon,g.lat,g.z and g.jdmat) 
%     iso_value = value of isosurface to plot
%     vax = vertical exaggeration (optional, 200 by default)
% Outputs:   p1 = handle of bottom depth surface object
%            p2 = handle of isosurface patch object
h=squeeze(min(g.z)); % plot minimum z level
[nz,ny,nx]=size(data);
if (min(size(g.lon))==1),
   [g.lon,g.lat]=meshgrid(g.lon,g.lat);
end
if (min(size(g.z))==1),
    h=h*ones(size(g.lon));
    g.z=repmat(g.z,[1 ny nx]);
end
p1=surf(g.lon,g.lat,h,'FaceColor',[0.7 0.7 0.7],'EdgeColor','none');
if nargin==4,
    fac=111111./vax;    % 111111 meters/degree
else
    fac=111111./200;    % default vertical exxaggeration = 200
end
% plot isosurface


lon3d=permute(repmat(g.lon,[1 1 nz]),[3 1 2]);
lat3d=permute(repmat(g.lat,[1 1 nz]),[3 1 2]);
data(data==0)=nan;
p2 = patch(isosurface(lon3d,lat3d,g.z,data,iso_value));
set(p2, 'FaceColor', [0 1 1], 'EdgeColor', 'none');
daspect([1 cos(gmean(g.lat(:)*pi/180)) fac]);
% set the view
view(0,45);

%zoom(1.8);
% set lighting
camlight; lighting phong
% use date string for title
title(datestr(g.time))  % 1-based index (Matlab)
