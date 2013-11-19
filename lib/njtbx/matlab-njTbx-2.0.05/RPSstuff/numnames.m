function cell2=numnames(cell_array)
% function cell2=numnames(cell_array)
% prepends numbers to a cell array
for i=1:length(cell_array);
  cell2{i}=sprintf('%d:%s',i,char(cell_array(i)));
end
cell2=cell2.';
