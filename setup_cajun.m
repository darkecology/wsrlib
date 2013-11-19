function setup_cajun()
% SETUP_CAJUN Add paths for cajun codebase
%
% Best practice: place the following commands in your MATLAB startup.m
% file:
%
% addpath('/path/to/cajun');
% setup_cajun();
%
% If you another subdirectory contains utility functions and should be on
% the MATLAB path, add it below.

if isdeployed
    return;
end

cajundir = fileparts(mfilename('fullpath'));

% Add directories non-recursively when possible to avoid slow commands and
% bloated MATLAB path
addpath(cajundir);
addpath(sprintf('%s/lib/m_map', cajundir));
addpath(sprintf('%s/src/narr', cajundir));
addpath(sprintf('%s/workflow', cajundir));
addpath(sprintf('%s/lib/rsl2mat', cajundir));
addpath(sprintf('%s/tst', cajundir));
addpath(sprintf('%s/src/radar', cajundir));
addpath(sprintf('%s/src/util', cajundir));
addpath(sprintf('%s/src/radar/vvp', cajundir));
addpath(sprintf('%s/src/util/colormaps', cajundir));
addpath(sprintf('%s/src/radar/clutterMaps', cajundir));

% Setup netcdf-java toolbox. Includes java files
addpath(genpath(sprintf('%s/lib/njtbx', cajundir)));

javaaddpath(sprintf('%s/lib/njtbx/jar/toolsUI-4.0.49.jar', cajundir),'-end');
javaaddpath(sprintf('%s/lib/njtbx/jar/njTools-2.0.12_jre1.6.jar', cajundir),'-end');
