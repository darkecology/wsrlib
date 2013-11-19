function xnew=boxfilt2(x,n)
%function xnew=boxfilt2(x,n)
%                     box car filter of length n
%                     The difference with boxfilt is that in the vicinity of 
%                       bad points, everything gets NaN
%                     the time base is maintained, and the points
%                     at the beginning and end are returned as their 
%                     original values.

[m1,n1]=size(x);
x2=boxfilt(x,n);
[m2,n2]=size(x2);
nbeg=ceil((n+1)/2);
xnew=x;
xnew(nbeg:nbeg+m2-1,:)=x2;
