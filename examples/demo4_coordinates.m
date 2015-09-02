
%% Set up simple example
%   - Coordinate matrices X, Y
%   - Data matrix Z
%
[X, Y] = meshgrid(1:5, 1:5);
Z = (1 - X).^2 + 200*(Y - X.^2).^2;
surf(X, Y, Z);

%% Logical comparisons with data and/or coordinates
X > 2
Y > 2
Z > 500
X > 2 & Y > 2

%% Logical indexing
Z(X > 2 & Y > 2)

%% Coordinate conversion

% Distance from center of matrix
DIST = sqrt((X-3).^2 + (Y-3).^2);

% Select based on distance
DIST <= 2
Z(DIST <= 2)
mean(Z(DIST<= 2))