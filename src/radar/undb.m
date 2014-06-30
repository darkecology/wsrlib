function [ z ] = undb( dbz )
%UNDB Convert from decibels to regular units
%
%  z = db( dbz )
%
%  z = 10.^(dbz/10);

z = 10.^(dbz/10);
end

