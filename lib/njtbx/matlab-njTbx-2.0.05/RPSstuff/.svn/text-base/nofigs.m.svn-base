function nofigs

% NOFIGS Delete all figures.
%  NOFIGS deletes all existing figures immediately.
%   Callbacks to 'DestroyFcn' are disabled and ignored.

% Copyright (C) 1994 Dr. Charles R. Denham, ZYDECO.
% All Rights Reserved.
% 
% "All Rights Reserved" couldn't possibly refer to ME, however. 
% Fixed by John Evans to work with Matlab 5.0.


% Disable all callbacks to destructors.

h = flipud(sort(get(0,'children')));
set(h, 'CloseRequestFcn', '')

% Destroy all figures in reverse order.

h = get(0, 'Children');
h = flipud(sort(h));
for i = 1:length(h)
   if (strcmp(get(h(i), 'Type'), 'figure'))
      delete(h(i))
      disp(['    Figure No. ' num2str(h(i)) ' deleted.'])
   end
end
