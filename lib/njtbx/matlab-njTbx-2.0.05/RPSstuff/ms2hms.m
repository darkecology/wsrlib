function [hour,min,sec]=ms2hms(millisecs)
% MS2HMS converts milliseconds to integer hour,minute,seconds
%  USAGE: [hour,min,sec]=ms2hms(millisecs)
%
sec=round(millisecs/1000);
hour=floor(sec/3600);
min=floor(rem(sec,3600)/60);
sec=round(rem(sec,60));
