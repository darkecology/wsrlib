function attr=njGetAttributes(ncRef,var,attrb)
% njGetAttributes get attributes for NetCDF file, NetCDF URL or OpenDAP URL
% Usage:    attr=njGetAttributes(ncRef,var,attrb);
%   where:  ncRef = Reference to netcdf file. It can be either of two
%                   a. local file name or a URL  or
%                   b. An 'msstate.cstm.data.JDataset' object, which is the reference to already
%                   open netcdf file.  [ncRef=msstate.cstm.data.JDataset(uri)]
%           var  = variable or 'global'     
%           attrb = global or variable attribute name  (case ignored)
%
%           [attr]= njGetAttributes(ncRef);                 Returns only 'global' attributes
%           [attr]= njGetAttributes(ncRef,'global',attrb)  returns a variable with the value of a global attribute
%           [attr]= njGetAttributes(ncRef,var)            
%           [attr]= njGetAttributes(ncRef,var,attrb)       returns a variable with the value for a specific variable attribute
%      
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University
%
% import the NetCDF-Java methods 
import msstate.cstm.data.JDataset
import msstate.cstm.data.grid.JGeoGridDataset
import ucar.ma2.Array

% core java
import java.util.HashMap
import java.util.ListIterator

if nargin < 1 
    disp('Check input arguments!')
    help njGetAttributes
    return
end

attr = struct;  %output struct for global and variable attr.

%STATIC vars
GLOBAL='global';

try 
    if (isa(ncRef, 'msstate.cstm.data.JDataset')) %check for JDataset Object
        GridData = ncRef;
    else
        % open CF-compliant NetCDF File as a Common Data Model (CDM) "Grid Dataset"
        GridData = JDataset(ncRef);  %java object which wraps griddataset and netcdfdataset(non-gridded)         
    end         
        
    switch nargin
      case 1      %only global attributes 
        globalAttrs=GridData.getGlobalAttributes(); %HashMap   
        attr = makeAttrStruct(globalAttrs);       
      case 2    %global and variable attributes        
        varAttrs = getVarAttr(GridData,var);        
        attr=makeAttrStruct(varAttrs);       
       case 3    % get specified attribute
         if (strcmp(var,GLOBAL))  %global
             globalAttrs=GridData.getGlobalAttributes(); %HashMap 
             attr=makeAttrStruct(globalAttrs,attrb);             
         else %variable
             varAttrs = getVarAttr(GridData,var);  
             attr=makeAttrStruct(varAttrs,attrb);            
         end        
        otherwise, error('MATLAB:nj_attget:Nargin',...
                        'Incorrect number of arguments'); 
    end   

    %cleanup
   % GridData.close();
    
catch 
    %gets the last error generated 
    err = lasterror();    
    disp(err.message); 
end

    %local function to create structure for attributes
    % attrHash: attribute HashMap (Java) 

    function attrStruct=makeAttrStruct(attrHash,attrbkey)
        attrStruct = struct;
        %get the HashMap keyset
        attrKeySet = attrHash.keySet();
        attrKeyIter = attrKeySet.iterator(); %iterator
        while (attrKeyIter.hasNext()) 
            attrKey = attrKeyIter.next();
            attrTempKey = attrKey;
            %Non-alphanumeric and non-underscore characters creates a
            %invalid field for matlab struct. If there are any such
            %characters in field key then we will replace it with '_'.
            attrTempKey=strtrim(regexprep(char(attrTempKey), '_', ' ',1));  % field starting with '_' cannot be used in struct. e.g. '_CoordinateAxisType'
            if regexp(char(attrTempKey),'\W')              
                %disp(sprintf('%s :Invalid Field. Contains non-Alphanumeric characters. Replacing invalid characters with ''_''. ', attrKey));
                attrTempKey=regexprep(attrTempKey,'\W','_');
                %disp(sprintf('New Field: %s', attrTempKey));
            end
            %populate the matlab structure
            switch nargin
                case 1
                    if ( isa(attrHash.get(attrKey), 'ucar.ma2.ArrayChar$D1') || isa(attrHash.get(attrKey), 'ucar.ma2.ArrayObject$D1') ) 
                        attrStruct.(char(attrTempKey)) = char(copyTo1DJavaArray(attrHash.get(attrKey)));  
                    else
                        attrStruct.(char(attrTempKey)) = copyTo1DJavaArray(attrHash.get(attrKey)); 
                    end   
                case 2
                    if (strcmpi(char(attrKey), attrbkey))   %ignore case during comparison
                        if ( isa(attrHash.get(attrKey), 'ucar.ma2.ArrayChar$D1') || isa(attrHash.get(attrKey), 'ucar.ma2.ArrayObject$D1') ) 
                            attrStruct.(char(attrTempKey)) = char(copyTo1DJavaArray(attrHash.get(attrKey)));  
                        else
                            attrStruct.(char(attrTempKey)) = copyTo1DJavaArray(attrHash.get(attrKey)); 
                        end 
                    end
            end
                     
        end        
    end

    %Get variable attributes
    function vatt=getVarAttr(JDatasetObj, var)
        %associated geo grid        
        GeoGridData = msstate.cstm.data.grid.JGeoGridDataset(JDatasetObj.getGridDataset(),var);
        if ( isa(GeoGridData.getGeoGrid(), 'ucar.nc2.dt.grid.GeoGrid') )  % make sure it's gridded var, otherwise treat as regular netcdf var
            vatt=GeoGridData.getGridAttributes();
        else           
            ncVar = JDatasetObj.getJNetcdfDataset().getVariable(var);
            vatt = ncVar.getVarAttributes();            
        end
    end
   
end
