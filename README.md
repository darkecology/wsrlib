# WSRLIB: MATLAB Toolbox for Weather Surveillance Radar

## Quick-start

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

### Step 3: Use WSRLIB

Try looking at and running the following examples (in the examples 
subdirectory):

~~~~ {.matlab}
>> cd examples
>> test_vvp
>> test_sweep2cart
~~~~