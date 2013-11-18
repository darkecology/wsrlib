function s=njtbxroot()
% Courtsey: Google Earth toolbox
a=mfilename('fullpath');
Ix=findstr(a,filesep);
s=a(1:Ix(end));

