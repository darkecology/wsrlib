% INDEMO   Demo program for function INSIDE
%          This script file lets you draw a polygon using the mouse, then
%          it shows which points on a (blue) grid are inside the polygon.
%   

%RP (WHOI) 19/Dec/91
%          Updated for Matlab 4.0 7/nov/92

% updated to version 5.1 AN
      
clf;

   % create the grid

xgp=[0:30]/30*2-1;
ygp=xgp';

tol=(xgp(2)-xgp(1))/3;

xg=ones(size(ygp))*xgp;
yg=ygp*ones(size(xgp));
xg=xg(:); yg=yg(:);

pts=plot(xg,yg,'.k','EraseMode','none');
axis([-1 1 -1 1]);
set(gca,'xticklabels',' ');
set(gca,'yticklabels',' ');
title('Left button = new point,     Right button = done');
drawnow
hold on
   % make the polygon using the mouse

    % Make a graphic object for the polygon
gpt=line(0,0,'Linestyle','.','Erasemode','none');
    % Temporarily get rid of the grid points for speed
set(pts,'XData',0,'YData',0);

x=[];
y=[];

disp('Left button for new point, right button to finish making polygon');

[x,y,button]=ginput(1);
set(gpt,'XData',x,'YData',y,'LineStyle','+','Color','r');drawnow
[xx,yy,button]=ginput(1);
while (button ~=3),
   x=[x;xx];
   y=[y;yy];
   set(gpt,'XData',x,'YData',y,'LineStyle','-','Color','r');drawnow
   [xx,yy,button]=ginput(1);
end;
 
   % do the work

ind=inside(xg,yg,x,y,tol); % low tolerance to make edges appear more frequently

   % put the grid back in, and add the results.
set(pts,'XData',xg,'YData',yg);
line('XData',xg(ind==1),'YData',yg(ind==1),'Linestyle','+','Color','g','Erasemode','none');
line('Xdata',xg(ind==2),'YData',yg(ind==2),'Linestyle','o','Color','r','Erasemode','none');
drawnow

hold off
