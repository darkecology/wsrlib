function anim_frame(name,frame_num);
% ANIM_FRAME makes a frame for later conversion into a movie by ANIM_MAKE
%          name = the base name of the movie
%     frame_num = the number of the frame being written out
%

% This version writes out PCX images, which are 8-bit images using a 
% simple no-loss compression scheme

% Rich Signell (rsignell@usgs.gov) adapted from code by Jamie Pringle

global makemovienx makemovieny anim_name

anim_name=name;

if strmatch(computer,'PCWIN')    %my 32 bit windows machine% Capture the frame:

%[X,map]=getframe(gcf);  %Matlab 5.3 syntax
% [X,map]=capture; % pre-Matlab 5.3 syntax

% Write out the image in PCX format:

%imwrite(X,map,sprintf('/tmp/%s%4.4d.pcx',name,frame_num),'PCX');
fixpaper2
cmd=sprintf('print -dpng -r0 \\tmp\\%s%4.4d.png',name,frame_num);
eval(cmd) 
%makemovienx=size(X,2);
%makemovieny=size(X,1);
elseif strmatch(computer,'GLNX86')   %my 32 bit Linux machine
    [f]=getframe(gcf);  %Matlab 5.3 syntax
[X,map]=frame2im(f);
% [X,map]=capture; % pre-Matlab 5.3 syntax

% Write out the image in png format:

tmpdir=getenv('TMPDIR');
if (isempty(tmpdir)),
  tmpdir='/tmp'
end
outfile=sprintf('%s/%s%4.4d.png',tmpdir,name,frame_num)
%imwrite(X,map,outfile,'png');
imwrite(X,outfile,'png');

makemovienx=size(X,2);
makemovieny=size(X,1);
else
     disp('Computer type yet not handled- modify anim_frame.m');
end
