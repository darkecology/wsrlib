function [ s ] = csv2struct( csvfile, fmt )
% CSV2STRUCT Parse a csv file to a struct array
%
% Inputs
%   csvfile   The csv file name
%   fmt       Optional format string for textscan to specify data types
%             (Default: all columns are treated as string data)
% Outputs
%   s         struct array
%

% Read the meta file
fid = fopen(csvfile,'r');
if fid == -1
    error('Could not open csv file for reading: %s', csvfile);
end

% Parse first row to get field names
C = textscan(fid,'%s', 1, 'delimiter', '');
headerline = C{1}{1};

C = textscan(headerline, '%s', 'delimiter', ',', 'CollectOutput', true);
fieldnames = C{1};
nfields = numel(fieldnames);

% If format is not specified assume all strings (%s)
if nargin < 2
    fmt = repmat('%s', 1, nfields);
end

% Read the remaining lines
C = textscan(fid, fmt, 'delimiter', ',', 'ReturnOnError', false);

nrows = size(C{1}, 1);

if nrows == 0
    fprintf('Warning: no data rows\n');
    s = struct([]);
    return
end

% Create and populate the struct
s(nrows) = struct();

for i=1:length(fieldnames)
    field = genvarname(fieldnames{i});
    if isnumeric(C{i})
        data = num2cell(C{i});
        [s.(field)] = data{:};
    else
        [s.(field)] = C{i}{:};
    end
end

fclose(fid); 

end