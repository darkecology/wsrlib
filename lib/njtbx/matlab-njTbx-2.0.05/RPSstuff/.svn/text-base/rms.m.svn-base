function y=rms(u);
%RMS y=rms(u)
% Compute root mean square for each
% column of matrix u
%
[m,n]=size(u);
if (min(m,n)==1),
  u=u(:);
  m=length(u);
end
y=sqrt(sum(u.^2)/m);
