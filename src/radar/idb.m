function [ z ] = idb( dbz )
%IDB Inverse decibel (convert from decibels to linear units)
%
%  z = idb( dbz )
%
%  z = 10.^(dbz/10);

z = 10.^(dbz/10);
end

