function [z,h]=fatarrow(x,y,w,color);
% FATARROW  Draws a fat arrow.  'dataaspectratio' should be set to one or arrow 
%           will be distorted.  You will probably want to scale your input to get
%           the arrow size you want. 
%
% Usage:     [z,h]=fatarrow(x,y,w,color,lat);
%     where: x,y = x,y location of where you want the center of the arrow to be
%            w  =  complex vector from which arrows will be determined
%            color = the color of the arrow
% Outputs
%            z  = complex vector containing the points describing 
%                 the arrow [optional output]
%            h  = handle for patch object
%
%  Rich Signell rsignell@usgs.gov
x=x(:);
y=y(:);
w=w(:);
len=abs(w);
stem_width=.25*len;
head_width=2.0*stem_width;
head_length=0.35*len;
len2=len/2;
onez=ones(size(x));
zeroz=zeros(size(x));
x1=zeroz+(stem_width/2); y1=zeroz+(len2-head_length);
x2=zeroz+(head_width/2); y2=y1;
x3=zeroz;y3=zeroz+len2;
x4=zeroz-(head_width/2);y4=y1;
x5=zeroz-(stem_width/2);y5=y1;
x6=zeroz-(head_width/3);y6=zeroz-len2;
x7=zeroz+(head_width/3);y7=y6;
z=[x1 x2 x3 x4 x5 x6 x7]+sqrt(-1)*[y1 y2 y3 y4 y5 y6 y7];
a=angle(w);
z=(x+i*y)+z*exp(-i*(pi/2-a));
h=patch(real(z),imag(z),color)
