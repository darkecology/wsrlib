function result=njGetInfo(NCid, var)
% 
% mVar/njGetInfo: finds information about variable

% Usage:    u=njGetInfo(NCid, var);
%   where:  NCid: JDataset object
%           var: var name e.g 'temp'

%         
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

%import
import ucar.ma2.Array

 %arg check
    if nargin < 1 && nargout < 1
        disp('check input and output arguments!');
        help getInfo;
        return;
    end

    if nargout > 0
        result = [];
    end
    infoStruct = struct();
    
    
     try    
        switch nargin 
            case 2
                switch class(var)
                    case 'char'
                         if (isa(NCid, 'msstate.cstm.data.JDataset')) %check for JDataset Object
                             jVar = NCid.getJNetcdfDataset().getVariable(var); 
                             if (isa(jVar, 'msstate.cstm.data.JVariable'))
                                 infoStruct.varid = jVar;  % JVariable
                                 infoStruct.type = char(jVar.getDataType().toString());   %get data type
                                 infoStruct.shape = transpose(jVar.getShape()); %get array shape
                                 infoStruct.attr = size(jVar.getAttributes()); % get num attributes                              
                                 
                             else
                                result=[];
                                error('MATLAB:mVar:getInfo',...
                                'Unable to create JVariable object for variable "%s"', var);
                             end
                         else
                            result=[];
                            error('MATLAB:mVar:getInfo:Nargin',...
                                'var: Input type char/string');                            
                        end
                       
                    otherwise, error('MATLAB:mVar:getInfo:Nargin',...
                                'var: Input type char/string');
                end
            otherwise, error('MATLAB:mVar:getInfo:Nargin',...
                                'Incorrect number of arguments');
        end

        result = infoStruct;
        
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);

     end 
end



    

