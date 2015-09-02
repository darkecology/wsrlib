function [ pot ] = new_gausspot( K, b )
% NEW_GAUSSPOT Create a new Guassian potential
%
% pot = new_gausspot(K, b)
%

m = numel(b);
if ~isequal(size(K), [m m])
    error('Sizes do not match');
end

pot.K = K;
pot.b = b(:);

end

