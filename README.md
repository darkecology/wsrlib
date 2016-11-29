# WSRLIB: MATLAB Toolbox for Weather Surveillance Radar

## Requirements

1. Mac OSX or Linux operating system. (WSRLIB uses NASA's
  [RSL](http://trmm-fc.gsfc.nasa.gov/trmm_gv/software/rsl/) software
  to igest radar files, which, unfortunately, is not supported on
  Windows.)

2. MATLAB

3. A supported compiler for your version of MATLAB that is properly
  installed and configured. (E.g., for MATLAB 2015a, see
  [this page](http://www.mathworks.com/support/compilers/R2015a/index.html))

The vast majority of installation problems are due to the last
item. Depending on the match between your OS version and MATLAB
version, you may need to install a compiler and toolchain (for
example, a different version of Xcode on Mac). Please check the
Mathworks requirements carefully.

## Installation and Setup

### Step 1: One-time compile

Within MATLAB, change to wsrlib directory and type:

~~~~ {.txt}
>> wsrlib_make
~~~~

### Step 2: Setup paths

Each time you start MATLAB, run the setup script:

~~~~ {.txt}
>> wsrlib_setup
~~~~

A good practice is to add lines like this to your global MATLAB
startup.m file so this will happen automatically whenever MATLAB
is launched:

~~~~ {.matlab}
addpath('/path/to/wsrlib');
wsrlib_setup();
~~~~

## Getting started with WSRLIB

Online help is available for wsrlib from within MATLAB:

~~~~ {.matlab}
>> help wsrlib
>> doc wsrlib
~~~~

Try looking at and running the following examples (in the examples 
subdirectory):

~~~~ {.matlab}
>> cd examples
>> test_vvp
>> test_sweep2cart
~~~~

There are a number of other demos in the examples directory that
will help you get started with wsrlib.

## Getting help

Please email questions to <wsrlib-support@cs.umass.edu>

## License

~~~~

Copyright 2011-2015
  Dan Sheldon and the wsrlib team
  UMass Amherst
  sheldon@cs.umass.edu

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/

~~~~

## Acknowledgment

The development of WSRLIB was supported by the National Science Foundation under Grant No. 1125228.

## Citation

WSRLIB is open source software. You are welcome to use the code under the terms of the license for research or commercial purposes. If you use WSRLIB in published research, please acknowledge it with a citation:

Sheldon, Daniel. WSRLIB: MATLAB Toolbox for Weather Surveillance Radar. https://bitbucket.org/dsheldon/wsrlib, 2015.
