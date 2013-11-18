function [ncObj,varObj,gridVarObj,coordSys] = testOOP(uri,var)
% A simple test to create high level netcdf matlab objects.
%
% Usage:
% [ncObj,varObj,gridVarObj,coordSys] = testOOP(uri,var)
% uri - any netcdf URI
% var - variable name
%
%  [ncObj, varObj, gridVarObj,coordSys] = testOOP(uri,var)  - will create 'mDataset','mVar', 'mGeoGridVar' & 'mGridCoordinates' objects
%
% Example dataset
%
%ncRef ='http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/test/bora_feb.nc'
%var='temp';
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University


if nargin < 1, help(mfilename), return, end

disp('Testing object "mDataset" ....');
disp(' ');

ncObj=mDataset(uri);  % get the netcdf dataset object

if (isa(ncObj, 'mDataset'))
    disp('mDataset object...... OK.');
    disp(ncObj);

    disp(sprintf('Testing object "mVar" for variable "%s".', var));
    disp(' ');
    %varObj=ncObj{var}; %subsref
    %or
    varObj=getVar(ncObj, var);
    if (isa(varObj, 'mVar'))
        disp('mVar object...... OK.');
        disp(varObj);
    else
        error('MATLAB:mVar',...
            'Could not create mVar object');
    end

    disp(sprintf('Testing object "mGeoGridVar" for variable "%s".', var));
    disp(' ');

    gridVarObj=getGeoGridVar(ncObj,var);  %pass by value

    if (isa(gridVarObj, 'mGeoGridVar'))
        disp('mGeoGridVar object...... OK.');
        disp(varObj);

        disp(sprintf('Testing object "mGridCoordinates" for variable "%s".', var));
        disp(' ');

        coordSys=getCoordSys(gridVarObj);  %pass by value

        if (isa(coordSys, 'mGridCoordinates'))
            disp('mGridCoordinates object...... OK.');
            disp(coordSys);

        else
            error('MATLAB:mGridCoordinates',...
                'Could not create mGridCoordinates object');
        end

    else
        error('MATLAB:mGeoGridVar',...
            'Could not create GeoGrid object');
    end
else
    error('MATLAB:mDataset',...
        'Could not create mDataset object');
end

whos

end
