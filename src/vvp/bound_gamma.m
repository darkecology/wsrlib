function gamma = bound_gamma( sigma, r0, nyq_vel, p )
%BOUND_GAMMA 

delta = invnormcdf(1 - p/2)*sqrt(2)*sigma;
gamma = asin((nyq_vel - delta)/(2*r0));

end

