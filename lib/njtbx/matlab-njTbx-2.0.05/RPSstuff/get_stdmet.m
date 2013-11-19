% GET_STDMET  
% Get Standard Met data from Buoys via OpenDAP 
% Concatenates variables between specified date range
% Here we are getting just wind and wave height, but could easily add others

% Rich Signell (rsignell@usgs.gov)
%  buoys = [  buoy_id anemometer_height(m)]
buoys=[44005 5  %78 NM east of Portsmouth, NH
       44007 5  % 12 NM east of Portland
       44008 5  % 54 NM east of Nantucket
       44011 5  % Georges Bank
       44013 5  % Boston 
       44018 5   % 30 NM east of Nantucket
       44027 5  % Jonesport
%       44028 13.8 % Buzzards Bay (doesn't have a OpenDAP std_met URL)
       44029 4  % GOMOOS A - Mass Bay
       44030 4  % GOMOOS B - Western Maine Shelf
       44031 4  % GOMOOS C - Casco Bay
       44021 2  % GOMOOS D - New Meadows
       44032 4  % GOMOOS E - Central Maine Shelf
       44033 4  % GOMOOS F - West Penobscot Bay
       44034 4  % GOMOOS I - Eastern Maine Shelf
       44035 4  % GOMOOS J - Cobscook Bay
       44037 4  % GOMOOS M - Jordan Basin
       44038 4  % GOMOOS L - Scotian Shelf
       44024 4];  % GOMOOS N - Northeast Channel
  
years=[2007 9999];  % grab data for 2007 (9999 is always the latest few months)
jdi=julian([2007 3 1 0 0 0]):1/24:julian([2007 12 31 23 0 0]);
nyears=length(years);    
[nbuoys,foo]=size(buoys);
%for i=1:nbuoys,
for i=nbuoys-2:nbuoys
    wt=[];jdt=[];ht=[];
    for j=1:nyears
      sprintf('Processing Buoy %4.4d',buoys(i,1))      
      url=sprintf('http://dods.ndbc.noaa.gov:8080/opendap/stdmet/%4.4d/%4.4dh%4.4d.nc',...
        buoys(i,1),buoys(i,1),years(j));
      try 
      s=urlread([url '.das']);
      nc=netcdf(url);
      lon(i)=nc{'longitude'}(1);
      lat(i)=nc{'latitude'}(1);
      tim=nc{'time'}(:);
      ht=[ht(:); nc{'wave_height'}(:)];
      wdir=nc{'wind_dir'}(:);
      wspd=nc{'wind_spd'}(:);
  
      % convert wind from anemometer height to 10 m, using neutral wind
      % assumption
      [foo,foo,wspd10,foo]=wstress(wspd,0*wspd,buoys(i,2)); 
      wt=[wt; wspd10(:).*exp(sqrt(-1)*(270-wdir(:))*pi/180)];
      jdt=[jdt; julian([1970 1 1 0 0 0])+tim/3600/24];
      ind=find(diff(jdt)>0.05);
      wt(ind)=nan;
      ht(ind)=nan;
      close(nc);
      catch
      end
    end
    w(:,i)=interp_r(jdt,wt,jdi);
    hsig(:,i)=interp_r(jdt,ht,jdi);
end