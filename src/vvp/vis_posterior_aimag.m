
neglogprior = @(w) (w'*K0*w/2 - b0'*w);
negloglik   = @(w) (wrapped_normal_nll(nyq_vel, X*w, y, sigma, 2));
neglogapprox = @(w) (w'*K*w/2 - b'*w);

vmax = 30;
x = linspace(-vmax, vmax, 40);

[U,V] = meshgrid(x, x);

Z = nan(size(V));

for i=1:numel(U)
    w = [U(i) V(i)]';
    Z(i) = -negloglik(w);
end

fs = 8;
width = 2.45;
height = 1.5;

figure(1);
colormap(hot(32));
clf();
set(gca, 'Fontsize', fs);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'Papersize', [width height]);
set(gcf, 'PaperPosition', [0 0 width height]);
imagescnan(x, x, Z);
%surf(x,x,Z2);
hc = colorbar();
set(hc, 'FontSize', fs);
xlabel('u');
ylabel('v');
title('Log-likelihood');

print -depsc -painters figs/likelihood.eps
system('epstopdf figs/likelihood.eps');