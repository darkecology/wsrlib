function install_wsrlib()
% INSTALL_WSRLIB One-time installation for wsrlib
% 
% Run this script for one-time compilation, etc. of toolboxes used by wsrlib
% 
% If you pull in additional toolboxes that need to be compiled for each
% machine/platform, add their installation commands below.

root = fileparts(mfilename('fullpath'));

%%%%%%%%%%%%%%%%%%%%%% 
% rsl
%%%%%%%%%%%%%%%%%%%%%% 
fprintf('********** Compiling rsl ************\n\n');

status = system(sprintf('make -C %s/rsl2mat/rsl', root), '-echo');
if status ~= 0
    error('Failed to compile rsl');
end

fprintf('\n\nSuccessfully compiled rsl\n\n');

%%%%%%%%%%%%%%%%%%%%%% 
% rsl2mat
%%%%%%%%%%%%%%%%%%%%%% 
addpath(sprintf('%s/rsl2mat', root));
make_rsl2mat();
