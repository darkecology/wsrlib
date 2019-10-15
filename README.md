# WSRLIB: MATLAB Toolbox for Weather Surveillance Radar 
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3352264.svg)](https://doi.org/10.5281/zenodo.3352264)

## Requirements

1. Mac OSX or Linux operating system. (WSRLIB uses NASA's
  [RSL](http://trmm-fc.gsfc.nasa.gov/trmm_gv/software/rsl/) software
  to igest radar files, which, unfortunately, is not supported on
  Windows.)

2. MATLAB

3. A [supported compiler](https://www.mathworks.com/support/requirements/supported-compilers.html) for your version of MATLAB that is properly installed and configured.

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

## Copyright and License

WSRLIB is copyrighted by Daniel Sheldon and the other authors in 2019 and licensed
under the GPL v3.0. Please see the LICENSE file.

## Acknowledgment

The development of WSRLIB was supported by the National Science Foundation under Grants No. 1125228 and 1661259.

## How to Cite

WSRLIB is open source software. You are welcome to use the code under the terms of the license for research or commercial purposes. If you use WSRLIB in published research, please acknowledge it with a citation:

> Sheldon, Daniel. WSRLIB: MATLAB Toolbox for Weather Surveillance Radar, 2019. 
> [https://doi.org/10.5281/zenodo.3352264]

If you use mistnet to discriminate rain from biology, please cite the paper:

> Tsung-Yu Lin, Kevin Winner, Garrett Bernstein, Abhay Mittal, Adriaan M. Dokter, 
> Kyle G. Horton, Cecilia Nilsson, Benjamin M. Van Doren, Andrew Farnsworth, 
> Frank A. La Sorte, Subhransu Maji, and Daniel Sheldon. MistNet: Measuring 
> historical bird migration in the US using archived weather radar data and 
> convolutional neural networks. Methods in Ecology and Evolution, 2019.

If you use any of the dealiasing or velocity profiling routines from the vvp subdirectory, please cite the original paper:

> Daniel Sheldon, Andrew Farnsworth, Jed Irvine, Benjamin Van Doren, Kevin Webb, 
> Thomas G. Dietterich, and Steve Kelling. Approximate Bayesian inference for 
> reconstructing velocities of migrating birds from weather radar. In Proceedings of 
> the 27th AAAI Conference on Artificial Intelligence (AAAI), 2013.
