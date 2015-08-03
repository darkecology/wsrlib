function make_rsl2mat()
% MAKE_RSL2MAT Compile rsl2mat (make sure to compile rsl first)

RSL2MAT = fileparts(mfilename('fullpath'));

fprintf('Compiling rsl2mat...\n');
curdir = cd(RSL2MAT);
setenv('MATLABROOT', matlabroot());
status = system('make');
cd(curdir);

if status
    error('Compile failed');
else
    fprintf('Success!\n');
end