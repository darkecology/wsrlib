function CD=z0tocd(z0,zr)
%Z0toCD  Calculates CD at a given ZR corresponding to Z0.
%        CD=Z0TOCD(Z0,ZR)
CD=(.4*ones(size(z0))./log(zr./z0)).^2;
