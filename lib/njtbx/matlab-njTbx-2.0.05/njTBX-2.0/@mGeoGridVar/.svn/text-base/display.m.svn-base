function display(mGeoGridVarObj)

%mGeoGridVar/display - Display the content of mGeoGridVar Obj.

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
    myClass = class(mGeoGridVarObj);

    switch myClass
        case 'mGeoGridVar'              
            disp(' '), disp([displayName ' =']), disp(' ')            
            dispStruct.Variable = getVarName(mGeoGridVarObj);
            myGridId = getGridId(mGeoGridVarObj);
            g=myGridId.getGeoGrid;
            dispStruct.Dimensions = char(g.getDimensions.toString);
            disp(dispStruct);
        otherwise,
                warning('MATLAB:display', ...
                'Invalid Object, "%s".', myClass)
    end

end
