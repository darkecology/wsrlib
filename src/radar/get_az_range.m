function [ az, range ] = get_az_range( sweep )
%GET_AZ_RANGE Get vector of azimuths and ranges for sweep
%
% [ az, range ] = get_az_range( sweep )
%

range = sweep.range_bin1 + sweep.gate_size*(0:sweep.nbins-1);
az = sweep.azim_v;

end

