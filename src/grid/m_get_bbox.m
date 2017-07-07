function [ xrng, yrng ] = m_get_bbox( lonlim, latlim, dim )
%M_GET_BBOX Get enclosing bounding box in map coordinates of a lat/lon box
%
%  [xrng, yrng] = m_get_bbox( lonlim, latlim, dim );
%
% Inputs: 
%   lonlim    2-element vector specifying min/max longitude
%   latlim    2-element vector specifying min/max latitude
%   dim       Number of points used along each edge of bounding region
%
% Ouputs:
%   xrng      2-element vector specifying min/max x-coordinate
%   yrng      2-element vector specifying min/max y-coordinate

if nargin < 3
    dim = 500;  
end

lon = linspace( lonlim(1), lonlim(2), dim );
lat = linspace( latlim(1), latlim(2), dim );

% Get x,y coordinates along the edges of the bounding region in lat / lon
% coordinates (these are parallels and meridians)

[ bottom_x, bottom_y ] = m_ll2xy(       lon, latlim(1) );
[    top_x,    top_y ] = m_ll2xy(       lon, latlim(2) );
[   left_x,   left_y ] = m_ll2xy( lonlim(1),       lat );
[  right_x,  right_y ] = m_ll2xy( lonlim(2),       lat );

% Debugging: plot
%  line( bottom_x, bottom_y );
%  line( top_x, top_y );
%  line( left_x, left_y );
%  line( right_x, right_y );

% Now find the overall minimum and maximum x and y coordinates
x = [ bottom_x, top_x, left_x, right_x ];
y = [ bottom_y, top_y, left_y, right_y ];

xrng = [ min(x), max(x) ];
yrng = [ min(y), max(y) ];

end

