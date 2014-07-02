
earth_radius = 6371200; % from NARR GRIB file
multiplier = 4/3;

a_e = earth_radius * multiplier;

elev = 10;
r = 10000 + (2500:2500:10000);

az = -135;

thet = deg2rad(elev);
thet_prime = thet + atan(r .* cos(thet)./(a_e + r .* sin(thet)));

phi = deg2rad(az);

x = r .* cos(thet_prime) .* sin(phi);
y = r .* cos(thet_prime) .* cos(phi);
z = sqrt(a_e^2 + r.^2 +  2 * r .* a_e .* sin(thet)) - a_e;

[dist, height] = slant2ground(r, elev);

xx = dist .* sin(phi);
yy = dist .* cos(phi);

