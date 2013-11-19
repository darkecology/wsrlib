function [envel]=hilb_envel(signal)
% HILB_ENVEL create hilbert envelope of a signal
%
%  Usage:  [envel] = hilb_envel(signal);
% 
%  Input:   signal = the input signal, mean will be removed here
%           
%  Output:  envel = the hilbert envelope function
%
%  Example: 
% %       create a test signal of two sinusoids:
%       [t,signal]=sinsum(0.5,500.0,[1.0,0.7],[10.0,9.0]);
% %       find hilbert envelope:
%       envelope=hilb_envel(signal);
% %       plot results (sinsum already plotted the test signal):
%       hold on
%       plot(t,envelope,'r')            

% must first remove the mean from the series:
mean=nanmean(signal);
signal=signal-mean;

% find hilbert envelope:
x=hilbert(signal);
envel=abs(x);


