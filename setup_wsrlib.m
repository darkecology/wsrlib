function setup_wsrlib()
% SETUP_WSRLIB Add paths for wsrlib codebase
%
% Best practice: place the following commands in your MATLAB startup.m
% file:
%
% addpath('/path/to/wsrlib');
% setup_wsrlib();
%
% If you another subdirectory contains utility functions and should be on
% the MATLAB path, add it below.

if isdeployed
    return;
end

root = fileparts(mfilename('fullpath'));

% Add directories non-recursively when possible to avoid slow commands and
% bloated MATLAB path
addpath(root);
addpath(sprintf('%s/rsl2mat', root));
addpath(sprintf('%s/lib/m_map', root));

addpath(sprintf('%s/src/grid', root));
addpath(sprintf('%s/src/narr', root));
addpath(sprintf('%s/src/test', root));
addpath(sprintf('%s/src/radar', root));
addpath(sprintf('%s/src/vvp', root));
addpath(sprintf('%s/src/util', root));
addpath(sprintf('%s/src/quarantine', root)); % Once all bugs are fixed, wsrlib should no longer depend on methods in this folder
addpath(sprintf('%s/src/util/colormaps', root));

% Setup netcdf-java toolbox. Includes java files
addpath(genpath(sprintf('%s/lib/njtbx', root)));

javaaddpath(sprintf('%s/lib/njtbx/jar/toolsUI-4.0.49.jar', root),'-end');
javaaddpath(sprintf('%s/lib/njtbx/jar/njTools-2.0.12_jre1.6.jar', root),'-end');
