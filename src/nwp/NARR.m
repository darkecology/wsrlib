classdef NARR < NWP
    
    % Most methods are static: these classes are used to switch between two
    % implementations; there is no data stored in the object. 
    
    methods (Static)
        
        function file = sample_file()
            %SAMPLE_FILE Return path to sample NARR file
            file = [wsrlib_root() '/data/merged_AWIP32.2010091100.3D'];
        end
        
        function [u_varname, v_varname] = wind_varnames()
            %WIND_VARNAMES Return the variable names for NARR wind components
            u_varname = 'u_wind';
            v_varname = 'v_wind';
        end
        
        function g = grid()
            %GRID Return struct describing the NARR x,y grid
            %
            %  s = NARR.grid( )
            %
            % See also CREATE_GRID
                        
            persistent s
            
            if isempty(s)
                % The code below was genereated by gen_narr_consts.m
                s = struct();
                s.nx = 349;
                s.ny = 277;
                s.nz = 29;
                s.sz = [29 277 349];
                s.x0 = -0.884078701888965;
                s.y0 = -0.723968114542679;
                s.dx = 0.005095249283929;
                s.dy = 0.005095249283929;
            end
            g = s;
        end
        
        
        function levels = pressure_levels()
            % PRESSURE_LEVELS Return the pressure levels of NARR
            
            % mbar levels
            levels = [
                1000
                975
                950
                925
                900
                875
                850
                825
                800
                775
                750
                725
                700
                650
                600
                550
                500
                450
                400
                350
                300
                275
                250
                225
                200
                175
                150
                125
                100
                ];
        end
        
        function old_proj = set_proj( )
            %SET_PROJ Set m_map to use the NARR projection
            
            % The details of the projection are given here:
            %  http://www.nco.ncep.noaa.gov/pmb/docs/on388/tableb.html#GRID221
            %
            % In short, it is a Lambert conformal conic projection, with
            %  - Central latitude = -107
            %  - Standard parallel 1 = Standard parallel 2 = 50
            %
            % The lat/lon limits set below do not matter so much to the projection,
            % but are big enough to include the entire NARR grid
            
            global MAP_PROJECTION MAP_VAR_LIST MAP_COORDS
            
            if nargout >= 1
                old_proj.MAP_PROJECTION = MAP_PROJECTION;
                old_proj.MAP_VAR_LIST = MAP_VAR_LIST;
                old_proj.MAP_COORDS = MAP_COORDS;
            end
            
            m_proj('lambert', 'long', [-234 20], 'lat', [0 100], 'clo', -107, 'par', [50 50]);
        end
               
        function [ filename ] = get_filename( time, type )
            %NARR_WIND_FILE Returns the NARR wind filename for given timestamp
            %
            % [ windFile ] = get_wind_file( time )
            %
            % Inputs:
            %    time       Time in MATLAB datenum format
            %    type       The NARR file type (default: 3D)
            % Outputs:
            %    windFile   The NARR filename
            
            
            if nargin < 2
                type = '3D';
            end
            
            % Time is in units of days. Round to closest 3-hour interval
            three_hours = 3/24;
            rounded_time = round(time/three_hours)*three_hours;
            
            [y,m,d,h] = datevec(rounded_time);
            
            switch type
                case '3D'
                    filename = sprintf('%04d/merged_AWIP32.%04d%02d%02d%02d.3D', y, y, m, d, h);
                    
                    % TODO: add other types (sfc, flx, etc.)
                otherwise
                    error('Unimplemented file type');
            end
            
        end
        
    end
end