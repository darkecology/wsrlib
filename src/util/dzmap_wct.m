function [dzmap, dzlim, bins] = dzmap_wct()
% DZMAP_WCT Reflectivity colormap copied from NOAA's WCT software

% WCT cm
rr = fliplr([235 153 255 192 214 255 255 231 255 000 000 000 000 001 000 187 174 150 102 050 000]);
gg = fliplr([235 085 000 000 000 000 144 192 255 144 200 255 000 160 236 255 238 205 139 079 000]);
bb = fliplr([235 201 255 000 000 000 000 000 000 000 000 000 246 246 236 255 238 205 139 079 000]);

dzmap = [(rr./255)' (gg./255)' (bb./255)'];

dzlim = [-25, 75];

bins = -25:5:75;

% For displaying colorbar as an image to save out
% figure
% colormap(dzmap)
% colorbar('h')
% caxis(dzlim)

% # WCT palette - similar to other palettes, but alpha
% # is added and values are optional.  If the 
% # value is specified as 'NA' for any color, 
% # the max/min values of the data will be used
% # and the colors interpolated across the range
% # of values.
% 
% #            R    G    B    A
% Color:  75   235  235  235  255
% Color:  70   153  85   201  255
% Color:  65   255  0    255  255
% Color:  60   192  0    0    255
% Color:  55   214  0    0    255
% Color:  50   255  0    0    255
% Color:  45   255  144  0    255
% Color:  40   231  192  0    255
% Color:  35   255  255  0    255
% Color:  30   0    144  0    255
% Color:  25   0    200  0    255 
% #Color:  25   0    0  0    50 
% Color:  20   0    255  0    255
% Color:  15   0    0    246  255 
% Color:  10   1    160  246  255
% Color:  5    0    236  236  255
% Color:  0    187  255  255  255
% Color:  -5   174  238  238  255
% Color:  -10  150  205  205  255
% Color:  -15  102  139  139  255
% Color:  -20  50   79   79   255
% Color:  -25   0   0    0    255
% 
% Unique: 800 "RF"    119   0  125

end