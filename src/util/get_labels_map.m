function [ all_labels, label_sources ] = get_labels_map( labels )
%Read in the labels file (which has aggregate labels from all sources) and
%return a map of scan id and accept/reject status
%Input:
%labels : the file handle to the all labels file
%Output:
%all_labels : a container map with scan id as the key and the list of
%labels from all sources in a list as the value. 
%label_sources : the string which will form the columns in the meta_csv file

%Read in the data, each column as elements of a cell array
L = textscan(labels,'%s%s%s','delimiter',',');

%Create a container map for easy lookup
all_labels = containers.Map('keyType','uint32','valueType','Any');

%Get the number of rows
num_rows = size(L{1},1);
num_columns = size(L,2);

%Make a matrix of labels available from all sources
label_mat=[];
for i=2:num_columns,
    label_mat = [label_mat L{i}];
end

all_labels(0) = label_mat(1,:);

for i=2:num_rows,
    all_labels(str2double(L{1}(i))) = label_mat(i,:);
end

%get the label_sources string
label_sources = all_labels(0);

end

