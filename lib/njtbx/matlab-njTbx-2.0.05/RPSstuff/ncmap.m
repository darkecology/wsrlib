function  w = ncmap;
% new color map, based on HSV puts greys in the 'flat' parts of the colormap
% to increase detail.


w = hsv(250);                                
w = w(1:210,:);   
%w = w(21:230,:);   

wmod = 0.5.*sin([1:210]'.*5.*pi./210).^2 +0.5;

w(:,1) = w(:,1).*wmod;
w(:,2) = w(:,2).*wmod;
w(:,3) = w(:,3).*wmod;

w = flipud(w);

% lighten grey in blue region.
%w(23:63,3) = 1-((1-w(23:63,3)).*0.85);


