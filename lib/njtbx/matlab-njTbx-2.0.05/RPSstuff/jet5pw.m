function cmap=jet5pw(n);
% JET5PW  Make a jet colormap with 5% white in middle
% Usage:  cmap=jet5pw(n);
% where n is the number of colormap entries

% rsignell@usgs.gov

cmap=jet(n);
ns=round(n*.05);
for k=(n/2-ns):(n/2+ns),
cmap(k,:)=[1 1 1];
end