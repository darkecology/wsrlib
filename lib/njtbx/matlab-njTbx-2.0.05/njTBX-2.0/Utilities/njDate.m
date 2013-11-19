function dateObj=njDate(dateStr)
%Utilties/njDate - Set calendar for the correct time/date using a matlab date
%string and return a java date object.
%
% dateObj = njDate(dateStr)
% where,
%          dateStr - - Date string, conforming to the matlab dateform 'dd-mmm-yyyy HH:MM:SS'
% returns,
%           dateObj  - java date object
%

% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2006-2009
% Mississippi State University
%
% import
import msstate.cstm.util.JTime
import java.util.Date

%init
dateObj=[];
dateForm=0;  % only date string form 'dd-mmm-yyyy HH:MM:SS' is allowed

if nargin < 1, help(mfilename), return, end

    try
        switch nargin
            case 1
                %make sure datestr is right form
                if  ((isa(dateStr, 'char') && strcmp(datestr(dateStr,dateForm),dateStr)))
                     dateObj = JTime.setCal(dateStr);
                else
                    disp(sprintf('MATLAB:Utilities:njSetCalDate:"%s" is not a valid date string. Form "dd-mmm-yyyy HH:MM:SS" required.', dateStr));
                    return;
                end
            otherwise, error('MATLAB:Utilities:njSetCalDate:Nargin',...
                    'Incorrect number of arguments');
        end
    catch %gets the last error generated
        err = lasterror();
        disp(err.message);
    end
end
