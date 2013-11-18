ncRef ='http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/test/bora_feb.nc';
klev=20;
tic;
% Create mDataset object
nc=mDataset(ncRef);
% get global attribute 'title' using matlab subscripted reference '.'.
title1=nc.title;
% access subsetted data and grid using matlab subscripted reference
% '{},'()' and '.';
udata=nc{'u'}(5,20,:,:).data;
ugrid=nc{'u'}(5,20,:,:).grid;
% get attribute value for var
title2=nc{'u'}.long_name;
% access var data as non-gridded
ubar=squeeze(mean(nc{'ubar'}(5:8,klev,:,:)));

close(nc);
toc;
whos 
title1
ugrid
title2

