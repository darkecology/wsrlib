function cmap = cmap_interpolate(colors, splits, n)
% 
% cmap = cmap_interpolate(colors, splits, n)
%
% Create a colormap that interpolates between the specified colors
% in the positions specified by splits.
%
%   - colors is an m x 3 array of rgb values
%   - split is an m x 1 vector of positions (between 0 and 1) that
%      indicate where colors(i,:) should appear in the final colormap
%   - n is the length of the desired colofmap
%
% Between the positions specified by splits, the colors are determined
% by linear interpolation in RGB space.

  [m,k] = size(colors);
  
  if k ~= 3
    error 'Colors must be an m x 3 RBG matrix';
  end
  
  if length(splits) ~= m
    error 'splits is the wrong size'
  end
    
  inds = (1:n)';
  coords = (inds-1)/(n-1);		% map to [0,1]
  cmap = zeros(n,3);

  % pad so the first and last colors are extended if necessary
  splits = [Inf; 
	    splits(:); 
	    Inf];
  
  colors = [colors(1,:)
	    colors
	    colors(end,:)];
  
  % do the interpolation
  for j=1:m+1
    
    pos = splits(j);
    nextpos = splits(j+1);
    I = find(coords >= pos & coords < nextpos);
    alpha = (coords(I) - pos)/(nextpos - pos);

    cmap(I,:) = (1-alpha)*colors(j,:) + alpha*colors(j+1,:);
  end
