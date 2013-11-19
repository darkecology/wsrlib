function [ s ] = join_struct( s1, f1, s2, f2, require_subset)
% JOIN_STRUCT Join two struct arrays on specified fields

if nargin < 5
    require_subset = true;
end

% Find locations of s1 entries in s2
[flag, loc] = ismember([s1.(f1)], [s2.(f2)]);

if require_subset && ~all(flag)
    error('Not all entries in s1 are present in s2');
end

% Eliminate entries of s1 that don't appear in s2
s = s1(flag);
loc = loc(flag);

% Now go through and add s2 fields to s1
fields = setdiff(fieldnames(s2), f2);

for i=1:length(fields)
    f = fields{i};
    [s.(f)] = s2(loc).(f);
end

end
