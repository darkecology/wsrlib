function flipodvpal(in_pal,out_pal);
% FLIPODVPAL  flips an ODV color pallet
% usage:  flipodvpal('Odv.pal','Odv_flip.pal');
d=load(in_pal);
c=d(33:145,2:4);
c=flipud(c);
d(33:145,2:4)=c;
saveascii(out_pal,d,'%3d %5.3f %5.3f %5.3f\r\n');