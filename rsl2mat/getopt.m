function opt = getopt(default, opt)
%
%  opt = getopt(default, opt)
%
%  Fills in defaults in a struct by taking the union of the fields in 
%  default and opt, with precedence given to fields set in opt

  if isempty(opt)
    return
  end
  
  names = fieldnames(opt);
  for i = 1:length(names)
      default.(names{i}) = opt.(names{i});
  end
  opt = default;