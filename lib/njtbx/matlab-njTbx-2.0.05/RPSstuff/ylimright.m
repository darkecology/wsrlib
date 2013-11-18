function ax=ylimright(b)
% YLIMRIGHT  labels right hand yaxis  without drawing anything
% Usage: ax=ylimright(b)
%    where b = [min max] are the axis limits 
%         ax = axis handle
% Example:  ylimright([0 200]);

ax = axes('position',get(gca,'position'));
set(ax,'YAxisLocation','right','color','none', ...
          'xgrid','off','ygrid','off','box','off');
set(ax,'XTickLabel',[]);
ylim(b)
