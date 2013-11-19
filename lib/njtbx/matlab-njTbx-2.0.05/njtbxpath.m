function njtbxpath()
%WHICHPATH - Display full path(s) info for njtbx
% Allows user to auto add path info. 
% Extract/display absolute path information for
% all required directories of njTBX, which are to 
% be added to the matlab search path.
%
% usage:
% whichpath();
%

% get the njtbxroot directory
njtbxhome = njtbxroot(); 

disp('-------------------- njTBX-2.0 --------------------------------');
disp(blanks(1)');
disp('>>>>> Following directories must be added to the matlab search path in order for toolbox to run properly');
disp(blanks(1)');
dirs = {'examples', 'njFunc', 'njTBX-2.0', 'Utilities'};
fulldirs=cell(1,length(dirs)+1); %preallocate
fulldirs{1}=njtbxhome;
disp(fulldirs{1});
for i=1:length(dirs)
    if (i == length(dirs))       
         fulldirs{i+1}=fullfile(njtbxhome, dirs{i-1}, dirs{i});
         disp(fulldirs{i+1});
    else
        fulldirs{i+1}=fullfile(njtbxhome, dirs{i});
        disp(fulldirs{i+1});
    end    
end
%disp(blanks(1)');
%user_in = input('>>>>> Do you want to add these directories now to the search path? y/n [y]: ', 's');

%if ( isempty(user_in) || user_in=='y' )
 %   disp(blanks(1)');
  %  disp('>>>>> Adding directories to search path... ');    
   % for i=1:length(fulldirs)
    %    addpath(fulldirs{i},'-end');
    %end
    %disp('>>>>> Done.');
%else
 %   disp('>>>>> Please add the above directories manually to the search path.');
%end
disp(blanks(1)');

disp('Locate "Seawater" and "RPSStuff" directories on your system, which you must have downloaded earlier and add to matlab search path.');
disp('These directories are only required for demos, and are NOT required for njTBX to function properly.');
disp(blanks(1)');
end
