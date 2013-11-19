[x,y,z]=peaks;
pcolor(x,y,z);shading flat
a=gca;
b=axes('pos',get(a,'pos'));
set(b,'xlim',get(a,'xlim'),'ylim',get(a,'ylim'),'color','none');
grid
