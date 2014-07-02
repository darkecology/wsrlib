function [ pot ] = expand_gausspot( pot, pos )
%EXPAND_GAUSSPOT Expand a potential to more variables

pos = pos(:);

pot.K = kron(diag(pos), pot.K);
pot.b = kron(pos, pot.b);

end

