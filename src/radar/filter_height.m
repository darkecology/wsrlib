function [ range,I ] = filter_height( range,elev,hmax )
%filter_height Eliminate pulse volumes above a certain height. 
[~,height] = slant2ground(range,elev);
I = height <= hmax;
I=I';       % since we are filtering height
range = range(I);



end

