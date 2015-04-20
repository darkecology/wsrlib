function [ windFile ] = narr_wind_file( time, type )
%NARR_WIND_FILE Returns the NARR wind filename for given timestamp
%
% [ windFile ] = get_wind_file( time )
%
% Inputs:
%    time       Time in MATLAB datenum format
%    type       The NARR file type (default: 3D)
% Outputs:
%    windFile   The NARR filename


if nargin < 2
    type = '3D';
end

% Time is in units of days. Round to closest 3-hour interval
three_hours = 3/24;
rounded_time = round(time/three_hours)*three_hours;

v = datevec(rounded_time);

switch type
    case '3D'   
        windFile = sprintf('merged_AWIP32.%04d%02d%02d%02d.3D', v(1), v(2), v(3), v(4));
    
    % TODO: add other types (sfc, flx, etc.)
    otherwise
        error('Unimplemented file type');
end

end
