function display(mDatasetObj)
%mDataset/display - Display the content of mDataset Obj.
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University


    if nargin < 1, help(mfilename), return, end


    if nargin < 2
    % assign 'ans' if inputname(1) empty
        displayName = inputname(1);
        if isempty(displayName)
            displayName = 'ans';
        end
    end
    myClass = class(mDatasetObj);

    switch myClass
        case 'mDataset'            
            [ngrid, nvar, ndim] = getDataInfo(mDatasetObj);
            dispStruct = struct( ...
                                'URI', getDataName(mDatasetObj), ...
                                'numGrids', ngrid, ...
                                'numDimensions', ndim, ...
                                'numVariables', nvar ...
                                );
            
            
            disp(' '), disp([displayName ' =']), disp(' ')                
            disp(dispStruct);

        otherwise,
                warning('MATLAB:display', ...
                'Invalid Object, "%s".', myClass)
    end

end
