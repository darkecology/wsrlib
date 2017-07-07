function [ t ] = expand_struct( s )
%EXPAND_STRUCT Convert a struct of arrays into an array of structs.
%
% t  = expand_struct( s )
%
% Assumes that fields are either scalars or vectors of the same size
%
% Example.
% 
%  s.a = [1 2 3];
%  s.b = {'x', 'y', 'z'};
%
%  t = expand_struct(s);
%
% The above is equivalent to
%
%  t(1).a = 1
%  t(1).b = 'x';
%
%  t(2).a = 2;
%  t(2).b = 'y';
%
%  t(3).a. = 3;
%  t(3).b = 'z';

fields = fieldnames(s);

maxlen = 0;
for i=1:length(fields)
    f = fields{i};
    maxlen = max(maxlen, numel(s.(f)));
end

t(maxlen,1) = struct();

for i=1:length(fields)
    
    f = fields{i};
    val = s.(f);
    
    if isnumeric(val)
        val = num2cell(val);
    end
    
    if ~iscell(val)
        error('I don''t know how to convert field %s to cell\n', f);
    end

    [t.(f)] = deal(val{:});    
    
end


end

