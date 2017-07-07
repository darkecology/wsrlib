function [A,hits,xc,yc]=binsort(x,y,z,xbin,ybin);
%BINSORT Sort a variable into bins defined by 
%        two other variables
%
%[A,hits,xc,yc]=binsort(x,y,z,xbin,ybin);
%
%   INPUT: 
%          x independent variable
%          y independent variable
%          z dependent variable to be sorted
%          xbin=vector containing x bin boundaries
%          ybin=vector containing y bin boundaries
%
%   OUTPUT:   A = the mean value of Z in this bin
%          hits = the number of hits in this bin
%          xc   = the centered bin x values
%          yc   = the centered bin y values

%   Rich Signell, 5-16-91
%

np=length(x);
if(length(y)~=np | length(z)~=np),
  disp('number of points in x,y,z must be the same!!!')
end
x=x(:);
y=y(:);
z=z(:);
ind=find(~isnan(x+y+z));
x=x(ind);
y=y(ind);
z=z(ind);

% Number of bins
nxbins=length(xbin)-1;
nybins=length(ybin)-1;

% Initialize output
A=zeros(nybins,nxbins);
hits=zeros(nybins,nxbins);

xc=.5*(xbin(1:nxbins)+xbin(2:nxbins+1));
yc=.5*(ybin(1:nybins)+ybin(2:nybins+1));

%Loop through bins (inefficient, but real easy! :)
for i=1:nxbins
  for j=1:nybins
    k=nybins+1-j;
    ind=find(xbin(i)< x & x < xbin(i+1) & ybin(j) <= y & y < ybin(j+1));
    if(length(ind)~=0),
      A(k,i)=mean(z(ind));   % the mean of the points in this box
    else
      A(k,i)=NaN;
    end
   hits(k,i)=length(ind);  % number of hits in this box
%   hits(k,i)=(length(ind)/np)*100; % percentage of hits in this box
  end
end
