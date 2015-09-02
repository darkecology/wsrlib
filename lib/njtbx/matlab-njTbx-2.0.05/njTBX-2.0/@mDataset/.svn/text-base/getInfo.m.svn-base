function result=getInfo(mDatasetObj)
% mDataset/getInfo: Display detailed information about the netcdf data
%
%   Method Usage:   
%       result=getinfo(mDatasetObj);
%   where,
%       mDatasetObj = mDataset object.
%   returns,
%       result - char array (A detailed data description including grids,
%       coordinate systems etc.)
%
% 
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University
result=[];
if nargin < 1 && nargout < 1, help(mfilename), return, end
    
    try 
        switch nargin
            case 1    
                myNCid = getNCid(mDatasetObj);            
                if (isa(myNCid, 'msstate.cstm.data.JDataset')) %check for JDataset Object
                    result=char(myNCid.getGridDataset().getDetailInfo());
                else
                    result=[];
                    warning('MATLAB:getInfo',...
                        'Dataset object does not exist.');
                end
             otherwise, error('MATLAB:getInfo:Nargin',...
                        'Incorrect number of arguments');   

        end

    catch 
        %gets the last error generated 
        err = lasterror();    
        disp(err.message); 
    end
end