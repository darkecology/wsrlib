function [ u_wind, v_wind ] = narr_read_wind( wind_file, retries, pause_len )
%NARR_READ_WIND Read u and v wind from NARR 3D file
%
%   [ u_wind, v_wind ] = narr_read_wind( wind_file, retries, pause_len )
%
% Inputs:
%   wind_file   Filename of NARR 3D file (e.g. merged_AWIP32.2010091100.3D)
%   retries     Number of times to retry (default: 3)
%   pause_len   Time to pause between retries (default: 15)
% 
% Outputs:
%   u_wind      East-west wind component
%   v_wind      North-south wind component
%
% The output matrices are three-dimensional. They give data for the
% complete NARR domain.
% 
% We implemented the retry mechanism after observing failures when running
% many jobs on a cluster---possibly due to simultaneous access to the same
% file being poorly handled by the njtbx library (?).

if nargin < 2
    retries = 3;
end

if nargin < 3
    pause_len = 15;
end

if ~exist( wind_file, 'file');
    error('File does not exist: %s', wind_file);
end

while retries > 0
    try
        u_wind = nj_grid_varget(wind_file, 'u_wind');
        v_wind = nj_grid_varget(wind_file, 'v_wind');
        retries = 0;
    atch err
        retries = retries - 1;
        fprintf('WARNING: Failed to read wind file:\n');
        fprintf('%s', getReport(err));
        
        if retries > 0
            fprintf('Pausing %d seconds. %d attempts remaining\n', pause_len, retries);
            pause(pause_len);
        else
            rethrow(err);
        end
    end
end

end

