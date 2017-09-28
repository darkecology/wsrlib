function wsrlib_setup()
% WSRLIB_SETUP Setup paths for wsrlib
%
% Best practice: place the following commands in your MATLAB startup.m
% file:
%
% addpath('/path/to/wsrlib');
% wsrlib_setup();

% If you another subdirectory contains utility functions and should be on
% the MATLAB path, add it below.

if isdeployed
    return;
end

root = wsrlib_root();

% Add directories non-recursively when possible to avoid slow commands and
% bloated MATLAB path
addpath(root);
addpath(sprintf('%s/rsl2mat', root));
addpath(sprintf('%s/lib/m_map', root));
addpath(sprintf('%s/lib/jsonlab', root));

% The wsr88d_decode_ar2v executable must be on the system path. Add it here.
rsl_bin_dir = sprintf('%s/rsl2mat/rsl/install/bin', root);
setenv('PATH',  sprintf('%s:%s', getenv('PATH'), rsl_bin_dir) );

addpath(sprintf('%s/examples', root));

addpath(sprintf('%s/src/grid', root));
addpath(sprintf('%s/src/nwp', root));
addpath(sprintf('%s/src/test', root));
addpath(sprintf('%s/src/radar', root));
addpath(sprintf('%s/src/vvp', root));
addpath(sprintf('%s/src/util', root));
addpath(sprintf('%s/src/aws', root));
%addpath(sprintf('%s/src/quarantine', root)); % Once all bugs are fixed, wsrlib should no longer depend on methods in this folder
addpath(sprintf('%s/src/util/colormaps', root));

% Setup netcdf-java toolbox. Includes java files
addpath(genpath(sprintf('%s/lib/njtbx', root)));

javaaddpath(sprintf('%s/lib/njtbx/jar/toolsUI-4.0.49.jar', root),'-end');
javaaddpath(sprintf('%s/lib/njtbx/jar/njTools-2.0.12_jre1.6.jar', root),'-end');
