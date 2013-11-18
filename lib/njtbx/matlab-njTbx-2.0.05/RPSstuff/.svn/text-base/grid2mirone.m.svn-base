function []=grid2mirone(d,g);
% GRID2MIRONE passes data and a grid obtained from "cf_subsetGrid" to Mirone
% Usage: grid2mirone(d,g)
%   where d = data
%         g = structure containing g.lon and g.lat
% Example: uri='http://coast-enviro.er.usgs.gov/thredds/dodsC/bathy/crm_vol1.nc';
%          [d,g]=cf_subsetGrid(uri,'topo',[-71.0 -70.1 41.2 41.7]);
%          grid2mirone(d,g);
struct.geog=1;  % 1=geographic, 0=other coords
g.lon = double(g.lon);        g.lat = double(g.lat);
d = single(d);
struct.head=[min(g.lon(:)) max(g.lon(:)) min(g.lat(:)) max(g.lat(:)) min(d(:)) max(d(:)) 0 abs(diff(g.lon(1:2))) abs(diff(g.lat(1:2)))];
struct.head= double(struct.head);
if g.lat(1) > g.lat(end),
  d=flipud(d);
  g.lat=flipud(g.lat(:));
end
struct.X=g.lon;
struct.Y=g.lat;
mirone(d,struct)