function [ dbz_out ] = convert_wavelength( dbz_in, lambda_in, lambda_out )
%CONVERT_DBZ Convert reflectivity factor dBZ from one wavelength to another
%
% dbz_out = convert_wavelength( dbz_in, lambda_in, lambda_out )
%

% Based on this equation:
%
%           lambda^4
%  Z_e = -------------- eta    (units 1e-18 m^3)
%         pi^5 |K_m|^2
%
%
% -->        Z_out  =        Z_in  * (lambda_out/lambda_in)^4
% -->    log(Z_out) =    log(Z_in) + 4 *(log(lambda_out) - log(lambda_in))
% --> 10*log(Z_out) = 10*log(Z_in) + 40*(log(lambda_out) - log(lambda_in))

dbz_out = dbz_in + 40*(log10(lambda_out) - log10(lambda_in));

% Another way to do it (gives same answer):
%
% z_in    = undb(dbz_in);
% refl    = z_to_refl(z_in, lambda_in);
% z_out   = refl_to_z(refl, lambda_out);
% dbz_out = db(z_out);

end
