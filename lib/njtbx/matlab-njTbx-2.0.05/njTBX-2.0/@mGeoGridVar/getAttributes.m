function result = getAttributes(mGeoGridVarObj, attrName)
%mGeoGridVar/getAttributes  -get attribute(s) associated with the gridded variable
%
% Method Usage: 
%       attr=getAttributes(mGeoGridVarObj) 
%       attr=getAttributes(mGeoGridVarObj,attrName)
% where,  
%       mGeoGridVarObj - mGeoGridVar object.
%       attrName - Attribute Name. (case ignored)
% returns,
%       attr - matlab structure with attributes
%
% See also mVar/getAttributes mDataset/getAttributes
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

result = [];
if nargin < 1, help(mfilename), return, end

myNCid = getNCid(mGeoGridVarObj);
myVarId = getVarId(mGeoGridVarObj);

if (isa(myNCid, 'msstate.cstm.data.JDataset')) %check for JDataset Object  
    switch nargin
          case 1        %all var attributes
            result=njGetAttributes(myNCid,myVarId.getName());
          case 2      %attribute value
            if (isa(attrName, 'char'))                
                    result=njGetAttributes(myNCid,myVarId.getName(),attrName);
                    tempField = fieldnames(result);
                    if (~isempty(tempField)  )                  
                        result = result.(tempField{1});
                    else                    
                        error('MATLAB:mGeoGridVar:getAttributes',...
                             'Invalid field or attribute "%s" does not exist.',attrName); 
                    end                
            end

            otherwise, error('MATLAB:mGeoGridVar:getAttributeByName:Nargin',...
                            'Incorrect number of arguments'); 
    end
else
     error('MATLAB:mGeoGridVar:getAttributes',...
        'Invalid input object "%s". Require mGeoGridVar object.',class(mGeoGridVarObj));
end



end
