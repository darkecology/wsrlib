function [x,y]=draw(n);
% DRAW Draws points on the current plot, returning their locations.
%         If n, the number of points is not given, DRAW stops drawing 
%         when you hit right button on mouse
%
%      Usage:   [x,y]=draw(n);
%            n = points to draw
%            x = returned x locations drawn points
%            y = returned y locations drawn points
%
if nargin==0
      n=2000;
end			  
disp('Click left button to draw, right button to quit')
i=1;
[x(1,1),x(1,2),ibutton]=ginput(1);
line(x(1,1),x(1,2),'color','black','Marker','o');
while (i<n)&(ibutton==1) 
  i=i+1;
  [xx,yy,ibutton]=ginput(1);
  if(ibutton==1),
   x(i,1)=xx;
   x(i,2)=yy;
   line(x( (i-1):i,1),x((i-1):i,2), 'color','black','Marker','o');
   line(x(i,1),x(i,2), 'color','black','Marker','o');
  end
end
if nargout==2
  y=x(:,2);
  x=x(:,1);
end


