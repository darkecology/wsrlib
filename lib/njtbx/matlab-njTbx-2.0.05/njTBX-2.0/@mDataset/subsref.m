function result = subsref(mDatasetObj, theStruct)
% mDataset/subsref -- Overloaded "{}", "()", and "." operators.
%  subsref(mDatasetObj, theStruct) processes subscripting references
%   of this, a "mDataset" object.
% 
% 
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end

result = [];
if (~isa(mDatasetObj, 'mDataset'))    
    error('MATLAB:mDataset:subsref',...
       'Invalid Object "%s".', class(mDatasetObj));                    
end
s = theStruct;
theType = s(1).type;
theSubs = s(1).subs;
s(1) = [];
% the sub can be a cell array ..but we need the value.

if isa(theSubs, 'cell')  
   theSubs = theSubs{1};
end

switch theType
    % DOT reference
      case '.'
        switch theSubs
            case 'getJDataset'                
                    result = getJDataset(mDatasetObj);
            case 'getAttributes'                
                    result = getAttributes(mDatasetObj);
            case 'getInfo'            
                    result = getInfo(mDatasetObj);          
            case 'close'                                  
                    close(mDatasetObj);               
            otherwise
                result = getAttributes(mDatasetObj,theSubs); %need a better logic
                if isempty(result)
                    error(['??? Reference to non-existent field ' theSubs '.']);
                end 
        end  
    %cell reference
      case '{}'
        switch class(theSubs)
            case 'char'
                myVar = theSubs;                
                    result = getVar(mDatasetObj, myVar);
                    
                %see if the variable object is ok and user needs data 
                 if ~isempty(result) 
                        structSize = length(s);
                        if (structSize > 1)
                            if (result.isGridded)
                                result = getGeoGridVar(mDatasetObj, myVar);
                                result = subsref(result, s); %make mGeoGridVar/subsref call
                            end
                        else
                             result = subsref(result, s); %make mVar/subsref call
                        end                      
                  end       
            otherwise
                error(['??? Reference to non-existent field ' theSubs '.']);
        end  
    otherwise,
        warning('MATLAB:subsref', ...
                'Invalid index type, "%s".', theType)
 
end

end

