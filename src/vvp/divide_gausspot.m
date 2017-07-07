function [ pot ] = divide_gausspot( numer, denom )
%DIVIDE_GAUSSPOT Divide two Guassian potentials
%

pot.K = numer.K - denom.K;
pot.b = numer.b - denom.b;

end

