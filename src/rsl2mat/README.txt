rsl2mat - a MATLAB interface to RSL
 
  rsl2mat is a MATLAB mex file interface for reading radar archive
  files using NASA's Radar Software Library (RSL). A slightly modified
  copy of RSL version 1.42 is included with this release. More
  information about RSL can be found here:

  http://trmm-fc.gsfc.nasa.gov/trmm_gv/software/rsl/

--------------------

COPYRIGHT

  Copyright 2011
      Dan Sheldon 
      Oregon State University, Corvallis, OR
      sheldon@eecs.oregonstate.edu

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/

--------------------

Requirements:

This should run on any unix-like system. It has been tested
on Linux (RHEL5 and Ubuntu), and Mac OS X. 

The following required libraries are often, but not always, 
pre-installed:

flex
bison (yacc compiler)

--------------------

INSTALL

  1. Compile rsl:

     cd rsl
     make
          
  2. Compile rsl2mat	
     
     From MATLAB, change to this directory and enter the command
     'make'. 
     
  3. Add this directory to your MATLAB path

--------------------

USAGE

  - See example.m 
  - Type 'help rsl2mat' in MATLAB
