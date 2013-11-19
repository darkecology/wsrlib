function ind=insider(x,y,xv,yv,tol);
% INSIDER  determines if points are inside/outside a polygon.
%         IND=INSIDER(X,Y,XV,YV) is a vector of flags corresponding to
%         the vector of points X,Y. If
%
%       -  X(i),Y(i) is outside the polygon XV,YV     : IND(i)=0
%       -  X(i),Y(i) is inside   "   "       "  "     : IND(i)=1
%       -  X(i),Y(i) is on an edge of the polygon     : IND(i)=2
%       -  X(i),Y(i) is a vertex of the polygon       : IND(i)=4
%
%         If a point falls into several categories, it is classified as
%         with the flag of greatest numerical value (i.e. a point on an
%         interior edge is given a flag value of 2).
%
%         XV,YV is an ordered list of polygon vertices. The last point
%         in the list (identical to the first point) may be omitted.
%         There is no restriction on the shape of the polygon.
%
%         IND=INSIDER(...,TOL) sets a tolerance for assigning points
%         to edges or vertices. (the default is 1e-6). 

%RP (WHOI) 19/Dec/91
%   - this routine uses the fact that the sum of angles between
%     lines from a point to successive vertices of a polygon is 0
%     for a point outside the polygon, and +/- 2*pi for a point
%     inside. A point on an edge will have one such succesive angle
%     equal to +/- pi. 
%RP (WHOI) 5/Dec/92
%   - some bulletproofing for really wierd checkerboard polygons and
%     single point "polygons". 

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
   ind=4*vertexpt;
else

        % Test for points at vertices

   vertexpt=any( abs(dx)<tol & abs(dy)<tol );

        % Compute angular intervals between vertex points. We shift
        % to put things in the range -pi<= ang <pi, with some slop for
        % possible edge points

   angs=rem( diff(atan2(dy,dx)) + 3*pi+tol , 2*pi ) - pi-tol;

        % If ang= -pi then we are on an edge

   edgept=any( abs(angs+pi)<tol );

        % If the angles sum to 0, 4*pi, etc., we are outside - if they 
        % sum to  2*pi, 6*pi, etc. we are inside. This will result in a
        % "checkerboard" inside/outside classification when polygon 
        % segments intersect.

   interiorpt=rem( abs(round( sum(angs)/(2*pi) )) , 2);

        % Classify points by priority

   ind=interiorpt;
   ind(edgept)=2*ones(sum(edgept),1);
   ind(vertexpt)=4*ones(sum(vertexpt),1);
end;
