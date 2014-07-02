
neglogprior = @(w) (w'*K0*w/2 - b0'*w);
negloglik   = @(w) (wrapped_normal_nll(nyq_vel, X*w, y, sigma, 2));
neglogapprox = @(w) (w'*K*w/2 - b'*w);

vmax = 30;
x = linspace(-vmax, vmax, 40);

[U,V] = meshgrid(x, x);

Z1 = nan(size(V));
Z2 = nan(size(V));
Z3 = nan(size(V));
Z4 = nan(size(V));

for i=1:numel(U)
    w = [U(i) V(i)]';
    Z1(i) = neglogprior(w);
    Z2(i) = negloglik(w);
    Z4(i) = neglogapprox(w);
end

Z3 = Z1 + Z2;
Z5 = Z4 - Z1;

% Shift all so min is zero
Z1 = Z1 - min(Z1(:));
Z2 = Z2 - min(Z2(:));
Z3 = Z3 - min(Z3(:));
Z4 = Z4 - min(Z4(:));
Z5 = Z5 - min(Z5(:));

upper = max(Z3(:));
lim = [0 upper];

fs = 12;
width = 4.2;
height = 3;


figure(1);
colormap(hot(32));
clf();
set(gca, 'Fontsize', fs);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'Papersize', [width height]);
set(gcf, 'PaperPosition', [0 0 width height]);
imagescnan(x, x, Z1, lim);
%surf(x,x,Z1);
hc = colorbar();
set(hc, 'FontSize', fs);
xlabel('u');
ylabel('v');
title('Neg. log prior');

figure(2);
colormap(hot(32));
clf();
set(gca, 'Fontsize', fs);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'Papersize', [width height]);
set(gcf, 'PaperPosition', [0 0 width height]);
imagescnan(x, x, Z2, lim);
%surf(x,x,Z2);
hc = colorbar();
set(hc, 'FontSize', fs);
xlabel('u');
ylabel('v');
title('Neg. log likelihood');

figure(3);
colormap(hot(32));
clf();
set(gca, 'Fontsize', fs);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'Papersize', [width height]);
set(gcf, 'PaperPosition', [0 0 width height]);
imagescnan(x, x, Z3, lim);
%surf(x,x,Z3);
hc = colorbar();
set(hc, 'FontSize', fs);
xlabel('u');
ylabel('v');
title('Neg. log joint');

figure(4);
colormap(hot(32));
clf();
set(gca, 'Fontsize', fs);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'Papersize', [width height]);
set(gcf, 'PaperPosition', [0 0 width height]);
imagescnan(x, x, Z4, lim);
%surf(x,x,Z4);
hc = colorbar();
set(hc, 'FontSize', fs);
xlabel('u');
ylabel('v');
title('Neg. log approx');

figure(5);
colormap(hot(32));
clf();
set(gca, 'Fontsize', fs);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'Papersize', [width height]);
set(gcf, 'PaperPosition', [0 0 width height]);
imagescnan(x, x, Z5, lim);
%surf(x,x,Z4);
hc = colorbar();
set(hc, 'FontSize', fs);
xlabel('u');
ylabel('v');
title('Neg. log approx');

