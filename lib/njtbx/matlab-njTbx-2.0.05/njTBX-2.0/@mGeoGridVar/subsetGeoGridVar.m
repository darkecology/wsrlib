function result = subsetGeoGridVar(mGeoGridVarObj, start, count, stride)
%mGeoGridVar/subsetGeoGridVar - subset gridded variable based on start,count and stride. 
%                               It returns a new subsampled mGeoGridVar object. 
% Method Usage:
%       result=subsetGeoGridVar(mGeoGridVarObj, start, count)
%       result=subsetGeoGridVar(mGeoGridVarObj, start, count, stride)  
% where,
%       mGeoGridVarObj - mGeoGridVar object
%       start - A 1-based array specifying the position in the file to begin reading or corner of a
%           hyperslab e.g [1 2 1]. Specify 'inf' for last index.
%           The values specified must not exceed the size of any dimension of the data set.
%       count - A 1-based array specifying the length of each dimension to be read. e.g [6 10 inf]. 
%           Specify 'inf' to get all the values from start index.
%       stride [optional] - A 1-based array specifying the interval between the
%                       values to read. e.g [1 2 2] 
% returns,
%       result - subsampled mGeoGridVar object.
%       e.g.
%           Assuming Array shape is [8,20,60,160]                 
%           result=subsetGeoGridVar(mGeoGridVarObj,[1 1 1 1],[1 1 20 inf],[1 1 2 1]);  %hyperslab
%           result=subsetGeoGridVar(mGeoGridVarObj,[1 1 1 1],[1 1 20 inf]);
%          
% Grid can also be subsetted by using matlab subscripting references with 'mGeoGridVar' object.
%
% Usage:
%   result = mGeoGridVarobj(i,j, ...);
% where,
%       mGeoGridVarObj - mGeoGridVar object
%       i/j/k... - startindex:stride:endindex
% returns,
%   result - subsampled mGeoGridVar object.
%
% e.g.
%   Assuming Array shape is [8,20,60,160]
%   result = mGeoGridVarobj(:,2:2:20,1:59,1:160); 
%   result = mGeoGridVarobj(1,2:2:20,1:59,1:end);
%
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.

%init
result = [];

if nargin < 3, help(mfilename), return, end

    myShape = mGeoGridVarObj.myShape;
    myArgin = nargin;
    myStride = ones(1, length(myShape));
    
    if (myArgin == 3) 
        stride=myStride; 
        myArgin = myArgin + 1;        
    end
  try    
        switch myArgin               
            case 4                
                subGridObj=njSubsetGrid(mGeoGridVarObj,start,count,stride);
               
                %create a substruct
                subGeoGridVarStruct.myNCid = getNCid(mGeoGridVarObj);
                subGeoGridVarStruct.myGridID = subGridObj;  %subset JGeoGridDataset object
                subGeoGridVarStruct.myVarID = getVarId(mGeoGridVarObj);
                subGeoGridVarStruct.varName = getVarName(mGeoGridVarObj);
                subGeoGridVarStruct.myShape = double(transpose(subGridObj.getGeoGrid.getShape));
                
                result=class(subGeoGridVarStruct,'mGeoGridVar');  %create mGeoGridVar object
            otherwise, error('MATLAB:mGeoGridVar:subsetGeoGridVar:Nargin',...
                                'Incorrect number of arguments');
        end   
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);
  end  
   

end
