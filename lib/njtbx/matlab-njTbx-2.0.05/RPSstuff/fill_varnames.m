function str = fill_varnames(cdfid, nvars)
%--------------------------------------------------------------------
%     Copyright (C) J. V. Mansbridge, CSIRO, january 24 1992
%     Revision $Revision: 1.3 $
% CHANGE   1.2 92/03/10
%  function str = fill_varnames(cdfid, nvars)
%
% DESCRIPTION:
%  This function fills the ith row of an array named 'str', with the
%  the name of the ith variable in the netcdf file with id number
%  cdfid.  nvars is the number of variables.  Each name is initially
%  allowed up to 25 letters but the number of columns in 'str' will
%  be expanded if necessary.
% 
% INPUT:
%  cdfid: the id number of the netCDF file under consideration.
%  ndims: the number of variables of the netCDF file under consideration.
%
% OUTPUT:
%  str: the array that receives each variable name as one of its rows.
%
% EXAMPLE:
%
%
% CALLER:   getcdf.m
% CALLEE:   mexcdf.mex
%
% AUTHOR:   J. V. Mansbridge, CSIRO
%---------------------------------------------------------------------

%     Copyright (C), J.V. Mansbridge, 
%     Commonwealth Scientific and Industrial Research Organisation
%     Revision $Revision: 1.3 $
%     Author   $Author: mansbrid $
%     Date     $Date: 1994/02/16 00:17:31 $
%     RCSfile  $RCSfile: fill_varnames.m,v $
% @(#)fill_varnames.m   1.2   92/03/10
% 
%--------------------------------------------------------------------

% First try to fill each row of str with the relevant name.  If any
% name has more than max_le characters then the number of characters
% in the longest name will be stores and become the number of columns
% when the operation is done correctly.

str = [];
max_le = 30;
new_max = 25;
for i = 0:nvars - 1
   [varnam, vartyp, nvdims, vdims, nvatts, rcode] = ...
       mexcdf('ncvarinq', cdfid, i);
   if rcode == -1
     error(['** ERROR ** ncvarinq: rcode = ' num2str(rcode)])
   end
   le = length(varnam);

   if le > max_le | new_max > max_le 
      new_max = max ([ le new_max ]);
   else
      str_tmp = [ varnam ];
      while le < max_le
         str_tmp = [ str_tmp ' ' ];
         le = le + 1;
      end
      str = [ str ; str_tmp ];
   end
end

% If any name is more than max_le characters long then store the names
% correctly in str now that we know the length of the longest name.

if new_max > max_le
   str = [];
   max_le = new_max;
   for i = 1:nvars
      [varnam, vartyp, nvdims, vdims, nvatts, rcode] = ...
	  mexcdf('ncvarinq', cdfid, i);
      if rcode == -1
	error(['** ERROR ** ncvarinq: rcode = ' num2str(rcode)])
      end
      le = length(varnam);

      str_tmp = [ varnam ];
      while le < max_le
         str_tmp = [ str_tmp ' ' ];
         le = le + 1;
      end
      str = [ str ; str_tmp ];
   end
end
