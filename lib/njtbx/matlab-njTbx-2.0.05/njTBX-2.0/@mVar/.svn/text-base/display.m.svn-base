function display(mVarObj)
%mVar/display - Display the content of mVar Obj.
%
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
    myClass = class(mVarObj);

    switch myClass
        case 'mVar'             
            disp(' '), disp([displayName ' =']), disp(' ')            
            disp(getVarId(mVarObj));           

        otherwise,
                warning('MATLAB:display', ...
                'Invalid Object, "%s".', myClass)
    end

end
