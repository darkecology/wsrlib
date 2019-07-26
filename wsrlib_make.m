function wsrlib_make()
% WSRLIB_MAKE One-time compile and install for wsrlib
% 
% Run this script for one-time compilation, etc. of toolboxes used by wsrlib
% 
% If you pull in additional toolboxes that need to be compiled for each
% machine/platform, add their installation commands below.

root = wsrlib_root();

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

%%%%%%%%%%%%%%%%%%%%%%
% Compile matconvnet
%%%%%%%%%%%%%%%%%%%%%%
mex -setup C++
addpath(fullfile(root, '/lib/matconvnet-1.0-beta24/matlab'));
vl_compilenn();

%%%%%%%%%%%%%%%%%%%%%%
% Download the neural net locally if needed
%%%%%%%%%%%%%%%%%%%%%%
net_url = 'http://doppler.cs.umass.edu/sharedModels/multielev_sunset_largeset_74.mat';
net_local_file = sprintf('%s/data/mistnet.mat', root);

if ~exist(net_local_file, 'file')
    fprintf('Downloading net from %s\n', net_url);
    try
        websave(net_local_file, net_url);
    catch
        fprintf('Download failed\n');
        if exist(net_local_file, 'file')
            fprintf('Deleting local file\n');
            delete(net_local_file);
        end
    end
end



