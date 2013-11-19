function [x,y]=pvd(dt,u,v);
%PVD  Progressive vector diagrams.
%     [X,Y]=PVD(DT,W) returns the "trajectory" [X,Y] for the input vector
%           w, the complex velocity
%     [X,Y]=PVD(DT,U,V) returns the "trajectory" [X,Y] for the input 
%           velocity vectors U,V (East and North velocities).  
%
%  If u,v are in cm/s, and dt is in seconds, x,y are returned in cm.
%  Example: u,v are in cm/s, with 4 hour spacing.  To get x,y in km, use
%           dt=4*3600/1.e5
%

if nargin==3, 
	w=u+i*v;
elseif nargin==2,
        w=u;
end
ind=find(isnan(w));
w(ind)=0;
z=cumsum(w)*dt;
if nargout==1,
 x=z;
else,
 x=real(z);
 y=imag(z);
end
