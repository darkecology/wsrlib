function bln=coast2bln(coast,bln_file);
% COAST2BLN converts a matlab coast (two column array w/ nan for line
% breaks) into a Surfer blanking file
% Usage: bln=coast2bln(coast,bln_file);
% where coast is a two column vector and bln_file is the output file name
c2=fixcoast(coast);
ind=find(isnan(c2(:,1)));
n=length(ind)-1;
bln=c2;
for i=1:n,
    ii=(ind(i)+1):(ind(i+1)-1);
    np=length(ii);
    bln(ind(i),1)=np;
    bln(ind(i),2)=1;
end
bln(end,:)=[];
saveascii(bln_file,bln,'%g %g\n');