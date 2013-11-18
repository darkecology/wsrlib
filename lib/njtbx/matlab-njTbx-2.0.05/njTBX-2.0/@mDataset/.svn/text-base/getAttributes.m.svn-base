function result = getAttributes(mDatasetObj,attrName)
%mDataset/getAttributes - Returns a structure with global attributes or a value for specified global attribute name.                     
%
% Method Usage:  
%       attr=getAttributes(mDatasetObj)
%       attr=getAttributes(mDatasetObj,attrName)
% where,
%       mDatasetObj- mDataset object.
%       attrName - Global Attribute Name. (case ignored)
% returns,
%       attr - matlab structure containing attributes
%
% See also mVar/getAttributes mGeoGridVar/getAttributes
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

result=[];
if nargin < 1, help(mfilename), return, end
%retrieve JDataset object
NCid = getNCid(mDatasetObj);

if (isa(NCid, 'msstate.cstm.data.JDataset')) %check for JDataset Object  
    switch nargin
        case 1        %all global attributes
            result=njGetAttributes(NCid);
        case 2      %attribute name
            if (isa(attrName, 'char'))                
                    result=njGetAttributes(NCid,'global',attrName);
                    tempField = fieldnames(result);
                    if (~isempty(tempField)  )                  
                        result = result.(tempField{1});
                    else                                       
                        error('MATLAB:mDataset:getAttributes',...
                            'Invalid field or attribute "%s" does not exist.',attrName); 
                    end
            else
                error('MATLAB:mDataset:getAttributes',...
                     'Invalid input argument type "%s". Require "char".',class(attrName));                
            end

        otherwise, error('MATLAB:mDataset:getAttributes:Nargin',...
                        'Incorrect number of arguments'); 
    end
else
    error('MATLAB:mDataset:getAttributes',...
        'Invalid input object "%s". Require mDataset object.',class(mDatasetObj));
end 

end



