function [v,d,z]=eof(u)
%EOF  Empirical orthogonal functions.
% [v,d,z]=eof(u)
% time series components stored as column vectors in u.
% v is the matrix of eigenvectors
% d is a diagonal matrix of eigenvalues
% z is the time series of mode amplitudes, stored as column vectors
%
% Reference: "Wallace and Dickinson, 1972, Journal of Applied
% Meteorology, V 11, N 6, p 887-892.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 2.0  modified by DAF 1/10/96 to account for bug in eig + add comments
% corrected 11/23/98 to account for complex eofs where Z=u*conj(v)
%
u=denan(u); %get rid of rows with missing data
cc=cov(u);
[v,d]=eig(cc,'nobalance');
d=diag(d,0);
%
% now we need to sort just in case eig did not
%
[newd,ord]=sort(d);
newv=v(:,[ord]);
if mean(newv(:,1)-v(:,1))~=0
   d=newd;
   v=newv;
   disp('vectors resorted');
end
if abs(d(1))<abs(d(length(d)))    % swap things into decending order
      d=d(length(d):-1:1);
      v=v(:,length(d):-1:1);
end

z=u*conj(v);   % accounts for complex matrices u

