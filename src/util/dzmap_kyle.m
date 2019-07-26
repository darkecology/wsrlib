function [dzmap, dzlim, bins] = dzmap_kyle(bgcolor)
% DZMAP_KYLE A reflectivity colormap obtained from Kyle Horton
%

if nargin < 1
    bgcolor = [0 0 0];
end

% Kyle's cm
rr = [255 229 204 153 238 189 128 000 135 000 000 050 000 255 255 255 255 178 128 255];
gg = [255 204 153 051 232 183 128 255 206 000 255 205 128 255 215 165 000 034 000 000];
bb = [255 255 255 255 170 107 128 255 250 255 000 050 000 000 000 000 000 034 000 255];
dzmap = [(rr./255)' (gg./255)' (bb./255)'];

dzlim = [-33 67.5];
bins = -30:5:65;

dzmap(1,:) = bgcolor;

% Use like this:
%
% caxis(dzlim)
% colormap(dzap)


end