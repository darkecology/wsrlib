function [ nameFolds ] = listSubFolders( pathFolder )
%listSubFolders List all the subFolders in a given directory

d = dir(pathFolder);
isub = [d(:).isdir];
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

end

