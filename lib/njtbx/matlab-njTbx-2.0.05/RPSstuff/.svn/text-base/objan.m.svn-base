function [Psi,rms] = objan(xobs,yobs,obs,rmsobs,rmsclim,corlen,xnew,ynew)
% OBJAN: 2D objective analysis (linear estimation).
%     [psi,rms] = OBJAN(xobs,yobs,obs,rmsobs,rmsclim,corlen,xnew,ynew)
%     performs a linear estimation of the scalar field psi at the 
%     coordinates (xnew,ynew) from observation data obs (located at 
%     (xobs,yobs) ) by using minimum error variance methods.
%     A Gaussian spatial correlation with length scale corlen is assumed; 
%     if corlen is a 2 element vector, different scales are used for 
%     x and y direction.
%
%     input:   xobs    - x coordinate of observation                     (v/M)
%              yobs    - y     "      "      "                           (v/M)
%              obs     - observation (of psi)                            (v/M)
%              rmsobs  - rms (measurement) error of observation          (s)
%              rmsclim - rms error (variability) of climatological field (s)
%              corlen  - correlation length (in units as of x and y)     (s/v)
%              xnew    - new x coordinates                               (v/M)
%              ynew    - new y coordinates                               (v/M)
%     output:  psi     - estimated field at xnew, ynew                   (M)
%              rms     - rms error of psi                                (M)
%
% Dimensions: (v) = vector, (s) = scalar, (M) = matrix
% Note:  OBJAN assumes a climatology = 0, i.e. mean field subtracted
%        (anomalies only).
% See also  PLOBJAN .
%        

% (c) 21-Jul-1995  W. Erasmi, Dept. Marine Physics, IfM Kiel  Germany

% error handling
if nargin < 8,
   error('Not enough input arguments.');
elseif any(size(xobs)~=size(yobs)) | any(size(yobs)~=size(obs)),
   error('xobs, yobs and obs must have the same size.');
elseif (size(rmsobs)~= [1 1]) & (size(rmsobs)~= [length(obs) length(obs)]),
   error('Wrong size of rmsobs.');
elseif any(size(rmsclim)~= [1 1]),
   error('Wrong size of rmsclim.');
elseif length(corlen(:)) > 2,
   error('corlen must have 1 or 2 elements.');
elseif (min(size(xnew)) > 1) | (min(size(ynew)) > 1),
   if any(size(xnew)) ~= any(size(ynew)),
      error('If xnew and ynew are given as matrices, they have to be the same size.');
   end;
elseif any(~finite(xobs)) | any(~finite(yobs)) | any(~finite(obs)) ...
 | any(~finite(rmsobs)) | any(~finite(rmsclim)) | any(~finite(corlen)) ...
 | any(~finite(xnew)) | any(~finite(ynew)),
   error('OBJAN does not work for NaN''s or Inf''s.');
end

% setting dummy values in case obs is empty
if isempty(obs);
   disp(' Warning: empty observation vectors.');
   xobs = 10*max(max(xnew));
   yobs = 10*max(max(ynew));
   obs = 0;
end;

% start
if min(size(xnew)) == 1,                  % xnew,ynew are vectors
   mm = length(xnew);
   nn = length(ynew);
   [xnew ynew] = meshgrid(xnew,ynew);     % make them matrices
else
   [nn,mm] = size(xnew);
end;

yi =obs(:);
N = length(yi);      % Zahl der Messwerte

x = [xnew(:) ynew(:)];
lenx = size(x,1);

fprintf(2,' objan:  inverting a %d x %d matrix; please stand by ...',N,N);

sigmaK = rmsclim.^2;     % -> Varianz d. Klimatologie  ( ^= Rpsi(x,x) )
corlen=corlen(:);
if length(corlen)==1,
   corlen=corlen*[1;1];
end;
lk2 = corlen.^2;

% erstelle Kovarianzmatrtix R (S. 97)  ---
% wie variiert jeder Messwert mit jedem anderen ?
XOBS = xobs(:)*ones(1,N);
YOBS = yobs(:)*ones(1,N);
R = sigmaK * exp( -((XOBS-XOBS').^2/lk2(1) + (YOBS-YOBS').^2/lk2(2)) );

% erstelle Rn = R(noise); unkorrelierte Fehler angenommen
Rn = rmsobs.^2 * eye(N);

% erstelle M und invertiere
Minv = inv(R+Rn);

% Innere Summe (S.98): sum( Minv(ij) * yi ), muss nur einmal berechnet werden
Q = yi' * Minv;

% Loesungsschleife
fprintf(2,'\r objan:  computing field ...                              \n');

%text loop for estimate of time coefficient;
tic;	n=0;	
	for k=1:10;	
   	c = sigmaK * exp(-( (x(1,1) - xobs(:)).^2/lk2(1) + (x(1,2) - yobs(:)).^2/lk2(2) ));
   	n = Q * c;                    % Sch"atzwert / sigmaK
      n   = c'*Minv*c;                 % -Fehler - sigmaK
	end;	
ctim=toc*lenx/10;

if ctim > 180,
   fprintf(2,'         (please wait approx. %.0f min.)\n',ctim/60.)
else
   fprintf(2,'         (please wait approx. %.0f sec.)\n',ctim)
end;

c   = zeros(N,1);
Psi = zeros(lenx,1);
E   = zeros(lenx,1);
for p = 1:lenx,
   c = sigmaK * exp(-( (x(p,1) - xobs(:)).^2/lk2(1) + (x(p,2) - yobs(:)).^2/lk2(2) ));
   Psi(p) = Q * c;                    % Sch"atzwert / sigmaK
   E(p)   = c'*Minv*c;                 % -Fehler - sigmaK
end;

E   = sigmaK - E;
rms = sqrt(E); 

Psi = reshape(Psi,nn,mm);
rms = reshape(rms,nn,mm);
