% BME671L Lab #6: aliasing, folding, images

% Your name: Jiaxu Meng

% LABEL ALL AXES WHERE APPROPRIATE
 
close all, clear all

%%
% Q1: Consider three sinusoids: 
% a) x(t) = (3 + 4j)exp(j 4 pi t)=5*exp(j(4pi*t+0.9273)). A sampled version of this sinusoid x[n]
%    is obtained using a sampling frequency of fs = 48 Hz.
% b) xa(t) that has the same discrete-time signal x[n] as a result of
%    aliasing. Use the signal with the smallest possible frequency.
% c) xf(t) that has the same discrete-time signal x[n] as a result of
%    folding. Use the signal with the smallest possible frequency.
% fa=50Hz wa^=+-25pi/12
% ff=46Hz wf^=+-23pi/12

%%
% Q2: Plot the real parts of x(t) and xa(t) on the same graph.
% Indicate the sampled points. 

t = 0:0.001:0.5;
ts = 0:(1/48):0.5;
x = @(t) 5*cos(4*pi*t+0.9273);
xa = @(t) 5*cos(100*pi*t+0.9273);
xf = @(t) 5*cos(92*pi*t-0.9273);
figure;
plot(t,x(t),t,xa(t));
hold on
plot(ts,xa(ts),'k*');
xlabel('t(s)');

%%
% Q3: Make a similar plot for x(t) and xf(t). Use subplot to put the plots
% of Q2 and Q3 on the same figure. Add legends.
figure;
subplot(2,1,1);
plot(t,x(t),t,xa(t));
hold on
plot(ts,xa(ts),'k*');
xlabel('t(s)');
legend('x(t)','xa(t)','sampled points');
subplot(2,1,2);
plot(t,x(t),t,xf(t));
hold on
plot(ts,xf(ts),'k*');
xlabel('t(s)');
legend('x(t)','xf(t)','sampled points');

%%
% Q4: Plot the discrete-time spectra of all 3 signals on the same
% graph. Feel free to use any commands from previous labs. Use w for
% the x-axis.
figure;
f = [-25*pi/12 -23*pi/12 -pi/12 pi/12 23*pi/12 25*pi/12];
X = [3-1i*4 3+1i*4 3-1i*4 3+1i*4 3-1i*4 3+1i*4];
plot_spectra(f, X, 'w');

% ********************************************************************
%   SHOW YOUR SPECTRUM TO THE TA TO RECEIVE CREDIT FOR THE LAB
% ******************************************** ***********************

%%
% Q5: Describe the patterns in the magnitude and phase plots. 

% YOUR ANSWER: w_hat equals +/-pi/12 gives the primary alias,
% which corresponds to the digitized x(t).  w_hat equals +/-23pi/12 gives
% the folding alias, which corresponds to the digitized xf(t).  w_hat
% equals +/-25pi/12 gives the aliasing alias, which corresponds to the
% digitized xa(t).
% In magnitude spectrum, 6 spectral lines are of the same
% magnitude which is 5. 
% In phase spectrum, 3 spectral lines with negative phase indicates
% conjugate complex phasor.  The folding case is special since the positive
% component (23pi/12) corresponds to the conjugate one.

%%
% Q6: There are an infinite number of signals that have the same
% principal alias. xa2(t) and xf2(t) are even higher frequency signals
% that have same discrete-time signal x[n] as a result of
% aliasing/folding. List 3 possible frequencies for each and create a
% new figure that displays the spectrum with these additional signals.

% YOUR ANSWER:
% fa2 = 98, 146, 194
% ff2 = 94, 142, 190
figure;
f_pos = [pi/12 23*pi/12 25*pi/12 47*pi/12 49*pi/12 71*pi/12 73*pi/12 95*pi/12 97*pi/12];
X_pos = [3+1i*4 3-1i*4 3+1i*4 3-1i*4 3+1i*4 3-1i*4 3+1i*4 3-1i*4 3+1i*4];
f_neg = flip(-f_pos);
X_neg = flip(conj(X_pos));
f = cat(1,f_neg,f_pos);
X = cat(1,X_neg,X_pos);
plot_spectra(f, X, 'w');

%%
% Q7: Up until now we have only considered time-dependent signals.
% However, the sampling theorem applies to any continuous signal. For
% example, digital images are created by sampling in two spatial
% dimensions. 
%   * Load lighthouse.mat which has an image stored as xx.
%   * Display the image using imshow
figure;
xx = load('lighthouse.mat');
imshow(xx.xx);
axis on

%%
% Q8: To save space, sometimes images are down-sampled to a lower
% resolution. Simulate down-sampling by throwing away every other
% sample in both directions. Display the image using imshow. Why is
% the figure smaller?
figure;
xx = xx.xx;
x2 = xx(1:2:end,1:2:end);
imshow(x2);
whos x2
% YOUR ANSWER: Down-sampling removes every other sample away, so it shrink
% the size of the image

%%
% Q9: To avoid automatic resizing of figure with the down-sampled
% image, display the image using imagesc. Matlab defaults to a color
% map called "parula". Check out how this affects the image before
% changing the color map to gray. Also turn the axis off.
figure;
imagesc(x2);
colormap(gray);
axis off

%% 
% Q10: There is aliasing in the down-sampled image. Describe how the
% aliasing appears visually. Which parts of the imaging show the
% aliasing effects most dramatically?

% YOUR ANSWER: The edges are not clear and different fences cannot be
% distinguished.
% The fences are alisaed dramatically.

%%
% Q11: Explain why the aliasing happens in the lighthouse image using
% a "frequency domain" explanation. In other words, estimate the
% frequency of the features that are being aliased in cycles per
% pixel. How does your frequency estimate relate to the Sampling
% Theorem?

cyclepixel=xx(200,150:320);
figure;
plot(cyclepixel);
xlabel('pixel');

% YOUR ANSWER: The fence has more high frequency components (many edges with narrow distance)
% than the other part of the image.  When the image experiences
% down-sampling, the dramatic effect of aliasing appears at the fence since
% the high frequency component is aliased to low frequency.
% The frequency is increasing from the left to the right.  The frequency is
% 10 cycles/20 pixel=0.5 cycle/pixel, so fmax=0.5Hz.
% In sampling theorem, fs should be larger than 2fmax, which is 1
% cycle/pixel.
% The sampling period Ts is 2 pixels due to downsampling by
% removing every other pixel, so the sampling frequency fs is 0.5
% samples/pixel.

%%
% When you are done:
%	* Show the indicated result/figure to the TA during the lab period
%       to receive credit
%	* upload your script to Sakai
%   * upload a pdf containing your script and outputs.
%   * PRINT a copy of your pdf to turn in at the beginning of class on
%     Tuesday
                                                                                                                                                                                                                                                                                                                                                    