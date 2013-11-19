function [ sweeps ] = unique_elev_sweeps( radar, field )
%UNIQUE_ELEV_SWEEPS Extract one sweep per elevation from volume scan.
%  Meant for VCPs which scan lower elevations multiple times.
%
% sweeps = unique_elev_sweeps(radar, field)
%
% Inputs:
%    radar     The radar struct
%    field     'dz' | 'vr' | 'sw'. The type of sweep to extract
% Outputs:
%    sweeps    Sweep array with unique elevations
%
% NOTE: 
%   for 'dz', the lowest prf sweep at a given elevation is chosen
%   for 'vr' and 'sw', the highest prf sweep is chosen
%

sweeps = radar.(field).sweeps;

elev = [sweeps.elev];
prf  = [sweeps.prf];

% Find unique elevations (up to 2 places after decimal)
elev_rounded = round(elev*10)/10;
[elev_unique, ~, I] = unique(elev_rounded);

n_sweeps = numel(elev_unique);

% Find one representative sweep per elevation
reps = zeros(n_sweeps,1);
for i = 1:n_sweeps
    members = find(I==i);             % all sweeps with this elevation

    switch field
        case 'dz'
            [~, j] = min(prf(members));    % pick the one with smallest prf
        case {'vr', 'sw'}
            [~, j] = max(prf(members));
        otherwise
            error('Unrecognized field: %s\n', field);
    end
            
    reps(i) = members(j);
end

sweeps = sweeps(reps);

end
