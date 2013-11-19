function [X,map]=writePNG(file)
% 
%  WRITEPNG writes the current figure in PNG format using screen resolution
%
%    Usage:  writepng(file)
%
cmd=sprintf('print -dpng -r0 %s',file);
eval(cmd) 
disp(sprintf('Wrote %s',file));
