function wysiwyg2
%WYSIWYG2 -- this function is called with no args and merely
%       changes the size of the figure that will be printed
%       to match the screen.  This is similar to WYSIWYG except
%       that it changes the paper to match the screen rather than
%       the screen to match the paper.

% Rich Signell rsignell@usgs.gov  
     
un=get(gcf,'units');
pun=get(gcf,'paperunits');
set(gcf,'units','inches');
pos=get(gcf,'pos');
set(gcf, 'paperunits', 'inches', 'paperposition',[0 0 pos(3:4)]);
%reset paper units to original values
set(gcf,'units',un);
set(gcf,'paperunits',pun);
