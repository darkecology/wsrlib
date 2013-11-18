function result = getAttributes(mVarObj, attrName)
%mVar/getAttributes  -get attribute(s) associated with the variable
%
% Method Usage: 
%       attr=getAttributes(mVarObj) 
%       attr=getAttributes(mVarObj,attrName)
% where,  
%       mVarObj - mVar object.
%       attrName - Attribute Name. (case ignored)
% returns,
%       attr - matlab structure containing attributes
%
% See also mGeoGridVar/getAttributes mDataset/getAttributes
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

result = [];
if nargin < 1, help(mfilename), return, end

myNCid = getNCid(mVarObj); %msstate.cstm.data.JDataset object
myVarId = getVarId(mVarObj); %mVar object

if (isa(myNCid, 'msstate.cstm.data.JDataset')) %check for JDataset Object  
    switch nargin
         case 1        %all var attributes
            result=njGetAttributes(myNCid,myVarId.getName());
          case 2      %attribute alue
            if (isa(attrName, 'char'))
                
                    result=njGetAttributes(myNCid,myVarId.getName(),attrName);
                    tempField = fieldnames(result);
                    if (~isempty(tempField)  )                  
                        result = result.(tempField{1});
                    else                    
                        error('MATLAB:mVar:getAttributeByName',...
                             'Invalid field or attribute "%s" does not exist.',attrName); 
                    end
            else
                error('MATLAB:mVar:getAttributes',...
                     'Invalid input argument type "%s". Require "char".',class(attrName));      
            end

            otherwise, error('MATLAB:mVar:getAttributes:Nargin',...
                            'Incorrect number of arguments'); 
    end   

else
    error('MATLAB:mVar:getAttributes',...
        'Invalid input object "%s". Require mVar object.',class(mVarObj));
end

end
