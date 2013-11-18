function [ range_match ] = get_range_matches( range1,range2 )
%Given two ranges range1 and range2 (range1 should be smaller than range2),
%this function will help in expanding the smaller range by returning a
%mapping of the elements of the bigger range to their corresponding bucket
%in the smaller range.
%e.g. range1 is 1 X 38 vector of ranges : [500 1500 ... 37500]
%range2 is a 1 X 150 vector of ranges : [125 375 ... 37375]
%we want to find a mapping of each point in range2 to a point in range1
%so that we can expand out range1 in a logical manner. 
%Author : Jeffrey Geevarghese

%Get the length of each range
r1 = size(range1,2);
r2 = size(range2,2);

%Simple assertion to force correct usage of the function
assert (r2 >= r1, 'Wrong usage of get_range_matches function. range1 should be smaller than range2.');

%Create a new vector that will hold the mappings
range_match = zeros(1,r2);

%Maintain a pointer to advance through range1
r1_ptr = 1;

for i=1:r2,
    if r1_ptr >= r1,
        range_match(1,i) = r1_ptr;
    elseif abs(range2(1,i)-range1(1,r1_ptr)) <= abs(range2(1,i)-range1(1,r1_ptr+1)),
        range_match(1,i) = r1_ptr;
    else
        r1_ptr = r1_ptr + 1;
        range_match(1,i) = r1_ptr;
    end
end

end

