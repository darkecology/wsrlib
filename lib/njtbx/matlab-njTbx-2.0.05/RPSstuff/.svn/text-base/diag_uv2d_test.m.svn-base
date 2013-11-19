function [ubal,vbal,terms]=diag_uv2d_test(ncfile,i,j,iplt);
% DIAG_UV2D_TEST  Test 2D Momentum balance at (i,j) point
%   Usage: [ubal,vbal,terms]=diag_uv2d_test(ncfile,i,j,iplt);
%  
%   Outputs: 
%       ubal = terms in XI-directed balance
%       vbal = terms in ETA-directed balance
%      terms = cell array of term names {'Accel','Hadv','Prsgrd','Strs'}
%
%   Inputs:
%     ncfile = ROMS diagnostics NetCDF file
%          i = i location
%          j = j location
%       iplt = 1 for plot, 0 otherwise
%
%    Example: [ubal,vbal,terms]=diag_uv2d_test('lake_dia.nc',20,5,1);
%             to plot the the term balances at i=20, j=5 for Lake Signell
%
% Rich Signell (rsignell@usgs.gov)
% 9-Dec-2004

nc=netcdf(ncfile);
ubal(:,1)=-nc{'ubar_accel'}(:,j,i);   % note minus sign 
vbal(:,1)=-nc{'vbar_accel'}(:,j,i);   % note minus sign 

ubal(:,2)=nc{'ubar_hadv'}(:,j,i);
vbal(:,2)=nc{'vbar_hadv'}(:,j,i);

ubal(:,3)=nc{'ubar_prsgrd'}(:,j,i);
vbal(:,3)=nc{'vbar_prsgrd'}(:,j,i);
% stress
ubal(:,4)=nc{'ubar_strs'}(:,j,i);
vbal(:,4)=nc{'vbar_strs'}(:,j,i);

close(nc);

usum=sum(ubal,2);
vsum=sum(vbal,2);

terms={'Accel','Hadv','Prsgrd','Strs'};

if (iplt)

vars=terms;
vars{5}='SUM';

set(gcf,'color','white');
subplot(211);
h=plot([ubal usum]);
set(h(5),'color','black','linewidth',2);
xlabel('time steps');grid;legend(vars);
title('XI-directed 2D momemtum balance');

subplot(212);
h=plot([vbal vsum]);
set(h(5),'color','black','linewidth',2);
xlabel('time steps');grid;legend(vars);
title('ETA-directed 2D momentum balance');

end
