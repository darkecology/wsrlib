% RADAR
%
% Files
%   align_scan         - Align volume scan to a fixed resolution grid
%   check_aligned      - Check that radar was aligned to fixed grid
%   cmp2pol            - Convert from compass bearing to mathematical angle
%   convert_wavelength - Convert between wavelengths for reflectivity factor (Z/dbZ)
%   db                 - Compute decibel transform
%   expand_coords      - Get matrices of coordinates for each pulse volume
%   get_az_range       - Get vector of azimuths and ranges for sweep
%   ground2slant       - Convert from slant range and elevation to ground range and height.
%   groundElev2slant   - Convert from slant range and elevation to ground range and height.
%   idb                - Inverse decibel (convert from decibels to linear units)
%   mat2cart           - Convert a sweep to cartesian coordinates
%   pol2cmp            - Convert from mathematical angle to compass bearing
%   radar2mat          - Convert an aligned radar volume to 3d-matrix
%   radarInterpolant   - - Create interpolating function for radar data
%   refl_to_z          - Convert from reflectivity to reflectivity factor (z)
%   slant2ground       - Convert from slant range and elevation to ground range and height.
%   sweep2cart         - Convert a sweep to cartesian coordinates
%   sweep2mat          - Extract data matrix from sweep
%   unique_elev_sweeps - Extract one sweep per elevation from volume scan.
%   vol_interp         - Create an interpolating function for a volume
%   vpr                - Vertical profile of reflectivity
%   xyz2radar          - Convert (x, y, z) to (az, range, elev)
%   z_to_refl          - Convert Z to reflectivity
