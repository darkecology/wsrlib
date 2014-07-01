function sweeps = get_aligned_sweep(radar, sweepinds, field, inopt)
%
% sweep = get_aligned_sweep(radar, [sweepinds], [field], [opts])
% 
% Converts a radar struct into an array of sweeps, each of which represents
% a single elevation angle. Each sweep has dz, vr, and sw data aligned into
% the same cartesian coordinates.
%
% Some volume coverage patterns sweep multiple times at a given elevation
% angle. This routine just takes the first sweep containing the desired
% measurement (dz, vr, sw) and discards the rest.

  if ~radar.params.cartesian
    error('Currently only supported for cartesian');
  end

  if nargin < 2
    sweepinds = []; % get all sweeps
  end
  
  opt.dzdefault = nan;
  opt.vrdefault = nan;
  opt.swdefault = nan;

  if nargin < 3 || isempty(field)
    field = 'sweeps';
  end
  
  if nargin >= 4
    opt = getopt(opt, inopt);
  end
  
  % pull out the sweeps (or cappis)
  dzsweeps = radar.dz.(field);
  vrsweeps = radar.vr.(field);
  swsweeps = radar.sw.(field);
  
  const = radar.constants;

  angles = unique([dzsweeps.fix_angle, vrsweeps.fix_angle, swsweeps.fix_angle]);
  angles = sort(angles, 'ascend');
  
  emptysweep = struct();
  emptysweep.fix_angle = nan;
  emptysweep.dz = [];
  emptysweep.rf = [];
  emptysweep.vr = [];
  emptysweep.sw = [];
    
  if isempty(sweepinds)
      sweepinds = 1:length(angles);
  end
  
  sweeps = repmat(emptysweep, length(sweepinds), 1);
  
  % For each angle, get the first sweep of each volume at that angle
  %  (Some volume coverage patterns, such as 121, scan multiple times 
  %   at the same angle while recording velocity data)
  for i = 1:length(sweepinds)
      
      angle = angles(sweepinds(i));
      
      sweeps(i).fix_angle = angle;

      sweepnum = find([dzsweeps.fix_angle] == angle, 1);      
      sweeps(i).dz = replace_val(dzsweeps(sweepnum).data, const.BADVAL, opt.dzdefault);

      sweepnum = find([vrsweeps.fix_angle] == angle, 1);
      sweeps(i).rf = (vrsweeps(sweepnum).data == const.RFVAL); % range folding
      sweeps(i).vr = replace_val(vrsweeps(sweepnum).data, const.BADVAL, opt.vrdefault);
      sweeps(i).vr(sweeps(i).rf) = opt.vrdefault;

      sweepnum = find([swsweeps.fix_angle] == angle, 1);      
      sweeps(i).sw = replace_val(swsweeps(sweepnum).data, const.BADVAL, opt.vrdefault);
      sweeps(i).sw(sweeps(i).rf) = opt.swdefault;
      
  end
 
end
