function display(mGridCoordinatesObj)

%mGridCoordinates/display - Display the content of mGridCoordinates Obj.

%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
%Mississippi State University

    if nargin < 1, help(mfilename), return, end


    if nargin < 2
    % assign 'ans' if inputname(1) empty
        displayName = inputname(1);
        if isempty(displayName)
            displayName = 'ans';
        end
    end
    myClass = class(mGridCoordinatesObj);

    switch myClass
        case 'mGridCoordinates'            
            coordStruct.Grid = getVarName(mGridCoordinatesObj);            
            if (hasTimeAxis(mGridCoordinatesObj))
                coordStruct.TimeAxis = 'Yes';
            else
                coordStruct.TimeAxis = 'No';
            end
            if (hasVertAxis(mGridCoordinatesObj))
                coordStruct.VerticalAxis = 'Yes';
            else
                coordStruct.VerticalAxis = 'No';
            end    
            if (hasDateTime(mGridCoordinatesObj))
                coordStruct.DateTime = 'Yes';
            else
                coordStruct.DateTime = 'No';
            end            
            disp(' '), disp([displayName ' =']), disp(' ')            
            disp(coordStruct);         

        otherwise,
                warning('MATLAB:mGridCoordinates:display', ...
                'Invalid Object, "%s".', myClass)
    end

end
