function [ s ] = narr_grid( )
%NARR_GRID Returns struct describing the NARR x,y grid
%
%  s = narr_grid( )
%
% See also CREATE_GRID

% The code below was genereated by gen_narr_consts.m

s.nx = 349;
s.ny = 277;
s.nz = 29;
s.sz = [29 277 349];
s.x0 = -0.884078701888965;
s.y0 = -0.723968114542679;
s.dx = 0.005095249283929;
s.dy = 0.005095249283929;

end