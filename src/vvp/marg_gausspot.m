function [ pot ] = marg_gausspot( bigpot, dom )
%MARG_GAUSSPOT Marginalize a Gaussian potential
%  [ pot ] = marg_gausspot( bigpot, dom )
%
%  dom: domain on which to marginalize

dom = logical(dom);

K = bigpot.K;
b = bigpot.b;

A = K(dom,~dom)*inv(K(~dom,~dom));

pot.K = K(dom,dom) - A*K(~dom,dom);
pot.b = b(dom) - A*b(~dom);

end
