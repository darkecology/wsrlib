% Radar ingest and manipulation
%   rsl2mat            - Ingest radar file
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
%   radarInterpolant   - Create interpolating function for radar data
%   refl_to_z          - Convert from reflectivity to reflectivity factor (z)
%   slant2ground       - Convert from slant range and elevation to ground range and height.
%   sweep2cart         - Convert a sweep to cartesian coordinates
%   unique_elev_sweeps - Extract one sweep per elevation from volume scan.
%   vol_interp         - Create an interpolating function for a volume
%   vpr                - Vertical profile of reflectivity
%   xyz2radar          - Convert (x, y, z) to (az, range, elev)
%   z_to_refl          - Convert Z to reflectivity
%
% Velocity profiling and dealiasing
%   alias                  - Alias a value to within interval [-vmax, vmax]
%   compute_loss           - Compute rmse and wrapped normal neg. log likelihood 
%   divide_gausspot        - Divide two Guassian potentials
%   epvvp                  - Volume velocity profile based on EP
%   expand_gausspot        - Expand a potential to more variables
%   get_vr_pulse_volumes   - Extract vectorized info about all pulse volumes in a volume scan
%   gvad_fit               - Fit velocity using gradient-based least squares
%   gvad_response          - Compute GVAD response variable
%   local_search           - Perform a local search based on least squares refitting
%   local_search_numerical - Perform numerical local search
%   local_search_prior     - Perform a local search with prior via least squares refitting
%   marg_gausspot          - Marginalize a Gaussian potential
%   multiply_gausspot      - Multiply together several potentials of same size
%   new_gausspot           - Create a new Guassian potential
%   pot2moment             - Convert from information form to moment form (i.e. get mean
%   vvp_dealias            - Dealias a volume using a velocity profile
%   wrapped_normal_nll     - Compute the wrapped normal negative log likelihood
%
% NARR ingest and manipulation
%   height2pressure   - Convert from height to atmospheric pressure
%   narr_grid         - Returns struct describing the NARR x,y grid
%   narr_height2level - Convert from height to pressure index for NARR data
%   narr_level2height - Convert from pressure index to height for NARR data
%   narr_ll2xy        - Convert from lon, lat to NARR x,y coordinates
%   narr_radial_vel   - Get radialized wind velocity from NARR data
%   narr_read_wind    - Read u and v wind from NARR 3D file
%   narr_reset_proj   - Reset map projection cached value
%   narr_set_proj     - Set m_map to use the NARR projection
%   narr_wind_file    - Returns the NARR wind filename for given timestamp
%   narr_wind_profile - Get NARR vertical wind profile for specified location
%   narr_xy2ij        - Convert from NARR x,y coordinates to i,j indices into NARR grid
%   narr_xy2ll        - Convert from NARR x,y coordinates to lon,lat
%   pressure2height   - Convert from atmospheric pressure to height
%   radialize         - Radialize a velocity field
%
% Spatial grids
%   create_grid - Return a structure defining a 2D spatial grid
%   grid_edges  - Return grid cells edges
%   grid_points - Return all grid points
%   xy2ij       - Convert from x,y coordinates to i,j grid indices
%
% Utilities
%   arrows            - Generalised 2-D arrows plot
%   circ_mean         - Compute mean direction
%   csv2struct        - Parse a csv file to a struct array
%   deg2rad           - Convert degrees to radians
%   expand_struct     - Convert a struct of arrays into an array of structs.
%   freezeColors      - Lock colors of plot, enabling multiple colormaps per figure. (v2.3)
%   imagescnan        - imagesc with NaN as transparent
%   join_struct       - Join two struct arrays on specified fields
%   joinstr           - Join strings with a delimiter
%   logsumexp         - Returns log(sum(exp(a),dim)) while avoiding numerical underflow.
%   nanmax            - Max of non-NaN elements
%   nanmean           - Return mean of non-NaN elements
%   nanmin            - Min of non-NaN elements
%   nansum            - Return sum of non-NaN elements
%   rad2deg           - Convert radians to degrees
%   rank_order        - Compute rank order of entries in a vector
%   sample_narr_file  - Path of sample NARR file
%   sample_radar_file - Path of sample radar file
%   struct2csv        - Convert struct array to csv file
%   vec               - Vectorize a matrix



