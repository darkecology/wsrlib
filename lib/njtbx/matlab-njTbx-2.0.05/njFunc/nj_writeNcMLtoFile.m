function result=nj_writeNcMLtoFile(NcMLfile, NetCDFoutfile)
% NJ_WRITENCMLTOFILE - Reads an NcML and writes an equivalent NetcdfFile to a physical file.
%
% Note: If NcML has referenced dataset(s) in the location URI, in that case
% the underlying data (modified by the NcML is written to the new file. If
% the NcML does not have a reference dataset, then the new file is filled
% with fill values, like ncgen.
%
% Usage: 
%   result=nj_writeNcMLtoFile(NcMLfile, NetCDFoutfile);
% where,
%   NcMLfile - NcML file. File can be remote or local.
%   NetCDFoutfile - Output NetCDF file name with path.
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.

import ucar.nc2.ncml.*;
set=0;

if (nargin < 2 && nargout < 1), help(mfilename), return, end    

 try
   disp(sprintf('\nReading NcML: %s',  NcMLfile));
   %write a NetCDF file
    disp(sprintf('\nWriting NetCDF File: %s\n', NetCDFoutfile));    
    NcMLReader.writeNcMLToFile(NcMLfile, NetCDFoutfile);  
    if exist(NetCDFoutfile, 'file')
        disp(sprintf('\nSuccessfully wrote netcdf file: %s\n', NetCDFoutfile));    
        set=1;
    else
        disp(sprintf('\nProblem encountered writing netcdf file: %s\n', NetCDFoutfile)); 
    end
   
    
 catch 
    %gets the last error generated 
    err = lasterror();    
    disp(err.message); 
end

if nargout 
    result=set;
end



 
    