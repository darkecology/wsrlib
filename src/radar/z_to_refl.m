function [ eta, db_eta ] = z_to_refl( z, lambda )
%Z_TO_REFL Convert Z to reflectivity
%
% [eta, db_eta] = z_to_refl( z, wavelength )
%
% Inputs:
%   z            Vector of Z values (reflectivity factor; units: mm^6/m^3)
%   wavelength   Radar wavelength (units: meters; default = 0.1071 )
% Outputs:
%   eta          Vector of reflectivity values (units: cm^2/km^3 )
%   db_eta       Decibels of eta (10.^(eta/10))
%
% See also REFL_TO_Z, CONVERT_WAVELENGTH

% Reference: 
%  Chilson, P. B., W. F. Frick, P. M. Stepanian, J. R. Shipley, T. H. Kunz, 
%  and J. F. Kelly. 2012. Estimating animal densities in the aerosphere 
%  using weather radar: To Z or not to Z? Ecosphere 3(8):72. 
%  http://dx.doi.org/10.1890/ ES12-00027.1
%
%
% UNITS
%      Z units = mm^6 / m^3   
%              = 1e-18 m^6 / m^3
%              = 1e-18 m^3
%
% lambda units = m
%
%    eta units = cm^2 / km^3  
%              = 1e-4 m^2 / 1e9 m^3 
%              = 1e-13 m^-1
%
% Equation is
%
%           lambda^4
%  Z_e = -------------- eta    (units 1e-18 m^3)
%         pi^5 |K_m|^2
%
%
%         pi^5 |K_m|^2
%  eta = -------------- Z_e    (units 1e-13 m^-1)
%          lambda^4
%

if nargin < 2
    lambda = 0.1071;
end

K_m_squared = 0.93;
log_eta = log10(z) + 5*log10(pi) + log10(K_m_squared) - 4*log10(lambda);

% Current units: Z / lambda^4 = 1e-18 m^3 / 1 m^4 
%                             = 1e-18 m^3 / 1 m^4
%                             = 1e-18 m^-1
%
% Divide by 10^5 to get units 1e-13

log_eta = log_eta - 5;  % Divide by 10^5

db_eta = 10*log_eta;
eta    = 10.^(log_eta);

end
