function [x,y,z,map]=read_geotiff(fil);
% READ_GEOTIFF reads data and x,y coordinate info from GeoTIFF file
% Usage: [x,y,z]=read_geotiff(fil);
% Example: [lon,lat,z]=read_geotiff('gom_bathy.tif');

% Rich Signell (rsignell@usgs.gov)
% 25-Apr-2006
[z,map]=imread(fil);
tags=tifftags(fil);
i1=strmatch('ModelPixelScaleTag',char(tags{:,2}));
i2=strmatch('ModelTiepointTag',char(tags{:,2}));
%if isempty(i1)
%    i1=strmatch('XResolution',char(tags{:,2}));
%   i2=strmatch('YResolution',char(tags{:,2}));
%   
[ny,nx]=size(z);
ul=tags{i2,3};
pix=tags{i1,3};
dx=pix(1);
dy=pix(2);
x=ul(4)+[1:nx]*dx-dx/2;
y=(ul(5)-[1:ny]*dy+dy/2);
return

function info = tifftags(filename)
% TIFFTAGS: Get tag information from a TIFF file.
%   INFO = TIFTAGS(FILENAME) returns a cell array containing the
%   tag data from a TIFF file.  INFO will be P-by-3-by-N, where P
%   is the maximum number of tags found for an image and N is the
%   number of images in the file.  The first column of P contains
%   the tag ID numbers; the second column of P contains the tag
%   names (if known); the third column of P contains the tag
%   data.

%   Steven L. Eddins
%   Friday the 13th, March 1998 (experimental)
%   Copyright (c) 1984-98 by The MathWorks, Inc.

info = [];

if (~isstr(filename))
    msg = 'FILENAME must be a string';
    return;
 end

% TIFF files might be little-endian or big-endian.  Start with
% little-endian.  If we're wrong, we'll catch it down below and
% reopen the file.
[fid,m] = fopen(filename, 'r', 'ieee-le');
if (fid == -1)
    error(m);
end

sig = fread(fid, 4, 'uint8')';
if (~isequal(sig, [73 73 42 0]) & ...
    ~isequal(sig, [77 77 0 42]))
    fclose(fid);
    error('Not a TIFF file');
end

if (sig(1) == 73)
    byteOrder = 'little-endian';
else
    byteOrder = 'big-endian';
end

if (strcmp(byteOrder, 'big-endian'))
    % Whoops!  Must reopen the file.
    pos = ftell(fid);
    fclose(fid);
    fid = fopen(filename, 'r', 'ieee-be');
    fseek(fid, pos, 'bof');
end
    
nextIFDOffset = fread(fid, 1, 'uint32');
imageNum = 1;

while (nextIFDOffset ~= 0)
    status = fseek(fid, nextIFDOffset, 'bof');
    if (status ~= 0)
        % The seek to find the next IFD just failed.  This is probably
        % because of a nonconforming TIFF file that didn't store the
        % offset to the next IDF correctly at the end of the last IFD.
        % The best we can do here is assume there aren't any more IFD's.
        break;
    end
    
    tagCount = fread(fid, 1, 'uint16');
    tagPos = ftell(fid);
    
    %
    % Process the tags
    %
    for p = 1:tagCount
        fseek(fid, tagPos, 'bof');
        % Read tag ID
        tagID = fread(fid, 1, 'uint16');
        info{p,1,imageNum} = tagID;
        info{p,2,imageNum} = TagName(tagID);
        fieldType = fread(fid, 1, 'uint16');
        numValues = fread(fid, 1, 'uint32');
        
        % Read tag data
        info{p,3,imageNum} = ReadTagData(fid, fieldType, numValues);

        % Position to read the next tag in this IFD.
        tagPos = tagPos + 12;
    end
    
    fseek(fid, tagPos, 'bof');
    nextIFDOffset = fread(fid, 1, 'uint32');
    
    imageNum = imageNum + 1;
end  %%%% while

fclose(fid);

function data = ReadTagData(fid, fieldType, numValues)

