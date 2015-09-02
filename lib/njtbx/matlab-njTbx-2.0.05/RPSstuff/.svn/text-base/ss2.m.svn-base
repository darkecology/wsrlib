function [start,stop]=ss2(jd)
% SS2: Return Gregorian start and stop dates of Julian day variable
%  Usage:  [start,stop]=ss2(jd)
start=gregorian(jd(1));
stop=gregorian(jd(end));
if(nargout==0),
  start(2,:)=stop
end
