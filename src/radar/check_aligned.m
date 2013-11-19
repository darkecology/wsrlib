function [aligned, msg] = check_aligned(radar, fields)
%CHECK_ALIGNED Check that radar was aligned to fixed grid
%
% [aligned, msg] = check_aligned(radar, fields)
%
% Inputs:
%   radar      The radar struct
%   fields     Cell array of fields to check (default: {'dz', 'vr'})
% Outputs:
%   aligned    boolean flag: true = aligned
%   msg        error message if not aligned (first problem encountered)
%

% Get reference data from first sweep
vol1   = radar.(fields{1});
sweep1 = vol1.sweeps(1);

elev       = [vol1.sweeps.elev];

nbins      = sweep1.nbins;
range_bin1 = sweep1.range_bin1;
gate_size  = sweep1.gate_size;
azim_v     = sweep1.azim_v;

aligned = false;
msg = '';

% Now check that all other sweeps match
for f=1:length(fields)
        
    vol = radar.(fields{f});
    
    if ~isequal([vol.sweeps.elev], elev)
        msg = 'Differing elevation angles in two volumes';
        return;
    end
    
    for i = 1:numel(vol.sweeps)
        
        sweep = vol.sweeps(i);
        
        if sweep.nbins ~= nbins || sweep.range_bin1 ~= range_bin1 || sweep.gate_size ~= gate_size
            msg = 'Different range bins';
            return;
        end
        
        if sweep.azim_v ~= azim_v
            msg = 'Different azimuths';
            return;
        end            
    end
end

aligned = true;

end
