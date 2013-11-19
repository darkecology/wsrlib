function scaninfo = wsr88d_scaninfo(filename)
  
  [path, name, ext] = fileparts(filename);
  
  tokens = regexp(name, '(\w{4})(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})(\d{2})(_\w+)?', 'tokens', 'once');
  
  [station, y, month, d, h, m, s, v] = tokens{:};
  
  scaninfo.station = station;
  scaninfo.year = str2num(y); %#ok<*ST2NM>
  scaninfo.month = str2num(month);
  scaninfo.day = str2num(d);
  scaninfo.hour = str2num(h);
  scaninfo.minute = str2num(m);
  scaninfo.second = str2num(s);
  scaninfo.version = v;
  scaninfo.ext = ext;
  scaninfo.timestamp = name(1:19);
  scaninfo.path = path;
  scaninfo.name = [name ext];

  % mysql format time/date strings
  scaninfo.scan_date = sprintf('%4d-%02d-%02d', scaninfo.year, scaninfo.month, scaninfo.day);
  scaninfo.scan_time = sprintf('%02d:%02d:%02d', scaninfo.hour, scaninfo.minute, scaninfo.second);
