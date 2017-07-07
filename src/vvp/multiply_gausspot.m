function [ pot ] = multiply_gausspot( varargin )
%MULTIPLY_GAUSSPOT Multiply together several potentials of same size

n = nargin;

if nargin == 0
    error('No potentials');
end

pot = varargin{1};
for i=2:n
    newpot = varargin{i};
    pot.K = pot.K + newpot.K;
    pot.b = pot.b + newpot.b;
end

end

