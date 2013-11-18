[x,y,z]=peaks;
xi=rand(20)*6-3;
yi=rand(20)*6-3;
zi=interp2(x,y,z,xi,yi);
[znew,zerr]=objan(xi,yi,zi,.5,.5,1,x,y);

set(gcf,'pos',[400 100 600 800]);
subplot(221);
pcolor(x,y,z);shading flat
title('Original Peaks');
hold on; plot(xi,yi,'k.');hold off
cax=caxis;colorbar;axis square; 

subplot(222);
pcolor(x,y,znew);shading flat
title('OA Peaks');
hold on; plot(xi,yi,'k.');hold off
caxis(cax);axis square;colorbar

subplot(223);
pcolor(x,y,zerr);shading flat
title('Est. OA Error');
hold on; plot(xi,yi,'k.');hold off
cax=caxis; axis square; colorbar

subplot(224);
pcolor(x,y,abs(z-znew));shading flat
title('Actual OA Error');
hold on; plot(xi,yi,'k.');hold off
axis square;colorbar 

