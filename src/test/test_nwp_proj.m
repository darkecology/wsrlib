function test_nwp_proj()
% TEST_NAM_PROJ Test NAM projection routines

models = {NAM3D_218() NAM3D_212() NARR()};

for i = 1:length(models);
    
    nwp = models{i};
        
    file = nwp.sample_file();
    
    [~,~, grid] = nwp.read_wind(file);
    
    
    [x,y] = nwp.ll2xy(grid.lon, grid.lat);
    [lon, lat] = nwp.xy2ll(x, y);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Test that lon,lat --> x,y --> lon,lat gives same answer back
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    lon_err = max(abs(lon(:) - grid.lon(:)));
    lat_err = max(abs(lat(:) - grid.lat(:)));
    
    fprintf('Max lon error = %.4e\n', lon_err);
    fprintf('Max lat error = %.4e\n', lat_err);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Test that lon,lat --> x,y --> i,j gives the cell indices, e.g. for
    %  this small example:
    %
    % j = [ 1 2 3
    %       1 2 3
    %       1 2 3 ]
    %
    % i = [ 1 1 1
    %       2 2 2
    %       3 3 3 ]
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [i,j] = nwp.xy2ij(x, y);
    
    s = nwp.grid();
    
    row = 1:s.nx;
    if ~isequal(j, repmat(row, s.ny, 1))
        error('xy2ij failed');
    end
    
    % Every column of i should be the same
    col = (1:s.ny)';
    if ~isequal(i, repmat(col, 1, s.nx))
        error('xy2ij failed');
    end
    
end
end