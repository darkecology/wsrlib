function h = cdot_legend(z,mycolormap,z_range,geometry,label)
% cdot_legend:  Place legend for cdot data.
%
% USAGE:
%   h = cdot_legend(z,mycolormap,z_range,geometry,label)
%
% PARAMETERS:
% h:  
%   axis handle of legend
% z:
%   data to use in constructing the legend
% mycolormap:
%   colormap to use for the legend
% z_range:
%   range of the data used to index into the colormap.  Optional.
% geometry:
%   (x,y) for lower left hand corner of legend, plus width and
%   height.  Optional.  Default is [ 0.80 0.15 0.1 0.70 ] in 
%   normalized coordinates.
% label:
%   Optional label for the legend.
%
% EXAMPLE
%  [xx,yy,zz] = peaks(40);
%  [c,h]=contour(xx,yy,zz);clabel(c,h);
%  i=floor(rand(100,1)*40*40);
%  cdot(xx(i),yy(i),zz(i),jet,40,0,[-8 8]);
%  h = cdot_legend(zz(i),jet,[-8 8], [0.95 0.12 0.03 0.60],'km');
%   

if ( nargin < 2 )
    help cdot_legend;
    return;
end

if ( nargin < 3 )
   z_range = [min(z(:)) (max(z(:))+eps)];
end

if nargin < 4
  geometry = [ 0.75 0.15 0.1 0.70 ];
end

if nargin < 5
  label = [];
end

z = z(:);

h=axes('position', geometry);


%
% Clamp the data to be in the allowable range.
zmin = z_range(1);
zmax = z_range(length(z_range))+eps;

ind = find(z<zmin);
z(ind) = zmin*ones(size(ind));
ind = find(z>zmax);
z(ind) = zmax*ones(size(ind));




[r,c] = size(mycolormap);

z_inc = (zmax-zmin)/r;

vertices = [];
faces = [];
face_vertex_colors = [];

if ( geometry(3) > geometry(4) )

   % 
   % Assume we want a horizontal legend.
   set ( h, 'XLim', [zmin zmax], ...
	    'YTick', [] );
    for i = 1:r
    
        vertices = [vertices;
		    zmin+(i-1)*z_inc 0.0 0; ...
                    zmin+(i-1)*z_inc 1.0 0; ...  
		    zmin+i*z_inc 1.0 0; ...
		    zmin+i*z_inc 0.0 0; ...
		     ];   

	faces = [faces; [(i-1)*4+1 (i-1)*4+2 (i-1)*4+3 (i-1)*4+4 ] ];

	face_vertex_colors = [ face_vertex_colors; mycolormap(i,:); ];

    end



else

    % 
    % Assume a vertical legend.
    set ( h, 'YLim', [zmin zmax], ...
	     'XTick', [] );
    for i = 1:r
    
        vertices = [vertices;
		    0.0 zmin+(i-1)*z_inc 0; ...
                    1.0 zmin+(i-1)*z_inc 0; ...  
		    1.0 zmin+i*z_inc 0; ...
		    0.0 zmin+i*z_inc 0;  ];   

	faces = [faces; [(i-1)*4+1 (i-1)*4+2 (i-1)*4+3 (i-1)*4+4 ] ];

	face_vertex_colors = [ face_vertex_colors; mycolormap(i,:); ];

    end


end

pp = patch ( 'Vertices', vertices, ...
             'Faces', faces, ...  
	     'FaceVertexCData', face_vertex_colors, ...  
	     'FaceColor', 'flat', ...  
	     'EdgeColor', 'none' );

if ( ~isempty(label) )
    title(label);
end

return;

