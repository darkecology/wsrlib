function [ data_e ] = expand_range( range_match,data )
%expand_range function will expand the range of data using the map in the
%range_match. 
%Author : Jeffrey Geevarghese

%Initialize the expanded range
data_e = zeros(size(range_match,2),size(data,2));

for i=1:size(range_match,2),
    data_e(i,:) = data(range_match(1,i),:);
end
 


end

