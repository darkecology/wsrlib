% VVP
%
% Files
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
