classdef NAM3D < NWP
    
    % Most methods are static: these classes are used to switch between two
    % implementations; there is no data stored in the object.
    
    methods (Static)
        
        function [u_varname, v_varname] = wind_varnames()
            %WIND_VARNAMES Return the variable names for NAM wind components
            u_varname = 'U-component_of_wind';
            v_varname = 'V-component_of_wind';
        end                
        
        function levels = pressure_levels()
            % PRESSURE_LEVELS Return the pressure levels of NAM
            
            % units = pascals
            levels = [
                100000
                97500
                95000
                92500
                90000
                87500
                85000
                82500
                80000
                77500
                75000
                72500
                70000
                67500
                65000
                62500
                60000
                57500
                55000
                52500
                50000
                47500
                45000
                42500
                40000
                37500
                35000
                32500
                30000
                27500
                25000
                22500
                20000
                17500
                15000
                12500
                10000
                7500
                5000
                ];
            
            levels = levels/100; % units = mbar
        end
    end
end