function [im,cmd]=ax2ww(root_name);
% AX2WW  Write current axis to World Wind (and Google Earth) compatible files
% writes a PNG image of the current axis
%    along with 
% WorldWind child layer .xml snippet 
%       *and* 
% Google Earth .kml snippet
% 
% Usage: [im]=ax2ww(root_name);
% Example: ax2ww('test'); 
%    writes test.png, test.xml, and test.kml
%     test.xml contains the <Bounding Box> tags for WW
%     test.kml contains the <LatLonBox> tags for Google Earth
axis off
pos0=get(0,'screensize');
posmax=[10 100 pos0(3)-20 pos0(4)-150];
dasp;
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
system(['convert -transparent white ' pngfile ' foo.png']);
movefile('foo.png',pngfile,'f');
% convert png to geotiff using gdal_translate
cmd=sprintf('gdal_translate -a_srs EPSG:4326 -of GTIFF -a_ullr %f %f %f %f %s %s',ax(1),ax(4),ax(2),ax(3),pngfile,tiffile)
system(cmd);
