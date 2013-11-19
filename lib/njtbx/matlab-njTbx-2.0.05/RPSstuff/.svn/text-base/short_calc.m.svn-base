function [add_offset,scale_factor]=short_calc(amin,amax);
% function [add_offset,scale_factor]=short_calc(amin,amax);
range = 32767 - (-32767);
add_offset  = (amax+amin)*.5;
scale_factor = (amax-amin)/range;
