function result = getData(mVarObj, start, count, stride)
%mVar/getData - Read data from variable.
%
% Method Usage:
%   data=getData(mVarObj)  - Read the entire dataset
%   data=getData(mVarObj, start, count)
%   data=getData(mVarObj, start, count, stride)  - Read hyperslab by 
%                                                     specifying corner and edges.
% where,
%   mVarObj - mVar object
%   start - A 1-based array specifying the position in the file to begin reading or corner of a
%           hyperslab e.g [1 2 1]. Specify 'inf' for last index.
%           The values specified must not exceed the size of any dimension of the data set.
%   count - A 1-based array specifying the length of each dimension to be read. e.g [6 10 inf]. 
%           Specify 'inf' to get all the values from start index.
%   stride [optional] - A 1-based array specifying the interval between the
%                       values to read. e.g [1 2 2]
% returns,
%   data - matlab array
%
% e.g.
%   Assuming Array shape is [8,20,60,160]
%   data=getData(mVarObj);  - all data      
%   data=getData(mVarObj,[1 1 1 1],[1 1 20 inf],[1 1 2 2]);  %hyperslab
%   data=getData(mVarObj,[1 1 1 1],[1 1 20 inf]); 
%
% Data can also be accessed by using matlab subscripting references with 'mVar' object.
%
% Usage:
%   data = mVarobj(i,j, ...);
% where,
%       mVarObj - mVar object
%       i/j/k... - startindex:stride:endindex
% returns,
%   data - matlab array
%
% e.g.
%   Assuming Array shape is [8,20,60,160]
%   data = mVarobj(:,2:2:20,1:59,1:160); 
%   data = mVarobj(1,2:2:20,1:59,1:end);
%
% As a convenience method, the variable data can be directly retrieved 
% from netcdf data object(mDataset) without creating variable object.
%e.g.
% data = mDatasetObj{'variable_name'}(1,20,1:60,1:end);
%          
%
%   See also mGeoGridVar/getData
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.

%init
result = [];

if nargin < 1, help(mfilename), return, end

myShape = mVarObj.myShape;
myArgin = nargin;
myStride = ones(1, length(myShape));

if (myArgin == 3)
    stride=myStride;
    myArgin = myArgin + 1;
end

myVarId = getVarId(mVarObj);

try
    switch myArgin
        case 1
            result = njReadVariable(myVarId);
        case 4
            result = njReadVariable(myVarId, start, count, stride);
        otherwise, error('MATLAB:mVar:read:Nargin',...
                'Incorrect number of arguments');
    end
catch %gets the last error generated
    err = lasterror();
    disp(err.message);
end


end
