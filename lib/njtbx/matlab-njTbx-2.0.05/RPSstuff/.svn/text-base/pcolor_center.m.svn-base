function [plonn,platn] = pcolor_center(lon,lat,field);
%function [plonn,platn] = pcolor_center(lon,lat,field);
%figure(1)
%clf



[m,n] = size(field);

if size(lon,1) == 1
	lon = ones(m,1)*lon;
elseif size(lon,2) == 1
	lon = ones(m,1)*lon';
end

if size(lat,1) == 1
	lat = lat'*ones(1,n);
elseif size(lat,2) == 1
	lat = lat*ones(1,n);
end


if abs(lat(1,n) - lat(1,1)) > abs(lat(m,1) - lat(1,1))
	lat = lat';
	lon = lon';
	field = field';
	[m,n] = size(field);
end


cfield = [field NaN.*ones(m,1); NaN.*ones(1,n+1)];
slonn = lon;
slatn = lat;
test = diff(slonn')'./2;
test = [test(:,1) test];
plonn = slonn-test;
%plonn =[plonn plonn(:,n)+test(:,n).*2; plonn(m,:) plonn(m,n)+test(m,n)*2];
plonn =[plonn plonn(:,n)+test(:,n).*2; 2.*plonn(m,:)-plonn(m-1,:) 2.*plonn(m,n)-plonn(m-1,n)+test(m,n)*2];
test2 = -diff(slatn)./2;
test2 = [test2(1,:); test2];
platn = slatn+test2;
%platn = [platn platn(:,n); platn(m,:)-test2(m,:).*2 platn(m,n)-test2(m,n)*2];
platn = [platn 2.*platn(:,n)-platn(:,n-1); platn(m,:)-test2(m,:).*2 2.*platn(m,n)-platn(m,n-1)-test2(m,n)*2];


%jcolorbar

%set(gcf,'CurrentAxes',h(2))
%coltem = [1:65].*(max(max(field)) - min(min(field)))./65 + min(min(field));
%pcolor([1 2 3],coltem,[coltem' coltem' coltem'])
%shading flat
%set(gca,'XTick',[])
%axes('position',get(h(2),'position'),'xlim',get(h(2),'xlim'), ...
%     'ylim',get(h(2),'ylim'),'color','none','box','on','xtick',[])


%set(gcf,'CurrentAxes',h(1))
pcolor(plonn,platn,cfield) 

