function result = mDataset(ncURI)
%mDataset class constructor - opens a netcdf file and creates a grid or netcdf mDataset object.
%
% Usage,
%   nc=mDataset(ncURI) 
% where,
%   ncURI - Location of netcdf file could be local, URL, NcML,
%                 OpenDAP, THREDDS etc.
% returns,  
%   nc -   A 'nc' object of class 'mDataset'.
%          In order to know the methods available for data access under
%          class 'mDataset', use matlab 'builtin' function
%          'methods(className).
%          i.e. methods(nc)        
%
%      Methods for class mDataset:          
%
%           a. getAttributes(nc) - get all global attributes in a
%           matlab structure.
%
%           b. getInfo(nc) - Display detailed data information about
%           the dataset, including grid types. This is a good method to
%           know status of dataset (especially grids) or quick error check,
%           if you are trying to make a non-CF dataset into CF-compliant 
%           using NcML. 
%           
%           c. getGeoGridVar(nc, 'variable_name') - Get variable into a
%           GeoGrid if it has a Georeferencing coordinate system. This
%           method returns a 'mGeoGrid' matlab object/class.%
%
%           d. getVar(nc, 'variable_name') - Retrieves the specified
%           variable into an 'mVar' matlab object/class.
%           Variable can also be retrieved using matlab's subscripted
%           reference to objects. e.g
%           v=nc{'variable_name'} - this will return 'mVariable' object as
%           well.
%
%           e. getJDataset(nc) - Retrieves a java JDataset object.
%              (For experience java users who whould like access to java objects) 
%
%           f. close(nc) - closes the dataset object (clean up).
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

    %arg check
    if nargin < 1 && nargout < 1
        disp('check input and output arguments!');
        help mDataset;
        return;
    end

    if nargout > 0
        result = [];
    end

    %Init
    version = 'cstmTBX-1.0';
    theFileName = ncURI;
    theNCid = -1;
    nDim = -1;
    nVar = -1;
    nGrid = -1;

    %create structure to store all the class variables
    theStruct = struct( ...
                            'myVersion', version, ...
                            'myName', theFileName, ...
                            'myNCid', theNCid, ...
                            'mynGrid', nGrid, ...
                            'mynVar', nVar, ...
                            'mynDim', nDim ...
                       );
    try    
        switch nargin 
            case 1
                switch class(theFileName)
                    case 'char'
                        theStruct.myNCid = njOpenDataset(theFileName);
                        [theStruct.mynGrid, theStruct.mynDim, theStruct.mynVar] = njGetInfo(theStruct.myNCid);
                    otherwise, error('MATLAB:mDataset:Nargin',...
                                'ncURI: Input type char/string');
                end
            otherwise, error('MATLAB:mDataset:Nargin',...
                                'Incorrect number of arguments');
        end
        
        if (isa(theStruct.myNCid, 'msstate.cstm.data.JDataset')) %check for JDataset Object
            result=class(theStruct,'mDataset');  %create mDataset object
        else
            result=[];
            disp('Error >>Unable to create mDataset object');
            return
        end
               
     
        
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);

    end 
    
    
end
