
station = 'KBOX';

fileinfo = aws_list('KBOX', 2014, 8, 01, 23 );

thefile = fileinfo(1);
system( sprintf('aws s3 cp s3://noaa-nexrad-level2/%s .', thefile.key ) );

% Write file
radar = rsl2mat(thefile.name, station);
rmax = 150000;
dim = 600;
dzmap = jet(32);
[z, x, y] = sweep2cart(radar.dz.sweeps(1), rmax, dim);    
dz_gif = mat2ind(z, [-5 30], dzmap);
imwrite_gif_nan( dz_gif, dzmap, 'dz.gif' );
