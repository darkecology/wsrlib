function install_cajun()
% INSTALL_CAJUN One-time installation for cajun
% 
% Run this script for one-time compilation, etc. of toolboxes used by cajun
% 
% If you pull in additional toolboxes that need to be compiled for each
% machine/platform, add their installation commands below.

cajundir = fileparts(mfilename('fullpath'));

%%%%%%%%%%%%%%%%%%%%%% 
% rsl
%%%%%%%%%%%%%%%%%%%%%% 
fprintf('********** Compiling rsl ************\n\n');

status = system(sprintf('make -C %s/lib/rsl2mat/rsl', cajundir), '-echo');
if status ~= 0
    error('Failed to compile rsl');
end

fprintf('\n\nSuccessfully compiled rsl\n\n');

%%%%%%%%%%%%%%%%%%%%%% 
% rsl2mat
%%%%%%%%%%%%%%%%%%%%%% 
addpath(sprintf('%s/lib/rsl2mat', cajundir));
make_rsl2mat();

