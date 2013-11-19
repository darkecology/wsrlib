function [ data_aligned ] = match_az( data, azResolution )
%match_az Aligns the provided data with the specified azResolution. 
%
% [ data_aligned ] = match_az( data, azResolution )
% 
% Notes:
% 1. This function assumes that the pulse volumes are arranged in
% increasing order of azimuths. 
% 2. If the specified azimuth resolution is smaller than the existing
% azimuth resolution, this function will throw an assertion error. 
%


numRays = 360 / azResolution;       % Calculate the number of rays

n = size(data,2);                   % numBins for the current data product

assert(n <= numRays, 'Cannot reduce data resolution. Please see help.');

expansion_ratio = 1/azResolution;   % the expansion ratio for the azimuths

switch n
    
    case 720
        data_aligned = data;
    case 360
        data_aligned = kron(data,ones(1,expansion_ratio));
    otherwise
        error('Cannot expand az resolution.');
end

end