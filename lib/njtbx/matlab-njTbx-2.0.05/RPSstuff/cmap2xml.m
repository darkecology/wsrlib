%c=jet(64);
%c=nrl_cmap;
c=grey(256);%
file='mymap3.xml';
fid=fopen(file,'w');
fprintf(fid,'%f,',c(:,1));
fprintf(fid,'\n');
fprintf(fid,'%f,',c(:,2));
fprintf(fid,'\n');
fprintf(fid,'%f,',c(:,3));
fprintf(fid,'\n');
fprintf(fid,'%f,',ones(size(c(:,3))));
fprintf(fid,'\n');
fclose(fid);
disp([file ' created!']);
