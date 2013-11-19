function [im,cmd]=ax2webmap(root_name);
% AX2Webmap  Write current figure axis to image for web mapping apps
% Notes: The current figure assumed to be plotted in geographic
% lon/lat coordinates (*not* projected). It is assumed that the 
% ImageMagick "convert" routine is available to convert white colors
% to transparent.  It is assumed that GDAL "gdal_translate" routine is
% available to convert the .png to Geotiff.
% 
% This routine writes a PNG image of the current axis
% along with 
% 1) WorldWind child layer .xml snippet 
% 2) Google Earth .kml snippet
% 3) Geotiff file for mapserver (if "gdal_translate" is available)
% 
% Usage: [im]=ax2webmap(root_name);
% Example: load('topo.mat','topo');   % uses Mathworks supplied topo
%          contour([0.5:1:359.5],[-89.5:1:89.5],topo,[0 0],'r');
%          ax2webmap('topo'); 
%    writes topo.png, topo.xml, and topo.kml
%     topo.xml contains the <Bounding Box> tags for WW
%     topo.kml contains the <LatLonBox> tags for Google Earth
%
% Rich Signell (rsignell@usgs.gov)
% October 6, 2005
axis off
pos0=get(0,'screensize');
posmax=[10 100 pos0(3)-20 pos0(4)-150];
% EPSG:4326 is equally spaced lon/lat
 set (gca, 'DataAspectRatio', [1 1 1] );  
set(gcf,'color','white');
set(gcf,'pos',posmax);
F=getframe(gca);
pngfile=[root_name '.png'];
tiffile=[root_name '.tif'];
im=F.cdata;
imwrite(im,pngfile,'png');
ax=axis;
fid=fopen([root_name '.xml'],'wt');
fprintf(fid,'<BoundingBox>\n');
fprintf(fid,'  <North>\n');
fprintf(fid,'     <Value>%f</Value>\n',ax(4));
fprintf(fid,'  </North>\n');
fprintf(fid,'  <South>\n');
fprintf(fid,'     <Value>%f</Value>\n',ax(3));
fprintf(fid,'  </South>\n');
fprintf(fid,'  <West>\n');
fprintf(fid,'     <Value>%f</Value>\n',ax(1));
fprintf(fid,'  </West>\n');
fprintf(fid,'  <East>\n');
fprintf(fid,'     <Value>%f</Value>\n',ax(2));
fprintf(fid,'  </East>\n');
fprintf(fid,'</BoundingBox>\n');
fclose(fid)

% write snippet for Google Earth
fid=fopen([root_name '.kml'],'wt');
fprintf(fid,'<LatLonBox>\n');
fprintf(fid,'  <north>%f</north>\n',ax(4));
fprintf(fid,'  <south>%f</south>\n',ax(3));
fprintf(fid,'  <west>%f</west>\n',ax(1));
fprintf(fid,'  <east>%f</east>\n',ax(2));
fprintf(fid,'</LatLonBox>\n');
fclose(fid)
% convert white to transparent using ImageMagick's "convert" function
system(['convert.exe -transparent white ' pngfile ' foo.png']);
movefile('foo.png',pngfile,'f');
% convert png to geotiff using gdal_translate
cmd=sprintf('gdal_translate -a_srs EPSG:4326 -of GTIFF -a_ullr %f %f %f %f %s %s',ax(1),ax(4),ax(2),ax(3),pngfile,tiffile)
system(cmd);
