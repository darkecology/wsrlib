function [ str ] = struct2csv( s, fmt, file, varargin )
%STRUCT2CSV Convert struct array to csv file
%
% str  = struct2csv( s, fmt, fid, 'Prop1', 'Val1', ... )
%
% Inputs:
%   s       struct array
%   fmt     cell array of format specifiers
%   fid     optional fid
%   ...     property/value pairs
%
% Behavior: writes one line for each entry of struct array. If fid is
%   defined, writes to fid. Otherwise, returns a string.
%

% Default inputs
if nargin < 2
    fmt = guess_format(s);
end

% Check file input argument
close_fid = false;
if nargin < 3
    fid = [];
elseif isnumeric(file)
    fid = file;
elseif ischar(file)
    fid = fopen(file, 'w');
    if fid==-1
        error('Could not open file: %s\n', file);
    end
    close_fid = true;
else
    error('Argument 3 (file) should be a filename or open fid');
end

if nargin < 4
    varargin = {};
end

% Collect name/value pairs
opts = struct();
for i=1:2:numel(varargin)
    opts.(varargin{i}) = varargin{i+1};
end

% Set additional defaults
if ~isfield(opts, 'header')
    opts.header = true;
end

if ~isfield(opts, 'delimiter')
    opts.delimiter = ',';
end

if ~isfield(opts, 'replace_fun')
    opts.replace_fun = @(x) all(isnan(x));
end

if ~isfield(opts, 'replace_val')
    opts.replace_val = [];
end

if ~isfield(opts, 'fields')
    opts.fields = {};
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do the processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select fields
fields = fieldnames(s);
nfields = numel(fields);
field_inds = (1:nfields)';

if ~isempty(opts.fields)
    fields = opts.fields;
    [tf, field_inds] = ismember(fields, fieldnames(s));
    if ~all(tf)
        error('Requested output field does not exist: %s\n', fields{~tf});
    end
end

nfields = numel(fields);
str = '';

% Optionally print the header line
if opts.header
    header_fmt = [joinstr(repmat({'%s'}, nfields, 1), opts.delimiter) '\n'];
    
    if ~isempty(fid)
        fprintf(fid, header_fmt, fields{:});
    end
    if nargout >= 1
        str = sprintf(header_fmt, fields{:});
    end
    
end

% Create format string
fmt_string = [joinstr(fmt, opts.delimiter) '\n'];

% Convert to column vector and then cell array
s = s(:);
data = struct2cell(s(:));

% Replace empty elements
if ~isempty(opts.replace_fun)
    inds = cellfun(opts.replace_fun, data);
    data(inds) = {opts.replace_val};
end
    
% Select / reorder fields
data = data(field_inds, :);

% Print 
if ~isempty(fid)
    fprintf(fid, fmt_string, data{:});
end

% Set output string
if nargout > 0
    str = sprintf('%s%s', str, sprintf(fmt_string, data{:}));
end

if close_fid
    fclose(fid);
end

end




function fmt = guess_format(s)

% Guess format string from first element of struct array
fields = fieldnames(s);

n = length(fields);

fmt = cell(n,1);

for i=1:n
    data = s(1).(fields{i});
    
    if ischar(data)
        fmt{i} = '%s';
    elseif islogical(data)
        fmt{i} = '%d';
    elseif isinteger(data)
        fmt{i} = '%d';
    elseif isnumeric(data)
        fmt{i} = '%f';
    else
        error('I can''t guess the format of field %s', fields{i});
        disp(s(1));        
    end
end    
end