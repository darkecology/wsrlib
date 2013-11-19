function result = mGridCoordinates(mGeoGridVarObj)
%mGridCoordinates class constructor - Creates a grid coordinates object associate with referenced geogrid
%
% Usage:
%  gcoord=mGridCoordinates(mGeoGridVarObj)
%  where,
%       mGeoGridVarObj- mGeoGridVar object
%  returns,
%       gcoord - A 'gcoord' object of class 'mGridCoordinates'.
%       In order to know the methods available for data access under
%       class 'mGridCoordinates', use matlab 'builtin' function
%       'methods(className).
%       i.e. methods(gcoord)
%
%    Methods for class mGridCoordinates:
%
%           a. getLatAxis(gcoord) - Get the Latitute points.
%
%           b. getLonAxis(gcoord) - Get the Longitude points.
%              
%           c. getVerticalAxis(gcoord) - get vertical coordinate data.
%
%           d. getTimes(gcoord) - Get time(s) in DATENUM format 
%
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

result = [];
%arg check
if nargin < 1 && nargout < 1
    help(mfilename);
    return;
end

%Init
ncID = '';
gridID = '';
coordID = '';
uCoordSys = '';
var = '';
timeAxis =0; %has Time axis
proj = ''; % Lat/Lon or GeoX/GeoY
vertAxis=0; % has vertical axis
dateTime=0; %time expressed as dates.

%create structure to store all the class variables
theStruct = struct( ...
    'myNCid', ncID, ...
    'myGridID', gridID, ...
    'myCoordID', coordID, ...
    'uCoordID', uCoordSys, ...
    'varName', var, ...
    'hasTimeAxis', timeAxis, ...
    'projType', proj, ...
    'hasVertAxis', vertAxis, ...
    'hasDateTime', dateTime ...
    );
try
    switch nargin
        case 1
            geoGridStruct = struct(mGeoGridVarObj);
            theStruct.myNCid = geoGridStruct.myNCid;  %JDataset object
            theStruct.varName = geoGridStruct.varName;
            theStruct.myShape = geoGridStruct.myShape;
            gridID = geoGridStruct.myGridID;   %JGeoGridDataset object
            theStruct.myGridID = gridID;
            uCoordSys = gridID.getCoordinateSystem(); % ucar.nc2.dt.grid.GridCoordinateSystem
            theStruct.uCoordID=uCoordSys;
            coordID = gridID.getGridCoordinateData();     %get msstate.cstm.data.grid.JGridCoordinateData
            %lets get some coordinate system info
            if coordID.hasVerticalAxis(), theStruct.hasVertAxis=1; end
            if uCoordSys.hasTimeAxis(), theStruct.hasTimeAxis=1; end
            if uCoordSys.isLatLon()
                theStruct.projType = 'LatLon';
            elseif uCoordSys.isGeoXY()
                theStruct.projType = 'GeoXY';
            else
                theStruct.projType = 'Unknown';
            end
            if uCoordSys.isDate(), theStruct.hasDateTime=1; end  %time coordinate can be expressed as date.

        otherwise, error('MATLAB:mGridCoordinates:Nargin',...
                'Incorrect number of arguments');
    end
    if (isa(coordID, 'msstate.cstm.data.grid.JGridCoordinateData')) %check for JGridCoordinate Object
        theStruct.myCoordID = coordID;
        result=class(theStruct,'mGridCoordinates');  %create mGridCoordinates object
    else
        result=[];
        error('MATLAB:mGridCoordinates',...
            'Unable to create mGridCoordinates Object');
    end

catch %gets the last error generated
    err = lasterror();
    disp(err.message);

end


end




