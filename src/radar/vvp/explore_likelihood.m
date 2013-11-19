% Theoretical exploration of likelihood space
%
% Fix reference parameters --> aliased sine curve y1
%
% Explore other parameters --> aliased sine curve y2 and measure error
% between y1 and y2
%
% View error as a function of parameters
%
% The likelihood surface follows a bullseye pattern emanating outward from
% the true parameters. In particular it is multi-modal.
%

az = linspace(0, 2*pi, 720);

nyq_vel = 11;

thet1 = deg2rad(90);
r1 = 30;


y1 = alias(r1*cos(az - thet1), nyq_vel);

u = linspace(-100, 100, 100);
v = linspace(-100, 100, 100);

[U, V] = meshgrid(u, v);
[TH, R] = cart2pol(U, V);

ERR = nan(size(TH));

for i=1:numel(TH)
   
    thet2 = TH(i);
    r2 = R(i);
    y2 = alias(r2*cos(az - thet2), nyq_vel);

    err = abs(y1 - y2);
    err = min(err, 2*nyq_vel - err);
    
    ERR(i) = mean(err);
    
end

figure(1);
clf();
imagesc(u, v, ERR);
axis xy;
colorbar();
% figure(1);
% surf(U, V, ERR, 'edgecolor', 'none')


while true
        
    figure(1);
    [uin, vin] = ginput(1); 
    
    [thet2, r2] = cart2pol(uin, vin);
    y2 = alias(r2*cos(az - thet2), nyq_vel);
    
    figure(2);
    clf();
    
    subplot(2, 1, 1);
    plot([y1' y2'], '.')
    ylim([-nyq_vel, nyq_vel]);
    
    subplot(2, 1, 2);
    daz = diff([az az(1) + 2*pi]);
    
    d1 = diff([y1 y1(1)]);
    d1 = alias(d1, nyq_vel)./daz;
    
    d2 = diff([y2 y2(1)]);
    d2 = alias(d2, nyq_vel)./daz;
    
    plot([d1' d2'], '.');
    
    err = abs(y1 - y2);
    err = min(err, 2*nyq_vel - err);
    fprintf('MAE: %.4f\n', nanmean(err));
    
    
end