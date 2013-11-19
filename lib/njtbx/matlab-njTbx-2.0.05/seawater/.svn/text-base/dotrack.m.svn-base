[x,y]=maketrack([-70.41 -70.94],[42.58 42.45],.25)
saveascii('/usr/users/rps/harley/track1.dat',[x y],'%12.6f %12.6f\n');

[x,y]=maketrack([-70.33 -70.84],[42.48 42.37],.25)
saveascii('/usr/users/rps/harley/track2.dat',[x y],'%12.6f %12.6f\n');

[x,y]=maketrack([-70.25 -70.75],[42.37 42.27],.25)
saveascii('/usr/users/rps/harley/track3.dat',[x y],'%12.6f %12.6f\n');

cd /usr/users/rps/harley
!grdtrack track1.dat -Gharley.grd > /usr/www/steve/track1.xyz
!grdtrack track2.dat -Gharley.grd > /usr/www/steve/track2.xyz
!grdtrack track3.dat -Gharley.grd > /usr/www/steve/track3.xyz
