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
%
% AWS s3
%   aws_get_scan - Download a scan from AWS
%   aws_key      - Get key from scaninfo struct
%   aws_list     - Get a list of archive files 
%   aws_parse    - Parse AWS key into constituent parts
%
% Velocity profiling and dealiasing
%   compute_loss           - Compute rmse and wrapped normal neg. log likelihood 
%   divide_gausspot        - Divide two Guassian potentials
%   epvvp                  - Expectation Propagation (EP)-based volume velocity profile
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
%   do_alias               - Alias a value to within interval [-vmax, vmax]
%
% Weather data ingest and manipulation
%   NAM3D           - abstract base class for NAM (North American Mesoscale) data
%   NAM3D_212       - Class for NAM data on grid #212
%   NAM3D_218       - Class for NAM data on grid #212
%   NARR            - class to handle NARR data access
%   NWP             - abstract base class for numerical weather model data
%   height2pressure - Convert from height to atmospheric pressure
%   pressure2height - Convert from atmospheric pressure to height
%   radialize       - Radialize a velocity field
%
% Spatial grids
%   create_grid - Return a structure defining a 2D spatial grid
%   grid_edges  - Return grid cells edges
%   grid_points - Return all grid points
%   xy2ij       - Convert from x,y coordinates to i,j grid indices
%   dxy2dij     - Convert from x, y displacement values to i,j displacement values
%   m_get_bbox  - Get enclosing bounding box in map coordinates of a lat/lon box
%
% Utilities
%   arrows            - Generalised 2-D arrows plot
%   circ_mean         - Compute mean direction
%   csv2struct        - Parse a csv file to a struct array
%   deg2rad           - Convert degrees to radians
%   dzmap_kyle        - A reflectivity colormap obtained from Kyle Horton
%   dzmap_wct         - Reflectivity colormap copied from NOAA's WCT software
%   expand_struct     - Convert a struct of arrays into an array of structs.
%   freezeColors      - Lock colors of plot, enabling multiple colormaps per figure. (v2.3)
%   imagescnan        - imagesc with NaN as transparent
%   imwrite_gif_nan   - Write indexed image as gif with nan --> transparent 
%   imwrite_png_nan   - Write indexed image as png with nan --> transparent 
%   join_struct       - Join two struct arrays on specified fields
%   joinstr           - Join strings with a delimiter
%   logsumexp         - Returns log(sum(exp(a),dim)) while avoiding numerical underflow.
%   nanmax            - Max of non-NaN elements
%   nanmean           - Return mean of non-NaN elements
%   nanmedian         - Compute median of non-NaN elements
%   nanmin            - Min of non-NaN elements
%   nansum            - Return sum of non-NaN elements
%   rad2deg           - Convert radians to degrees
%   rank_order        - Compute rank order of entries in a vector
%   sample_radar_file - Path of sample radar file
%   struct2csv        - Convert struct array to csv file
%   subplot_tight     - A subplot function substitude with margins user tunable parameter.
%   vec               - Vectorize a matrix
%   vrmap             - Basic colormap for radial velocity
%   vrmap2            - Improved colormap for radial velocity
%
