function Z = replace_val(Z, a, b)
  if nargin < 3
      b = nan;
  end
  Z(Z==a) = b;
