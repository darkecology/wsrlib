function []=thicktext(font_size);
% THICKTEXT  Sets all text to bold, using font_size 
%  Usage: thicktext(font_size);

cha=get(gcf,'children');
for i=1:length(cha);
  ch=get(cha(i),'children');
  set(cha(i),'fontsize',font_size,'fontweight','bold');
  h=get(cha(i),'xlabel')
  set(h,'fontsize',font_size,'fontweight','bold');
  h=get(cha(i),'ylabel')
  set(h,'fontsize',font_size,'fontweight','bold');
  h=get(cha(i),'title')
  set(h,'fontsize',font_size,'fontweight','bold');

  for jj=1:length(ch);
    otype=get(ch(jj),'type');
    if otype(1:4)=='text'
      set(ch(jj),'fontweight','bold','fontsize',font_size);
    end;  % if 'text'
  end
end
