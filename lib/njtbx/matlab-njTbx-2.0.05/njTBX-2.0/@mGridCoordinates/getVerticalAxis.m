function result = getVerticalAxis(mGridCoordinatesObj, timeIndex, vertLevel)
%mGridCoordinates/getVerticalAxis - get vertical coordinate data
%
% if 3D, get vertical coordinates for the specified timeIndex
% if no vertical transform is present, then get 1D coordinate axes.
% Specify 'verticalLevel' to retrieve data for specific level.
%
% Method Usage:  
%   vertAxis=getVerticalAxis(mGridCoordinatesObj)
%   vertAxis=getVerticalAxis(mGridCoordinatesObj, timeIndex)
%   vertAxis=getVerticalAxis(mGridCoordinatesObj, timeIndex, vertLevel)
% where,  
%   mGridCoordinatesObj: mGridCoordinates object. 
%   timeIndex: time step for data extraction (1..n), where n=total number of time steps in a dataset.
%   vertLevel: vertical level (1...m), where m=total number of vertical level.
%
% See also getLatAxis getLonAxis
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

result = [];
if nargin < 1, help(mfilename), return, end
 
    try 
        if (isa(mGridCoordinatesObj, 'mGridCoordinates'))
            coordStruct = struct(mGridCoordinatesObj);
            switch nargin 
                case 1                
                    result=getVertData(mGridCoordinatesObj, 0, 0);
                case 2                
                    if (isscalar(timeIndex) && isnumeric(timeIndex) && (timeIndex > 0) )
                        result=getVertData(mGridCoordinatesObj, timeIndex, 0);
                    else
                        error('MATLAB:mGridCoordinates:getVerticalAxis:Nargin',...
                                    'Invalid time index "%s". Need scalar and numeric value (>0).', char(timeIndex));
                    end
                case 3                
                    if (isscalar(timeIndex) && isnumeric(timeIndex) && (timeIndex > 0) && isscalar(vertLevel) && isnumeric(vertLevel) && (vertLevel > 0)  )
                        result=getVertData(mGridCoordinatesObj, timeIndex, vertLevel);
                    else
                        error('MATLAB:mGridCoordinates:getVerticalAxis:Nargin',...
                                    'Invalid time index or level. Need scalar and numeric value (>0).');
                    end

                otherwise, error('MATLAB:mGridCoordinates:getTimes:Nargin',...
                                    'Incorrect number of arguments');
            end
        else
            error('MATLAB:mGridCoordinates:getTimes',...
                                    'Invalid Object "%s".', class(mGridCoordinatesObj));
                    
        end
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);
    end 

    %Get vertical coordinate data
    function vertData=getVertData(mGridCoordinatesObj, iTime, level)
        vertData =[];
         if ( hasVertAxis(mGridCoordinatesObj) )
            uCoordId = getUCoordId(mGridCoordinatesObj);
            myCoordId = getCoordId(mGridCoordinatesObj);
            
            vt= uCoordId.getVerticalTransform();
            if (~isempty(vt))
                if (iTime) 
                    z = squeeze(myCoordId.getVerticalCoordinates(iTime-1)); 
                else 
                     z = squeeze(myCoordId.getVerticalCoordinates());
                end
                % Has vertical axis but no transform. 1D coordinate axes.
            else       
                z = squeeze(myCoordId.getVerticalAxis1D()); % 2D  
            end
            if level
                vertData=squeeze(z(level,:,:));
            else
                vertData=z;
            end     
        end
       
    end

end