switch fieldType
    case 1
        % 8-bit unsigned integer
        if (numValues <= 4)
            data = fread(fid, numValues, 'uint8');
        else
            fseek(fid, fread(fid, 1, 'uint32'), 'bof');
            data = fread(fid, numValues, 'uint8');
        end
        
    case 2
        % 8-bit byte that contains a 7-bit ASCII code; the last byte
        % must be NUL (binary zero)
        if (numValues <= 4)
            data = fread(fid, numValues, 'char');
            data = char(data(1:end-1)); % convert to string and dump the NUL
        else
            fseek(fid, fread(fid, 1, 'uint32'), 'bof');
            data = fread(fid, numValues, 'char');
            data = char(data(1:end-1));  % convert to string and dump the NUL
        end
        
    case 3
        % 16-bit unsigned integer
        if (numValues <= 2)
            data = fread(fid, numValues, 'uint16');
        else
            fseek(fid, fread(fid, 1, 'uint32'), 'bof');
            data = fread(fid, numValues, 'uint32');
        end
        
    case 4
        % 32-bit unsigned integer
        if (numValues <= 1)
            data = fread(fid, numValues, 'uint32');
        else
            fseek(fid, fread(fid, 1, 'uint32'), 'bof');
            data = fread(fid, numValues, 'uint32');
        end
        
    case 5
        % Two 32-bit unsigned integers; the first represents the numerator
        % of a fraction; the second, the denominator
        fseek(fid, fread(fid, 1, 'uint32'), 'bof');
        data = fread(fid, 2*numValues, 'uint32');
        data = data(1:2:end) ./ data(2:2:end);
        
    case 6
        % 8-bit signed integer
        if (numValues <= 4)
            data = fread(fid, numValues, 'int8');
        else
            fseek(fid, fread(fid, 1, 'uint32'), 'bof');
            data = fread(fid, numValues, 'int8');
        end
        
    case 7
        % UNDEFINED --- an 8-bit byte that may contain anything
        if (numValues <= 4)
            data = fread(fid, numValues, 'uint8');
        else
            fseek(fid, fread(fid, 1, 'uint32'), 'bof');
            data = fread(fid, numValues, 'uint8');
        end
        
    case 8
        % 16-bit signed integer
        if (numValues <= 2)
            data = fread(fid, numValues, 'int16');
        else
            fseek(fid, fread(fid, 1, 'uint32'), 'bof');
            data = fread(fid, numValues, 'int16');
        end
        
    case 9
        % 32-bit signed integer
        if (numValues <= 1)
            data = fread(fid, numValues, 'int32');
        else
            fseek(fid, fread(fid, 1, 'uint32'), 'bof');
            data = fread(fid, numValues, 'int32');
        end
        
    case 10
        % Two 32-bit signed integers; the first represents the numerator
        % of a fraction; the second the denominator
        fseek(fid, fread(fid, 1, 'uint32'), 'bof');
        data = fread(fid, 2*numValues, 'int32');
        data = data(1:2:end) ./ data(2:2:end);
        
    case 11
        % Single-precision IEEE float
        if (numValues <= 1)
            data = fread(fid, numValues, 'float32');
        else
            fseek(fid, fread(fid, 1, 'uint32'), 'bof');
            data = fread(fid, numValues, 'float32');
        end
        
    case 12
        % Double-precision IEEE float
        fseek(fid, fread(fid, 1, 'uint32'), 'bof');
        data = fread(fid, numValues, 'float64');
        
    otherwise
        % Field type not defined in TIFF spec 6.0; return empty.
        data = [];
        
end
   
% Data prints better if it's a row vector.
data = data';

function name = TagName(tagnum)

switch tagnum
    case 254
        name = 'NewSubfileType';
        
    case 255
        name = 'SubfileType';
        
    case 256
        name = 'ImageWidth';
        
    case 257
        name = 'ImageLength';
        
    case 258
        name = 'BitsPerSample';
        
    case 259
        name = 'Compression';
        
    case 262
        name = 'PhotometricInterpretation';
        
    case 263
        name = 'Thresholding';
        
    case 264
        name = 'CellWidth';
        
    case 265
        name = 'CellLength';
        
    case 266
        name = 'FillOrder';
        
    case 269
        name = 'DocumentName';
        
    case 270
        name = 'ImageDescription';
        
    case 271
        name = 'Make';
        
    case 272
        name = 'Model';
        
    case 273
        name = 'StripOffsets';
        
    case 274
        name = 'Orientation';
        
    case 277
        name = 'SamplesPerPixel';
        
    case 278
        name = 'RowsPerStrip';
        
    case 279
        name = 'StripByteCounts';
        
    case 280
        name = 'MinSampleValue';
        
    case 281
        name = 'MaxSampleValue';
        
    case 282
        name = 'XResolution';
        
    case 283
        name = 'YResolution';
        
    case 284
        name = 'PlanarConfiguration';
        
    case 285
        name = 'PageName';
        
    case 286
        name = 'XPosition';
        
    case 287
        name = 'YPosition';
        
    case 288
        name = 'FreeOffsets';
        
    case 289
        name = 'FreeByteCounts';
        
    case 290
        name = 'GrayResponseUnits';
        
    case 33550
        % GeoTIFF tag
        name = 'ModelPixelScaleTag';
        
    case 34264
        % GeoTIFF tag
        name = 'ModelTransformationTag';
        
    case 33922
        % GeoTIFF tag
        name = 'ModelTiepointTag';
        
    case 34735
        % GeoTIFF tag
        name = 'GeoKeyDirectoryTag';
        
    case 34736
        % GeoTIFF tag
        name = 'GeoDoubleParamsTag';
        
    case 34737
        % GeoTIFF tag
        name = 'GeoAsciiParamsTag';
        
    case 33920
        % Obsolete GeoTIFF tag
        name = 'IntergraphMatrixTag';
        
    otherwise
        % Unknown tag
        name = 'unknown';
        
end
