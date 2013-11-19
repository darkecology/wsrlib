function e=bilinear(ll,lr,ul,ur,ifrac,jfrac);
% BILINEAR interpolation
% usage: e=bilinear(ll,lr,ul,ur,ifrac,jfrac);
% or     e=bilinear(corners,ifrac,jfrac);
% ll = value at lower left
% lr = value at lower right
% ul = value at upper left
% ur = value at upper right
% corners=[ll lr ul ur];
if(nargin==3),
    ifrac=ul;
    jfrac=lr;
    if(length(ll(:))==4),
        ur=ll(4);
        ul=ll(3);
        lr=ll(2);
        ll=ll(1);
    else
        ll=ll(:,:);
        ur=ll(:,4);
        ul=ll(:,3);
        lr=ll(:,2);
        ll=ll(:,1);
    end
end
%interpolate across at top and bottom
a1=ll+ifrac*(lr-ll);
a2=ul+ifrac*(ur-ul);
%interpolate the average down
e=a1+jfrac*(a2-a1);