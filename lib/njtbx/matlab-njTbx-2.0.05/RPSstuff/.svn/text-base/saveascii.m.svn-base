function  []=saveascii(file,data,form);
% SAVEASCII save an array in a formatted form
%   Usage:   saveascii(file,data,format);
%           file = file name
%           data = array to save
%           format = format to be used for each line  (eg '%3d %3d %5.6f\n')
fid=fopen(file,'wt');
fprintf(fid,form,data');
fclose(fid);
disp([file ' created!']);
