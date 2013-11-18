function ind=inside(x,y,xv,yv,tol);
% INSIDE  determines if points are inside/outside a polygon.
%         IND=INSIDE(X,Y,XV,YV) is a vector of flags corresponding to
%         the vector of points X,Y. If
%
%       -  X(i),Y(i) is outside the polygon XV,YV       : IND(i)=0
%       -  X(i),Y(i) is inside   "   "       "  "       : IND(i)=1
%       -  X(i),Y(i) is near (but outside) the polygon  : IND(i)=2
%
%         Points classified as "near" are actually outside
%         the polygon, but less than approx TOL away (This is sometimes
%         useful for identifying "peninsulas" when gridding data).
%
%         XV,YV is an ordered list of polygon vertices. The last point
%         in the list (identical to the first point) may be omitted.
%         There is no restriction on the shape of the polygon.
%
%         IND=INSIDE(...,TOL) sets a tolerance for identifying "nearby"
%         points. (the default is 1e-6). 

%RP (WHOI) 19/Dec/91
%   - this routine uses the fact that the sum of angles between
%     lines from a point to successive vertices of a polygon is 0
%     for a point outside the polygon, and +/- 2*pi for a point
%     inside. A point on an edge will have one such succesive angle
%     equal to +/- pi. 
%RP (WHOI) 5/Dec/92
%   - some bulletproofing for really wierd checkerboard polygons and
%     single point "polygons".
%RP (WHOI) 6/Dec/92
%   - Redid edge stuff a little better to allow  "rounded gridding"
%     i.e. getting grid points within some TOL of the polygon.
%
%	updated to version 5.1  AN

if (nargin<5),
   tol=1e-6;
end;

% Put things into rows or columns...
x=x(:)';
y=y(:)';
xv=xv(:);
yv=yv(:);

NP=length(x);
NV=length(xv);

if (NP~=length(y)), error('Point x,y vectors of unequal length!'); end;
if (NV~=length(yv)), error('Polygon vertex x,y vectors of unequal length!');end;

   % If last point is missing append it

if ( (xv(NV) ~= xv(1)) | (yv(NV) ~= yv(1))),
   xv=[xv;xv(1)];
   yv=[yv;yv(1)];
   NV=NV+1;
end;                      

    % distances from points to vertices

dx=ones(NV,1)*x-xv*ones(1,NP);  
dy=ones(NV,1)*y-yv*ones(1,NP);

    % If we have only 1 point in the polygon, we can only search
    % for matches to the "vertex". Otherwise we do all the tests.

if (NV==1),
   vertexpt=( abs(dx)<tol & abs(dy)<tol );
   ind=2*vertexpt;
else

        % Test for points at vertices

   vertexpt=any( abs(dx)<tol & abs(dy)<tol );

        % Compute angular intervals between vertex points. We shift
        % to put things in the range -pi<= ang <pi, with some slop for
        % possible edge points

   angs=rem( diff(atan2(dy,dx)) + 3*pi+eps , 2*pi ) - pi-eps;

        % Look for points "near" the edge - acts to smear out the polygon
        % edge by tol - useful for(maybe) neglecting shallow water?
 
        % If a point is closest to a given segment at an endpoint, it
        % may be a vertex - since we have found these points above, we can 
        % ignore them. If the closest point is in the middle of a segment,
        % classify it as an edge if the dx or dy displacements are < tol
        % (strictly speaking I suppose we should test sqrt(dx.^2+dy.^2)<tol
        % but this is faster).

   dxv=(xv(2:NV)-xv(1:NV-1))*ones(1,NP);
   dyv=(yv(2:NV)-yv(1:NV-1))*ones(1,NP);
   dxl=dx(1:NV-1,:);
   dyl=dy(1:NV-1,:);
   
        % Projection onto segment. if 0<lgt<1 closest point is in the
        % middle of the segment!

   lgt=(dxl.*dxv + dyl.*dyv)./(dxv.*dxv+dyv.*dyv);
   distx=2*tol*ones(NV-1,NP); disty=distx;

   ii=(lgt>0 & lgt < 1);
   distx(ii)=dxl(ii)-lgt(ii).*dxv(ii);
   disty(ii)=dyl(ii)-lgt(ii).*dyv(ii);
   
   edgept= any( abs(distx)<tol & abs(disty)<tol );

        % If the angles sum to 0, 4*pi, etc., we are outside - if they 
        % sum to  2*pi, 6*pi, etc. we are inside. This will result in a
        % "checkerboard" inside/outside classification when polygon 
        % segments intersect.

   interiorpt=rem( abs(round( sum(angs)/(2*pi) )) , 2);

        % Classify points by priority 

   ind=2*edgept;
   ind(logical(vertexpt))=2*ones(sum(vertexpt),1);
   ind(logical(interiorpt))=ones(sum(interiorpt),1);
end;
