function ind=insidep(xg,yg);
% INSIDEP  Find all the points strictly inside an interactively draw polygon
%          drawn on the currently displayed plot.  The plot should be
%          drawn with xg and yg as dots before.
%         
%   USAGE  ind=insidep(xg,yg);
%
%           xg = x locations of points
%           yg = y locations of points
%
%   Example:  x=rand(20,1);y=rand(20,1);
%             plot(x,y,'kx');
%             ind=insidep(x,y);
%         (then click continuously with left mouse to 
%          draw polygon until done, then click right mouse
%          to compute points inside.)
%           

[x,y]=draw;
n=length(x);
x(n+1)=x(1);
y(n+1)=y(1);
line(x,y,'color','cyan','linestyle','o','erasemode','none')
line(x,y,'color','cyan','linestyle','-','erasemode','none')
%
ind=insider(xg,yg,x,y); 
%
%  ind=0 outside polygon
%  ind=1 inside
%  ind=2 on exterior edge
%  ind=4 on exterior vertex
%
line(xg(ind==1),yg(ind==1),'color','green','linestyle','o','erasemode','none')
line(xg(ind==2),yg(ind==2),'color','red','linestyle','o','erasemode','none')
line(xg(ind==4),yg(ind==4),'color','white','linestyle','o','erasemode','none')
%
%  return indices of inside points only
%
ind=find(ind==1);
hold off
