function result = end(mVarObj, k, n)
% mVar/end -- Evaluate "end" as an index. (overloaded method)
%  
%  result=end(mVarObj, k, n) returns the value of "end"
%   that has been used as the k-th index in
%   a list of n indices.

% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University 


if nargin < 1, help(mfilename), return, end

varShape = double(getShape(mVarObj));

%if ~(length(varShape) == n)  % Add this code if you require all dims 
%    result = 0;
%else
    if (k <= length(varShape))
        result = varShape(k);
    else
        result = 0;
    end
%end

end
