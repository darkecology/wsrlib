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

cajundir = fileparts(mfilename('fullpath'));

% Add directories non-recursively when possible to avoid slow commands and
% bloated MATLAB path
addpath(cajundir);
addpath(genpath(sprintf('%s/lightspeed', cajundir)));
addpath(sprintf('%s/m_map', cajundir));
addpath(sprintf('%s/narr', cajundir));
addpath(sprintf('%s/rsl2mat', cajundir));
addpath(sprintf('%s/scripts', cajundir));
addpath(sprintf('%s/util', cajundir));
addpath(sprintf('%s/vvp', cajundir));
addpath(sprintf('%s/colormaps', cajundir));

% Setup netcdf-java toolbox. Includes java files
addpath(genpath(sprintf('%s/njtbx', cajundir)));
javaaddpath(sprintf('%s/njtbx/jar/toolsUI-4.0.49.jar', cajundir),'-end');
javaaddpath(sprintf('%s/njtbx/jar/njTools-2.0.12_jre1.6.jar', cajundir),'-end');
