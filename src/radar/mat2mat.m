function [ newdata, y1, y2, y3 ] = mat2mat( indata, x1, x2, elev, varargin )
%MAT2MAT Resample a 3d-matrix to a different coordinate system
%
% [ data, x1, x2, x3 ] = mat2mat( radar, fields, r_max, varargin )
%
% Inputs:
%   radar        radar struct (required)
%   fields       cell array of fields to return (default: {'dz', 'vr'})
%   r_max        max radius for polar or cartesian data in meters (default: 150000m = 150km)
%
% Named inputs
%   in_coords   'polar' | 'cartesian' (default: 'polar')
%   out_coords  'polar' | 'cartesian' (default: 'polar')
%   r_min        min radius for polar data in meters (default: 2125) 
%   r_res        range resolution (default: 250m)
%   az_res       azimuth resolution (default: 0.5)
%   dim          pixel dimension for Cartesian data (default: 500)

% Outputs:
%   data         struct or cell array of 3D data matrices of size m x n x p
%   x1           vector of coordinates for first dimension (m x 1)
%   x2           vector of coordinates for second dimension (n x 1)
%   x3           vector of coordinates for third dimension (p x 1)
%
% For polar coordinates the dimension order is az, range, elev
%
% For Cartesian, the dimension order is y, x, z. The y dimension is
% "flipped" to the y coordinates are in descending order, so it displays
% naturally as an image.
%

DEFAULT_COORDS = 'polar';
DEFAULT_R_MIN  = 2125;
DEFAULT_R_MAX  = 150000;
DEFAULT_R_RES  = 250;
DEFAULT_AZ_RES = 0.5;
DEFAULT_DIM    = 500;
DEFAULT_INTERP_METHOD = 'nearest';

p = inputParser;

addParameter(p,        'r_max',          DEFAULT_R_MAX, @(x) isscalar(x) && x >= 0 );
addParameter(p,    'in_coords',         DEFAULT_COORDS, @(x) any(validatestring(x,{'polar','cartesian'})));
addParameter(p,   'out_coords',         DEFAULT_COORDS, @(x) any(validatestring(x,{'polar','cartesian'})));
addParameter(p,        'r_min',          DEFAULT_R_MIN, @(x) isscalar(x) && x >= 0);
addParameter(p,        'r_res',          DEFAULT_R_RES, @(x) isscalar(x) && x > 0);
addParameter(p,       'az_res',         DEFAULT_AZ_RES, @(x) isscalar(x) && x > 0);
addParameter(p,          'dim',            DEFAULT_DIM, @(x) isscalar(x) && x > 0);
addParameter(p, 'interp_method', DEFAULT_INTERP_METHOD, @(x) ischar(x));

parse(p, varargin{:});

params = p.Results;

data = indata;
if isstruct(data)
    data = struct2cell(data);
end

% Construct query points
switch params.out_coords
    
    case 'polar'
        
        % Query points
        r  = params.r_min  : params.r_res  : params.r_max;
        phi = params.az_res : params.az_res : 360;

        [R, PHI, ELEV] = meshgrid(r, phi, elev);
        
        [y1, y2, y3] = deal(r, phi, elev);
        
        switch params.in_coords
            
            case 'polar'                
                [Y1, Y2, Y3] = deal(R, PHI, ELEV);
                
            case 'cartesian'
                PHI = cmp2pol(PHI);
                [X, Y] = pol2cart(PHI,R);
                
                [Y1, Y2, Y3] = deal(X, Y, ELEV);
        end
        
    case 'cartesian'

        x = linspace (-params.r_max, params.r_max, params.dim);
        y = linspace ( params.r_max, -params.r_max, params.dim);
        
        [X, Y, ELEV] = meshgrid(x, y, elev);
        [y1, y2, y3] = deal(x, y, elev);
        
        switch params.in_coords
            
            case 'polar'
                [PHI, R] = cart2pol(X, Y);
                PHI = pol2cmp(PHI);  % convert from radians to compass heading
                [Y1, Y2, Y3] = deal(R, PHI, ELEV);
                
            case 'cartesian'
                [Y1, Y2, Y3] = deal(Y, X, Z);
        end

    otherwise
        error('Bad coordinate system')

end

% In input data is in polar coordinates, repeat first and last azimuths so 
% this coordinate effectively wraps around during interpolation
if strcmp(params.in_coords, 'polar')
    x2 = [x2(end)-360;  x2(:);  x2(1)+360 ];
    for i = 1:length(data)
        data{i} = cat(2, data{i}(:,end,:), data{i}, data{i}(:,1,:));
    end
end

% Do the interpolation
n_fields = numel(data);
newdata = cell(n_fields, 1);

for i = 1:n_fields
    F = griddedInterpolant({x1, x2, elev}, data{i}, params.interp_method);
    F.ExtrapolationMethod = 'none';
    newdata{i} = F(Y1, Y2, Y3);
end

% Convert back to struct if desired
if isstruct(indata)
    newdata = cell2struct(newdata(:), fieldnames(indata), 1);
end

end
