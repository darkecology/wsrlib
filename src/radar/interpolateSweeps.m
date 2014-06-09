function [ interpolatedSweeps ] = interpolateSweeps( sweeps, elevations, method )
%interpolateSweep Interpolate radar sweeps to the provided set of
%'elevations' using the data provided in 'sweeps' using interpolation
%'method'. 
%
% [ interpolatedSweeps ] = interpolateSweep( sweeps, method, elevations )
%
% Note: This assumes that all the provided sweeps are aligned, i.e. they
% have the same number of rays and bins. 

if nargin < 3,
    method = 'nearest';
end

numel = size(sweeps,1);                                                        % the number of sweeps provided

% validate the sweeps
[m,n] = size(sweeps(1).data);                                                  % get reference information from first sweep
for i = 2:numel,
    [mi,ni] = size(sweeps(i).data);
    assert(mi==m && ni==n, 'Sweeps provided are not aligned. Cannot interpolate.');
end

% the result data structure
interpolatedSweeps = sweeps;                                                   % the interpolated sweeps

% get the elevation list for this data
sweepsElev = [sweeps.elev];

switch method
    case 'nearest'
        for i=1:size(elevations,1),
            [~,idx] = min(abs(sweepsElev-elevations(i)));                      % pick the nearest sweep
            interpolatedSweeps(i) = sweeps(idx);
        end
        
    otherwise
        error('Only nearest neighbor interpolation is supported now!');       % TODO: If required, come up with other faster interpolation schemes
end
        
        


end

