function [preds, classes, probs] = mistnet_polar(radar, RANGE, AZ, ELEV)
%MISTNET_POLAR Classify sample volumes in polar coordinates using mistnet


sz = size(RANGE);
if ~ (isequal(size(AZ), sz) && isequal(size(ELEV), sz))
    error('range, az, elev must be arrays of the same size');
end

% Run mistnet to get predictions for Cartesian volume
[PREDS, PROBS, classes, x, y, elevs] = mistnet( radar );

% Create interpolating function
F = griddedInterpolant({y, x, elevs}, PREDS, 'nearest');

% Convert sample volume coordinate matrices to XYZ
[X, Y, ~] = radar2xyz(RANGE, AZ, ELEV);

% Interpolate predictions onto polar volume
preds = F(Y, X, ELEV);

% If class probabilities are requested, also interpolate those, one at a
% time
if nargout > 2
    n_classes = size(PROBS, 4);
    probs = zeros([sz n_classes]);
    for c = 1:n_classes
        F = griddedInterpolant({y, x, elevs}, PROBS(:,:,:,c), 'nearest');
        probs(:,:,:,c) = F(Y, X, ELEV);
    end    
end

end

