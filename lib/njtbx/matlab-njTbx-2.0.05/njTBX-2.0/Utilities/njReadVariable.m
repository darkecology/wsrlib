function data=njReadVariable(varID,start, count, stride)
% njReadVariable:  Read data from variable 
% Usage:    u=njReadVariable(varID,start,count,stride);
%   where:  varID = msstate.cstm.data.JVariable%          
%           start = A 1-based array specifying the position in the file to begin reading or corner of a
%                   hyperslab e.g [1 2 1]. Specify 'inf' for last index.
%                   The values specified must not exceed the size of any
%                   dimension of the data set.
%           count = A 1-based array specifying the length of each dimension to read. e.g [6 10 inf]. 
%                   Specify 'inf' to get all the values from start index.
%           stride = A 1-based array specifying the interval between the
%                    values to read. e.g [1 2 2] 

%
%   Any of these syntaxes will return the surface temperature values
%   from the first time step: Assuming Array shape is [8,20,60,160]

%           Using 'start' 'count' 'stride' arrays to specify indexing
%
%           t=njReadVariable(varID,[1 1 1 1],[1 1 20 inf],[1 1 2 2]); % get surface temp from first time step 
%           t=njReadVariable(varID,[1 1 1 1],[1 1 20 inf]); 
%
%           and the following will return the entire longitude variable
%           t=njReadVariable(varID);  % get all the variable values

% Sachin Bhate (skbhate@ngi.msstate.edu) (c) 2008
% Mississippi State University

import msstate.cstm.data.JDataset

if nargin < 1, help(mfilename), return, end

%initialize
data=[];
try 
   if (isa(varID, 'msstate.cstm.data.JVariable')) %check for JVariable Object
        myVar = varID;
    else
        error('MATLAB:njReadVariable',...
              'Invalid Object, "%s"', class(varID));         
    end    
    
    myShape = myVar.getShape();
    myArgin = nargin;
    myStride = ones(1, length(myShape));
    
    if (myArgin == 3) 
        stride=myStride; 
        myArgin = myArgin + 1;        
    end
    
    switch myArgin
        case 1
            %read the entire volume        
             data = squeeze(myVar.readVarData());           
        case 4
            if ( ~(isa(start,'double') && isa(count,'double') && isa(stride, 'double')) )
                error('MATLAB:njReadVariable',...
                         'Invalid Argument(s). Required array.');
            end
            [start, count, stride] = parseINF(start,count,stride,myShape);
            %start and count should not exceed the variable dimensions
            if ( (start + count) <= (transpose(myShape)+1) )
                if (~isempty(stride)) 
                    if (length(stride) ~= length(myShape))                                         
                         error('MATLAB:njReadVariable',...
                         '"stride" dimensions do not match variable dimensions.');
                    end
                end                        
                data = squeeze(myVar.readVarData(start,count,stride));
            else                           
                error('MATLAB:njReadVariable',...
                      '"count" dimensions exceeds variable dimensions.');
            end
            
        otherwise, error('MATLAB:nj_varget2:Nargin',...
                        'Incorrect number of arguments'); 
    end 
    
   
catch 
    %gets the last error generated 
    err = lasterror();    
    disp(err.message); 
end
   
end
