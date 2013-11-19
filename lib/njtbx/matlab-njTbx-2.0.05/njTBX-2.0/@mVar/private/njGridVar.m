function result = njGridVar(NCid, varName)

%mVar/njGridVar - Is the input variable a gridded variable or not ?

% usage: 
% result = njGridVar(NCid,varName)
% where,
% NCid: msstate.cstm.data.JDataset obj
% varName: variable name (char)

% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

% import java class
import msstate.cstm.data.grid.JGeoGridDataset

if nargin < 1, help(mfilename), return, end

if nargout > 0
    result=[];
end

switch nargin    
    case 2
        if (isa(NCid, 'msstate.cstm.data.JDataset'))
            
            GeoGridData = JGeoGridDataset(NCid.getGridDataset(), varName);
            if (isa(GeoGridData.getGeoGrid(), 'ucar.nc2.dt.grid.GeoGrid') ) 
                result = 1;
            else
                result = 0;
            end
        else
            warning('MATLAB:mVar:njGridVar', ...
        'Incorrect Object, "%s".', class(NCid)); 
        return
        end
    otherwise,
        warning('MATLAB:mVar:njGridVar', ...
        'Illegal Syntax');        
end

end
