function [ u_wind, v_wind ] = read_narr_wind( wind_file, retries, pause_len )
%READ_NARR_WIND Read u and v wind from NARR file

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
    catch err
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

