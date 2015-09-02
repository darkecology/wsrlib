function anim_make(titl);
% ANIM_MAKE makes a FLC movie from the frames prepared by ANIM_FRAME
% using PPM2FLI.   
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
% This version uses PNG images as input, which requires
% a PNG to PPM convertor for PPM2FLI to work.  
%
% So before you use this m-file, you need the following programs
% installed:
%
% For Linux:
%
%   - "ppm2fli" is available at http://vento.pi.tu-berlin.du/ppm2fli/main.html
%   -  A program to convert PNG to PPM:
%      I use "convert", part of the ImageMagick image package available at:
%        http://www.wizards.dupont.com/cristy/ImageMagick.html 
%        Some binaries are available for popular platforms -- you might
%        want to check this first.
%
% For Windows:
%    - make a new directory called c:\tmp on your machine.
%    - Get VideoMach   (http://www.videomach.com) to make
% flc movies from .png files.  You need to make sure the VideoMach
% directory is in your windows system path.  Right click on "My Computer" and 
% then go to "Advanced" and add it to your system path.  Then reboot.  To check,
% you need to be able to type
% >> !videomach 
% in Matlab and have the videomach convertor pop up.
%
%   - "the fliplay applet", which is necessary if you want to deliver the
%        animation to people over the web without FLC viewers, is at:
%        http://vento.pi.tu-berlin.du/fliplay/main.html

% Rich Signell (rsignell@usgs.gov) adapted from code by Jamie Pringle  

global makemovienx makemovieny anim_name

%---------------------------------------------------------------------
if strmatch(computer,'PCWIN')    %my 32 bit windows machine
    cmd=sprintf('!videomach /OpenFile=\\tmp\\%s*.png /SaveVideo=%s.flc /Start /Exit',anim_name,anim_name)
eval(cmd);
elseif strmatch(computer,'GLNX86')   %my 32 bit Linux machine
% using ppm2fli to convert png to flc
%convert_command='png2pnm'
convert_command='convert png:- ppm:-'
%---------------------------------------------------------------------
% Make the frame list

tmpdir=getenv('TMPDIR');
if (isempty(tmpdir)),
  tmpdir='/tmp'
end
eval(sprintf('!/bin/ls %s/%s????.png > %s/%s.lst',...
    tmpdir,anim_name,tmpdir,anim_name))

% call PPM2FLI (Unix Program)
% using the -N option to allow reverse playback in Xanim

eval(sprintf(...
['!ppm2fli -f ''' convert_command ''' -N -g %dx%d %s/%s.lst %s.flc'],...
    makemovienx,makemovieny,tmpdir,anim_name,anim_name))

disp(sprintf('Created %s.flc',anim_name));

% remove the temporary files

eval(sprintf('!/bin/rm %s/%s????.png %s/%s.lst',...
  tmpdir,anim_name,tmpdir,anim_name))
disp(sprintf('Removed temporary images %s/%s????.png',tmpdir,anim_name))

else
    disp('Computer type yet not handled- modify anim_make.m');
end

disp(sprintf('Created %s.flc',anim_name));

% remove the temporary files

%eval(sprintf('!del \\tmp\\%s????.pcx',anim_name))
%disp(sprintf('Removed temporary images \\%s????.pcx',anim_name))

if(nargin==1),
  eval(sprintf('!zip %s.zip %s.flc',anim_name,anim_name));
  fid=fopen([anim_name '.html'],'wt');
  fprintf(fid,'<html>\n');
  fprintf(fid,'<center><h1> %s </h1><p>\n',titl);
  fprintf(fid,'Click with mouse to get movie controls:<br>');
  fprintf(fid,'<APPLET code=fliplay.class width=%d height=%d>\n',...
     makemovienx,makemovieny);
  fprintf(fid,'<PARAM name=File value=%s.zip>\n',anim_name);
  fprintf(fid,'<PARAM name=Speed value=100>\n');
  fprintf(fid,'<PARAM name=Loops value=-1>\n');
  fprintf(fid,'<PARAM name=End value=-1>\n');
  fprintf(fid,'<PARAM name=ZipFile value=yes>\n');
  fprintf(fid,'</APPLET></center></body></html>\n');
  disp(sprintf('Created %s.html',anim_name));
end
