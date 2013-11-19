function [ data, mask, az, range, sweep_error ] = align_sweeps( sweeps, rmax, type, station)
%ALIGN_SWEEPS Align reflectivity and radial velocity sweeps
% 
% [ data, mask, az, range ] = align_sweeps( sweeps, rmax, type )
%

sweep_error=0;

N = numel(sweeps);
data = cell(N,1);

% Use first sweep to get reference info
[az, range] = get_az_range(sweeps{1});
elev = sweeps{1}.elev;

if nargin < 2
    rmax = max(range);
end

[range, I] = filter_range(range, elev, rmax, type); % Eliminate gates beyond max. radius
[az, J] = sort(az);                           % Sort rays by increasing azimuth

data{1} = sweeps{1}.data(I,J);
[m, n] = size(data{1});

% Mask data with a value indicating a special flag (codes begin at 131067) 
FLAG_START = 131067;
mask = data{1} < FLAG_START;

% Now match remaining sweeps to first
for i=2:N
    
    [azi, rangei] = get_az_range(sweeps{i});

    % Again sort by azimuth and filter by radius 
    [rangei, I] = filter_range(rangei, elev, rmax, type);
    [azi, J] = sort(azi);  
    data{i} = sweeps{i}.data(I,J);
    
    % Now check for consistency
    [mi, ni] = size(data{i});
    
    %Check for special cases
    if strcmp(station,'KDOX') || strcmp(station,'KTYX'),
        range_match = get_range_matches(range,rangei);
        data{1} = expand_range(range_match,data{1});
        range = rangei;
        [m, n] = size(data{1});
        % Mask data with a value indicating a special flag (codes begin at 131067)
        FLAG_START = 131067;
        mask = data{1} < FLAG_START;
    end
    
    if mi ~= m 
            fprintf('Different number of gates per ray, ignoring this sweep \n');
            sweep_error = 1;
            return
    end
    
    if ni ~= n 
            fprintf('Different number of rays, ignoring this sweep \n');
            sweep_error = 1;
            return
    end
    
    if mean(abs(az - azi)) > 0.5 
            fprintf('Azimuths do not match to suitable tolerance, ignoring this sweep \n');
            sweep_error = 1;
            return
    end
    
    if ~isequal(range, rangei) 
            fprintf('Ranges do not match, ignoring this sweep \n');
            sweep_error = 1;
            return
    end
    

    
    % Add to the mask
    mask = mask & data{i} < FLAG_START;
    
end

end

function [range, I] = filter_range(range, elev, rmax, type)

    switch type
        case 'ground'
            ground_range = slant2ground(range, elev);
            I = ground_range <= rmax;
        case 'slant'
            I = range <= rmax;
        otherwise
            error('Unrecognized range type');
    end
    
    range = range(I);
    
end
