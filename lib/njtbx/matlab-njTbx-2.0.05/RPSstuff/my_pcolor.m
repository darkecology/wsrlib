function my_pcolor(x,y,z);
dx=x(2)-x(1);
dy=y(2)-y(1);
x1=[x-dx x(end)+dx];
y1=[y-dy y(end)+dy];
z1=z([1:end end],[1:end end]);
pcolor(x1,y1,z1)
shading flat
