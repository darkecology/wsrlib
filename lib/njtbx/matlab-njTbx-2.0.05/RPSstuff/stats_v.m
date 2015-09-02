function [mean1, std1, mean2, std2, corr, transfn]=stats(u1,u2,printout);
% STATS_V   Some basic stats of one or two vector quantities.
%    Usage: [mean1, std1, mean2, std2, corr, transfn]=stats(u1,[u2],[printout]);
%       or  [mean, std, major, minor]=stats(u,printout);
%
%  Inputs:
%         u1 = vector 1 (can be complex)
%         u2 = vector 2 (can be complex)
%        printout = optional printout control.  If present and positive (e.g. ==1)
%                   then stats are printed out to the screen. 
%
%  Outputs: 
%        mean1=mean of vector 1
%        std1=standard deviation of vector 1
%        mean2=mean of vector 2
%        std2=standard deviation of vector 2
% 
%        corr= correlation (complex for complex vectors)
%        transfn = transfer function (complex for complex vectors)
%
%        The printout (if printout==1 on input) contains "formatted"
%        output, where the angles are printed out relative to True North
%        (eg. Eastward=90), and the correlation is expressed as the 
%        complex correlation and rotation angle. A positive angle indicates
%        that series 1 is rotated counterclockwise from series 2.

if nargin==1,
    nvar=1;
    printout=0;
    u1=denan(u1);
elseif nargin==2,
    if length(u2)==1; 
      printout=u2; 
      nvar=1; 
    else 
      printout=0;
      nvar=2;
    end
else 
    printout=1; 
    nvar=2;
end
if nvar==1,
  u1=denan(u1);
else
  ind=find(~isnan(u1(:)+u2(:)));
  disp('denanning both')
  if(isempty(ind)),disp('All NANs'),return,end
  u1=u1(ind);
  u2=u2(ind);
end
[n,m]=size(u1);
if m>n; u1=conj(u1'); [n,m]=size(u1);
end

mean1=gmean(u1);


if nvar==2
[n2,m2]=size(u2);
if n2~=n; u2=conj(u2');
end

mean2=gmean(u2);
cv=cov(u1,u2);
std1=sqrt(abs(cv(1,1)));
std2=sqrt(abs(cv(2,2)));
transfn=cv(1,2)/cv(1,1);
corr=cv(1,2)/std1/std2;
else

cc=cov(real(u1),imag(u1));
std1=sqrt(cc(1,1)+cc(2,2));
theta=0.5*atan2(2.*cc(2,1),(cc(1,1)-cc(2,2)) );
major=sqrt(cc(1,1)*cos(theta)^2+2*cc(1,2)*cos(theta)*sin(theta)...
   +cc(2,2)*sin(theta)^2);
minor=sqrt(cc(1,1)*sin(theta)^2-2*cc(1,2)*cos(theta)*sin(theta)...
   +cc(2,2)*cos(theta)^2);
theta=theta*180./pi;

end

if printout~=0
if nvar==2
if printout>0
disp(' mean1 theta  std1 mean2 theta  std2   corr theta  transfn theta')
end
fprintf('%6.2f%6.1f%6.2f',abs(mean1),90-angle(mean1)*180/pi,std1);
fprintf('%6.2f%6.1f%6.2f',abs(mean2),90-angle(mean2)*180/pi,std2);
fprintf('%8.2f%6.1f',abs(corr),-angle(corr)*180/pi);
fprintf('%7.2f%8.1f',abs(transfn),-angle(transfn)*180/pi);
fprintf('\n')
else

if printout>0
    disp('   mean   theta      std   major    minor   theta')
end
fprintf('%8.2f%8.1f%8.2f',abs(mean1),90-angle(mean1)*180/pi,std1);
fprintf('%8.2f%8.2f%8.1f',major,minor,90-theta);
fprintf('\n')
theta=theta*pi/180;
mean2=major*cos(theta)+i*major*sin(theta);
std2=-minor*sin(theta)+i*minor*cos(theta);
end

end

