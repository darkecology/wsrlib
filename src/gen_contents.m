

root = '.';
dirs = dir(root);


for i=1:length(dirs)
   
    if ~dirs(i).isdir || strcmp(dirs(i).name, '.') || strcmp(dirs(i).name, '..')
        continue
    end
    
    dirname = sprintf('%s/%s', root, dirs(i).name);    
    
    fprintf('Making contents file for %s\n', dirname);
    makecontentsfile(dirname, 'force');
    
%     
%     contents = what(dirname);
%     
%     for j = 1:length(contents.m)
%         mfile = contents.m{j};        
%         deps = depfun(mfile);
%         
%         fprintf('File %s\n', mfile);
% 
%     end
%     
end

%%%%%% Generate dependencies!
