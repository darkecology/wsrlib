% ANIM_DEMO Demonstration of how to make a FLC movie in Matlab/UNIX
% using ANIM_FRAME and ANIM_MAKE.  
%
% The technique is to grab each frame exactly as it appears in the
% figure window using GETFRAME (a.k.a. CAPTURE) to get the image,
% and then using IMWRITE to output the image to a file.  These images
% are then assembled into a FLC format animation using the Unix program
% "ppm2fli".  Since IMWRITE doesn't write out the PPM images that 
% "ppm2fli" natively uses, we use the '-f ' option in ppm2fli and supply
%  the name of a pcx to ppm conversion routine "pcxtoppm" and "convert"
%  are popular free programs that build easily on nearly all UNIX platforms
%  as the filter (or conversion) program. See ANIM_MAKE.m for details
%  about where to get these UNIX programs. 
%
% To run ANIM_DEMO, you need PPM2FLI installed and in your UNIX path, 
% available at:  http://vento.pi.tu-berlin.du/ppm2fli/main.html
% 
% You also need a PCX to PPM conversion tool installed.  See ANIM_MAKE.m
% for details.
 
% Rich Signell (rsignell@usgs.gov)
% 

peaks(40);
[ax,el]=view;

for i=1:9
  view(ax,el+i*2);

% STEP 1. Make each frame with ANIM_FRAME
  anim_frame('peaks',i);

end

% STEP 2. Make the frames into a FLC with ANIM_MAKE

% option 1: just make the .flc:

anim_make2;

% option 2: 
% providing a string argument causes the .flc
% file to be zipped, and then HTML to be
% generated that references the .zip file and
% the FLIPLAY applet.    You can get the FLIPLAY
% applet at http://vento.pi.tu-berlin.de/fliplay/main.html

%anim_make('peaks movie');  
                           

