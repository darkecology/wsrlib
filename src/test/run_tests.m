% TODO: design a real unit test framework

% These are more or less properly designed unit tests: they check for the
% right output and throw an error if the test fails
test_nwp_proj();
test_nwp_wind();
test_slant2ground();

% This one prints to terminal... needs checking for proper output
test_struct2csv();

% These scripts work but are more demos than tests
%
% run('test_sweep2cart');
% run('test_vvp.m');
% run('test_interp');
%