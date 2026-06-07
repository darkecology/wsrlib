% RADAR
%
% Radar ingest
%   rsl2mat            - Ingest radar file
%   rsl2mat_s3         - Ingest a radar file directly from s3
%
% Radar manipulation
%   align_scan         - Align volume scan to a fixed resolution grid
%   cajun              - Run cajun workflow on a single scan to create vertical profiles
%   cajun_report       - Produce diagnostic image of cajun workflow on a single scan 
%   check_aligned      - Check that radar was aligned to fixed grid
%   cmp2pol            - Convert from compass bearing to mathematical angle
%   convert_wavelength - Convert between wavelengths for reflectivity factor (Z/dbZ)
%   db                 - Compute decibel transform
%   expand_coords      - Get matrices of coordinates for each pulse volume
%   get_az_range       - Get vector of azimuths and ranges for sweep
%   ground2slant       - Convert from slant range and elevation to ground range and height.
%   groundElev2slant   - Convert from slant range and elevation angle to ground range and height.
%   idb                - Inverse decibel (convert from decibels to linear units)
%   ll2radar           - Convert from lat/lon coordinates to radar coordinates
%   load_segment_net   - Load neural network from file into memory (used by mistnet)
%   mat2cart           - Convert a sweep to cartesian coordinates
%   mat2mat            - Resample a 3d-matrix to a different coordinate system
%   mistnet            - Run mistnet to segment the scan into biology and weather
%   mistnet_polar      - Classify sample volumes in polar coordinates using mistnet
%   mosaic             - Create a mosaic image from many radar files
%   nexrad_station_info - Get NEXRAD station information
%   nexrad_stations    - Return list of NEXRAD station ids
%   pol2cmp            - Convert from mathematical angle to compass bearing
%   radar2ll           - Convert from radar coordinates to lat/lon coordinates
%   radar2mat          - Convert an aligned radar volume to 3d-matrix
%   radar2xyz          - Convert (range, az, elev) to (x, y, z)
%   radarInterpolant   - Create interpolating function for radar data
%   refl_to_z          - Convert from reflectivity to reflectivity factor (z)
%   slant2ground       - Convert from slant range and elevation to ground range and height
%   sweep2cart         - Convert a sweep to cartesian coordinates
%   sweep2mat          - Extract data matrix from sweep
%   unique_elev_sweeps - Extract one sweep per elevation from volume scan.
%   vol_interp         - Create an interpolating function for a volume
%   vpr                - Vertical profile of reflectivity
%   xyz2radar          - Convert (x, y, z) to (az, range, elev)
%   z_to_refl          - Convert Z to reflectivity
%
% Clutter and beam occultation masks
%   occult_mask        - Get beam occultation mask for station
%   static_clutter_mask - Get static clutter mask for station
%   yearly_clutter_mask - Get yearly clutter mask for station and year
