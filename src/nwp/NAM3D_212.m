classdef NAM3D_212 < NAM3D
    % NAM with 3D data files on grid 218: 
    %   http://nomads.ncdc.noaa.gov/data.php
    %   http://www.nco.ncep.noaa.gov/pmb/docs/on388/tableb.html#GRID212
    
    
    methods (Static)

        function file = sample_file()
            %SAMPLE_FILE Return path to sample NARR file
            file = [wsrlib_root() '/data/nam.t12z.awip3d00.tm00.grib2'];
        end
        
        function g = grid()
            %GRID Return struct describing the NARR x,y grid
            %
            %  s = NARR.grid( )
            %
            % See also CREATE_GRID
            
            persistent s
            
            if isempty(s)
                s = struct();
                
                % The code below was genereated by NAM3D_212().gen_consts()
                s.nx = 185;
                s.ny = 129;
                s.nz = 39;
                s.sz = [39 129 185];
                s.x0 = -0.663311280467311;
                s.y0 = -0.341725305558341;
                s.dx = 0.006377890356790;
                s.dy = 0.006377890356790;              
            end
            g = s;
        end        
        
        function old_proj = set_proj( )
            %NAM_SET_PROJ Set m_map to use the NAM projection
            
            % The details of the projection are given here:
            %  http://www.nco.ncep.noaa.gov/pmb/docs/on388/tableb.html#GRID212
            %
            % In short, it is a Lambert conformal conic projection, with
            %  - Central latitude = -95
            %  - Standard parallel 1 = Standard parallel 2 = 25.0
            %
            % The lat/lon limits set below do not matter so much to the projection,
            % but are big enough to include the entire NAM grid
            
            global MAP_PROJECTION MAP_VAR_LIST MAP_COORDS
            
            if nargout >= 1
                old_proj.MAP_PROJECTION = MAP_PROJECTION;
                old_proj.MAP_VAR_LIST = MAP_VAR_LIST;
                old_proj.MAP_COORDS = MAP_COORDS;
            end
            
            m_proj('lambert', 'long', [-152.90 -49.30], 'lat', [12 62], 'clo', -95, 'par', [25.0 25.0]);
            
        end
        
        function [ filename ] = get_filename( time )
                        
            %GET_FILENAME Returns the NAM wind filename for given timestamp
            %
            % [ windFile ] = NAM.get_filename( time )
            %
            % Inputs:
            %    time       Time in MATLAB datenum format
            % Outputs:
            %    windFile   The NAM filename            
            
            % Time is in units of days. Round to closest 3-hour interval
            six_hours = 6/24;
            rounded_time = round(time/six_hours)*six_hours;
            
            [y,m,d,h] = datevec(rounded_time);
            
            %Example from Kevin: nam.20150415/18/nam.t18z.awip1206.tm00.grib2
            filename = sprintf('nam.%04d%02d%02d/%02d/nam.t%02dz.awip3d00.tm00.grib2', y, m, d, h, h);
            
        end        
    end
end