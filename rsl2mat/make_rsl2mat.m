function make_rsl2mat()
% MAKE_RSL2MAT Compile rsl2mat (make sure to compile rsl first)

RSL2MAT = fileparts(mfilename('fullpath'));

RSL = sprintf('%s/rsl/install', RSL2MAT);

INCFLAG  = sprintf('-I%s/include', RSL);
LIBFLAG  = sprintf('-L%s/lib -lrsl', RSL);
CXXFLAGS = 'CXXFLAGS="\$CXXFLAGS\ -fPIC\ -Wno-write-strings"';   % Ignore warnings about deprecated conversion from string const to char *
LDFLAGS  = ['LDFLAGS="\$LDFLAGS\ -rpath,' sprintf('%s/lib"', RSL)];

%RPATH   = sprintf('-Wl,-rpath,%s/lib', RSL);

fprintf('Compiling rsl2mat...');
curdir = cd(RSL2MAT);
mex(INCFLAG, LIBFLAG, CXXFLAGS, LDFLAGS, 'rsl2mat.cpp', 'util.c');
cd(curdir);

fprintf(' success!\n');
