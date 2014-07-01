function cmap = vrmap2(n)
  
    red   = rgb2hsv([1 0 0]);
    green = rgb2hsv([0 1 0]);

    m = ceil(n/2 - 1);    
    rem  = n - 2*m;
    
    saturation = linspace(0.8,  0.1,  m)';
    brightness = linspace(0.1,    1,  m)';
        
    red_hue = red(1);
    green_hue = green(1);
    
    green_hsv = [repmat(green_hue, m, 1), saturation, brightness];
    red_hsv   = [repmat(red_hue, m, 1),   saturation, brightness];
                
    green_rgb = hsv2rgb(green_hsv);
    red_rgb   = hsv2rgb(red_hsv);
    
    white = [1 1 1];
    
    cmap = [green_rgb;
            repmat(white, rem, 1);
            red_rgb(m:-1:1,:)];
            