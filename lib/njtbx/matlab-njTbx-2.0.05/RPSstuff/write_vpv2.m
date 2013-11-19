function write_vpv(theFilename, t, u, v,p)
% WRITE_VPV:  Writes velocity profile data in ASCII VPV format.
%  VPV is the freely-available "USGS Velocity Profile Viewer,"
%    an Open-GL application for viewing velocity profiles from 
%    ADCPs, models.  See <http://wwwdcascr.wr.usgs.gov/projects/vpv>.
%
%  Usage:  vpv_format(VPV_FILE, T, U, V,p) 
%   
%  Inputs:  
%     VPV_FILE = string containing name for output VPV file.
%                (If VPV_FILE is empty or contains a '*' wildcard, 
%                 the "uiputfile" dialog is invoked. )
%
%     T = time vector in Matlab's "serial date format" (output of DATENUM)
%
%     U = u velocity component matrix (cm/s): each row is a time record,
%            and each column is a time series for each bin (or z level).
%            The first row is the bottom bin. 
%
%     V = v velocity component matrix (cm/s): same format as u.
 
% Copyright (C) 1998 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 16-Nov-1998 14:24:25.

fclose('all');

if nargin < 1, help(mfilename), return, end

if isempty(theFilename), theFilename = '*'; end

if any(theFilename == '*')
        theSuggested = 'vpv.out';
        [theFile, thePath] = uiputfile(theSuggested, 'Save VSV Data');
        if ~any(theFile), return, end
        if thePath(end) ~= filesep, thePath = [thePath filesep]; end
        theFilename = [thePath theFile];
end

if nargin == 3
        if size(u, 2) == 2   % Two columns as [u v].
                v = u(:, 2);
                u = u(:, 1);
        else   % Complex u + i*v.
                v = imag(u);
                u = real(u);
        end
end

u(u == -999999) = nan;   % WHFC NetCDF ADCP data.
v(v == -999999) = nan;

u(isnan(u)) = 9999.99;
v(isnan(v)) = 9999.99;

startDate = t(1);
stopDate = t(end);

[mEnsembles, nBins] = size(u);

fmt1 = '%10.5f%10.5f%5i%5i%5i';
fmt2 = ' %s\n';
fmt3 = '%6i%10.2f%10.2f\n';

fp = fopen(theFilename, 'w');
if fp < 0, close(f), return, end

fprintf(fp, '%s\n', theFilename);

yd0 = yearday(startDate);
ydn = yearday(stopDate);

fprintf(fp, '%03i%4i%03i%4i\n', fix([yd0(2) yd0(1) ydn(2) ydn(1)]));

lat = [0 0 0];
lon = [0 0 0];

fprintf(fp, '%2i%2i%2i%2i%2i%2i\n', [lat lon]);

dt = t(2) - t(1);
binHeight = 1;

fprintf(fp, '%5i%10i%15.5f%10.5f\n', [1 nBins dt binHeight]);

d0 = rem(datevec(startDate), 100);
dn = rem(datevec(stopDate), 100);

fprintf(fp, '%5i%5i%5i%10i%5i%5i\n', [d0(1:3) dn(1:3)]);

tic
try
        for i = 1:mEnsembles
                remaining = mEnsembles-i+1;
                if i == 2 | (i > 1 & rem(remaining, 100) == 0)
                        done = mEnsembles - remaining;
                        est = (remaining * toc / done) / 86400;
                        disp([' ## Remaining: ' int2str(remaining) ' records; ' ... 
   dhms(est)]);
                end
                d = datevec(t(i));
                d(1) = rem(d(1), 100);
                hm = int2str(100*d(4)+round(d(5)*100/60));
                while length(hm) < 4, hm = ['0' hm]; end
                dt = t(i)-t(1);
                pressure = p(i);
                ensemble_header = [dt pressure d(1:3)];
                fprintf(fp, fmt1, ensemble_header);
                fprintf(fp, fmt2, hm);
                for j = 1:nBins
                        ensemble_data = [j u(i, j) v(i, j)];
                        fprintf(fp, fmt3, ensemble_data);
                end
        end
catch
        disp([' ## Error: ' lasterr])
end

fclose(fp);


function theResult = yearday(theYear, theDay)

% yearday -- Convert date to year and day-of-year.
%  yearday(theDate) returns [year day], where the day
%   is a decimal date-number.  The given date can be
%   a Matlab datenum, datestr, or datevec.
%  yearday([theYear theDay]) returns the Matlab datenum
%   corresponding to theYear and theDay.
%  yearday(theYear, theDay) same as above.
%  yearday (no arguments) demonstrates itself by showing
%   a round-trip, using "now".
 
% Copyright (C) 1998 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 09-Nov-1998 08:17:43.

if nargin < 1, theYear = 'demo'; end

if isequal(theYear, 'demo')
        help(mfilename)
        a = now;
        disp(datestr(a))
        b = yearday(yearday(a));
        disp(datestr(b))
        year_day_round_trip_error = b-a
        return
