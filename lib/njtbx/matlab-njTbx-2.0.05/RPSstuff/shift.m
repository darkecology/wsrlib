function [anew,bnew]=shift(a,b,n)
%
%            [anew,bnew]=shift(a,b,n)
%            a and b are vectors 
%			n is number of points of a to cut off
%            anew and bnew will be the same length
%
	la=size(a);
	if la(1)<la(2)  
		a=a';
	end;
	lb=size(b);
	if lb(1)<lb(2) 
		b=b';
	end;
	anew=a(n+1:length(a),:);
	if length(anew)>length(b) 
			anew=anew(1:length(b),:);
			bnew=b;
	else
			bnew=b(1:length(anew),:);
	end
