function []=thicker(linethickness);
% THICKER:  makes lines in the current axes thicker!
% Usage: thicker(linethickness);
% Example: thicker(3);
ch=get(gca,'children');
if nargin==0;
    linethickness=3;
end;
for jj=1:length(ch);
linetype=get(ch(jj),'type');
if linetype(1:2)=='li'
  set(ch(jj),'linewidth',linethickness);
end;  % if 'line'
end
