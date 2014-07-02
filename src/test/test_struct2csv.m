s = struct('a', {1 2 3 4}, 'b', {'w', 'x', 'y', 'z'}, 'c', num2cell(int32([9 10 11 12])));

% Guess the format
fprintf('Test 1: guess the format\n');
str = struct2csv(s);
fprintf(str);
fprintf('\n');

% Specify the format
fprintf('Test 2: specify format\n');
fmt = {'%d', '%s', '%d'};
str = struct2csv(s, fmt);
fprintf(str);
fprintf('\n');

% Supply a fid (stdout)
fprintf('Test 3: supply a fid\n');
struct2csv(s, fmt, 1);
fprintf('\n');

% Non-standard delimiter
fprintf('Test 4: non-standard delimiter\n');
struct2csv(s, fmt, 1, 'delimiter', '---');
fprintf('\n');

% Suppress header
fprintf('Test 5: suppress header\n');
struct2csv(s(2), fmt, 1, 'header', false);
fprintf('\n');

% Subset of fields
fprintf('Test 6: subset of fields\n');
struct2csv(s, {'%s', '%d'}, 1, 'fields', {'b', 'a'});
fprintf('\n');

% Write to file
fprintf('Test 7: write to file\n');
struct2csv(s, fmt, 'foo.csv');
type foo.csv
fprintf('\n');
