function anim_make(titl);
% ANIM_MAKE makes a FLC movie from the frames prepared by ANIM_FRAME
% using PPM2FLI.   We speed things up a lot by using IMWRITE to write
% PNG files and convert them later to PPM, instead of writing PPM files
% directly, which is slow.
%
% Usage:   []=anim_make([titl]);
%
% If an optional title is provided, the FLC is zipped, and HTML is 
% generated with this title, referencing the zip file and the "fliplay"
% applets.  Then you can move the HTML file, the .zip file and the fliplay
% Java classes to your web directory and then anyone can play your movies,
% even if they don't have a FLC viewer installed!
%
% Example: 
%   peaks(40);
%   [ax,el]=view;
%
%   for i=1:9
%     view(ax,el+i*2);
%
%      %STEP 1. Make each frame with ANIM_FRAME, supplying movie prefix
%      anim_frame('peaks',i);
%
%   end
%
%   %STEP 2. Make the frames into a FLC with ANIM_MAKE supplying a title
%          for the HTML page that contains the zipped movie for delivery
%          over the web utilizing the java client
%            
%   anim_make('Peaks Movie')
%
%
% This version uses png images as input, which requires
% a png to PPM convertor for PPM2FLI to work.  
%
% So before you use this m-file, you need the following UNIX programs
% installed:
%
%   - "ppm2fli" is available at http://vento.pi.tu-berlin.du/ppm2fli/main.html
%   - "the fliplay applet", which is necessary if you want to deliver the
%        animation to people over the web without FLC viewers, is at:
%        http://vento.pi.tu-berlin.du/fliplay/main.html
%
%   - A program to convert png to PPM:
%      two free programs I know of are:
%    1. "pngtoppm", part of the NetPBM image freeware toolkit, available at:
%        ftp://ftp.wustl.edu/graphics/graphics/packages/NetPBM/
%   OR 
%    2. "convert", part of the ImageMagick image package available at:
%        http://www.wizards.dupont.com/cristy/ImageMagick.html 
%        Some binaries are available for popular platforms -- you might
%        want to check this first.

% Rich Signell (rsignell@usgs.gov) adapted from code by Jamie Pringle  

global makemovienx makemovieny anim_name

%---------------------------------------------------------------------
% CHOOSE ONE OF THE FOLLOWING OR ADD YOUR OWN, DEPENDING ON WHAT
% png to PPM CONVERSION PROGRAM YOU HAVE:

%convert_command='png2pnm'           
convert_command='convert png:- gif:-' 
%---------------------------------------------------------------------
% Make the frame list

tmpdir=getenv('TMPDIR');
if (isempty(tmpdir)),
  tmpdir='\tmp'
end
cmd=sprintf('!convert ''png:%s\\%s*.png'' ''gif:%s\\%s*.gif''',...
  tmpdir,anim_name,tmpdir,anim_name)
eval(cmd);
% call GIFSICLE (Unix Program) 

eval(sprintf(...
['!gifsicle --colors 256 -O1 -l0 -d20 %s\\%s*.gif > %s.gif'],...
    tmpdir,anim_name,anim_name))    

disp(sprintf('Created %s.gif',anim_name));

% remove the temporary files

eval(sprintf('!del %s\%s*.png',tmpdir,anim_name))
disp(sprintf('Removed temporary images %s\\%s*.png',tmpdir,anim_name))
eval(sprintf('!del %s\%s*.gif',tmpdir,anim_name))
disp(sprintf('Removed temporary images %s\\%s*.gif',tmpdir,anim_name))

end