end

% Two arguments: year and day ==> datenum.

if nargin == 2, theYear = [theYear theDay]; end

if length(theYear) == 2
        theDay = theYear(2);
        theYear = theYear(1);
        d = [theYear 1 1 0 0 0];   % January 1, midnight.
        for i = 1:6
                v{i} = d(i);
        end
        result = datenum(v{:}) + theDay - 1;
        if nargout > 0
                theResult = result;
        else
                disp(result)
        end
        return
end

% One argument: date ==> year and day.

theDate = theYear;

if ischar(theDate)
        theDate = datenum(theDate);
elseif length(theDate) > 1
        for i = 1:length(theDate)
                v{i} = theDate(i);
        end
        theDate = datenum(v{:});
end

d = datevec(theDate);
d(2:6) = [1 1 0 0 0];   % January 1, midnight.
for i = 1:length(d)
        v{i} = d(i);
end
newYearsDay = datenum(v{:});

delta = (theDate-newYearsDay);

result = [d(1) (1+delta)];

if nargout > 0
        theResult = result;
else
        disp(result)
end


function theResult = dhms(theArg)

% dhms -- Convert to/from dhms time-string format.
%  dhms('theTimeString') converts 'theTimeString' of
%   the form '1d2h3m4s' to decimal days.  Multiply
%   the result by 86400 to get decimal seconds.
%  dhms(theDecimalDays) converts theDecimalDays into a
%   time-string of the format '1d2h3m4s', rounded to the
%   nearest second.
%  dhms (no argument) demonstrates itself.
 
% Copyright (C) 1998 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 16-Oct-1998 18:09:35.

if nargin < 1, theArg = 'demo'; end

if isequal(theArg, 'demo')
        help(mfilename)
        format long
        theTimeString = '9d23h59m59s'
        theDecimalDays = dhms2d(theTimeString)
        theTimeString = d2dhms(theDecimalDays)
        format short
        return
end

switch class(theArg)
case 'double'
        result = d2dhms(theArg);
case 'char'
        result = dhms2d(theArg);
otherwise
        help(mfilename)
        warning([' ## Invalid argument type: ' class(theArg)])
        result = [];
end

if nargout > 0
        theResult = result;
else
        disp(result)
end


function theResult = d2dhms(theDecimalDays)

% d2dhms -- Convert decimal days to '1d2h3m4s' time-string.
%  d2dhms(theDecimalDays) converts theDecimalDays into a
%   time-string of the format '1d2h3m4s', rounded to the
%   nearest second.
%  d2dhms (no argument) demonstrates itself.
%
% Also see: dhms2d.
 
% Copyright (C) 1998 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 07-Oct-1998 08:16:05.

if nargin < 1
        help(mfilename)
        theDecimalDays = 'demo';
end

if isequal(theDecimalDays, 'demo')
        theDecimalDays = dhms2d('9d23h59m59s')
        theTimeString = d2dhms(theDecimalDays)
        return
end

t = theDecimalDays;

d = fix(t);
t = rem(t, 1) * 24;
h = fix(t);
t = rem(t, 1) * 60;
m = fix(t);
t = rem(t, 1) * 60;
s = round(t);

result = '';
if any(d), result = [result int2str(d) 'd']; end
if any(h), result = [result int2str(h) 'h']; end
if any(m), result = [result int2str(m) 'm']; end
if any(s), result = [result int2str(s) 's']; end

if isempty(result), result = '0s'; end

if nargout > 0
        theResult = result;
else
        disp(result)
end


function theResult = dhms2d(theTimeString)

% dhms2d -- Convert dhms time-string to decimal days.
%  dhms('theTimeString') converts 'theTimeString' of
%   the form '1d2h3m4s' to decimal days.  Multiply
%   the result by 86400 to get decimal seconds.
%  dhms2d (no argument) demonstrates itself.
%
% Also see: d2dhms.
 
% Copyright (C) 1998 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 06-Oct-1998 21:19:25.

if nargin < 1
        help(mfilename)
        theTimeString = 'demo';
end

if isequal(theTimeString, 'demo')
        theTimeString = '9d23h59m60s'
        theDecimalDays = dhms2d(theTimeString)
        return
end

t = lower(theTimeString);

flag = 0;

if any(t == 's')
        t = strrep(t, 's', '*1');
        flag = 1;
end

if any(t == 'm')
        if flag
                t = strrep(t, 'm', '*60+');
        else
                t = strrep(t, 'm', '*60');
        end
        flag = 1;
end

if any(t == 'h')
        if flag
                t = strrep(t, 'h', '*3600+');
        else
                t = strrep(t, 'h', '*3600');
        end
        flag = 1;
end

if any(t == 'd')
        if flag
                t = strrep(t, 'd', '*86400+');
        else
                t = strrep(t, 'd', '*86400');
        end
end

result = eval(t) / 86400;

if nargout > 0
        theResult = result;
else
        disp(result)
end
