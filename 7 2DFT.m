% BME671L Lab #7: 2D Fourier Transform, fft2, fftshift

% Your name: Jiaxu Meng

% DISPLAY ALL IMAGES USING COLORMAP gray(256). SET THE AXIS SO THE
% IMAGES ARE NOT DISTORTED (e.g. square)
 
close all, clear all

%%
% Q1: Load pattern.mat, display the image and add a color bar. What
% pattern do you observe? What is the frequency of this pattern?

xx=load('pattern.mat');
xx_pic=xx.pattern;
figure(1);
imagesc(xx_pic);
colorbar;
colormap('gray');
title('Pattern');

% YOUR ANSWER: There are 4 peaks in 128 pixels,
% so frequency = 4/128 cycles/pixel = 1/32 cycle/pixel

%%
% Q2: Plot one row and one column of pattern on the same figure using
% subplots. Add titles and axis labels. What function is represented
% in this image?

figure(2);
subplot(2,1,1);
r=xx_pic(64,1:128);
plot(r);
xlabel('pixels');
ylabel('amplitude');
title('row of pattern');
subplot(2,1,2);
c=xx_pic(1:128,64);
plot(c);
xlabel('pixels');
ylabel('amplitude');
title('column of pattern');

% YOUR ANSWER: The rows of the pattern represent DC signals with
% different offsets.
% The columns of the pattern represent cosinusoidal signals with the same
% amplitude and period.

%% 
% Q3: Display the 2D Fourier transform of this image. Use the 'zoom'
% command to zoom in on the part of the image with signal. You must
% divide the matlab output by 128^2 for the scaling to be consistent.

figure(3);
Y = fftshift(fft2(xx_pic));
Y=Y/(128^2);
%128^2 is the total number of matrix
imagesc(abs(Y));
colormap('gray');
colorbar;
xlabel('column frequency');
ylabel('row frequency');
zoom(8);
title('2D FT (magnitude spectrum) of Pattern');

% ********************************************************************
%   SHOW YOUR IMAGE TO THE TA TO RECEIVE CREDIT FOR THE LAB
% ******************************************** ***********************


%%
% Q4: How does the 2D FT relate to the original image?

% YOUR ANSWER: The 2D FT is the magnitude spectrum of the original image.
% The x-axis corresponds to column frequency. 
% The y-axis corresponsds to row frequency.
% The spectral lines are at (65,61),(65,65),(65,69) with the magnitude
% showed as colorbar.

%%
% Q5: Re-plot the 2D signal, this time with respect to the proper
% frequency vectors. Again, zoom in. Double check your work using the
% frequency of the pattern.

fr=-0.5:1/128:0.5-1/128;
fc=-0.5:1/128:0.5-1/128;
figure(4);
imagesc(fr,fc,abs(Y));
colormap('gray');
colorbar;
xlabel('column frequency');
ylabel('row frequency');
zoom(8);
title('2D FT (magnitude spectrum) of Pattern centered to origin');

%%
% Q6: Time to work backwards... Design an image in FREQUENCY space
% that will return pattern, but rotated 90-degrees. Display the image
% (zoomed if necessary) below.

[fr,fc]=find(abs(Y)>0);
fr=(fr-65)/128;
fc=(fc-65)/128;
R=Y;
specral_line= R(abs(Y)>0);
rotated_xx=@(x,y) abs(specral_line).*cos(2*pi*fr.*y+2*pi*fc.*x+angle(specral_line));
rotated_pic=zeros(128,128);
for i =1:128
    for j=1:128
    rotated_pic(i,j)=sum(rotated_xx(i,j));
    end   
end
figure(5);
imagesc(rotated_pic);
colormap('gray');
colorbar;
axis square;
title('rotated Pattern (designed)');

%%
% Q7: Take the inverse FT of your image and prove that your design
% works. Use subplot to put the frequency and image space images on
% the same figure. 

figure(6); 
subplot(2,1,1);
imagesc(abs(Y')); 
zoom(8); 
colormap('gray'); 
colorbar; 
xlabel('column frequency'); 
ylabel('row frequency'); 
title('rotated image in FREQ space'); 
axis square;
subplot(2,1,2);
X = fftshift(ifft2(Y'));
imagesc(128^2*abs(X));
colormap('gray');
colorbar;
title('rotated image in IMAGE space');
axis square;

%%
% Q8:  CLEANING AN IMAGE CONTAMINATED BY SINUSOIDAL NOISE.
% Read and display an image from file 'hidden_image.jpg'.

figure(7);
t=imread('hidden_image.jpg');
imagesc(t);
title('hidden image');

%%
% Q9: Examine the image.  Use your understanding of the connection
% between the 2-dim cosinusoids and their FT to estimate digital
% spatial frequencies of the cosinusoids contaminating this image and
% to determine where you would find them in the array representing FT
% of this image.

% YOUR ANSWER: The hidden_image is a result of the convolution of pattern
% signal and the rotated pattern signal. The convolution of two signals in
% time domain is equivalent to the multiplication in the frequency domain.
% Thus, the 2D FT of the hidden_image will have 2x2 spectral lines
% (centered DC component is not involved).

%%
% Q10: Take FT of this image and plot the amplitude and phase spectra.
% Hint:  You need to plot the logarithm of the amplitude.

figure(8);
Z=fft2(t);
Z=fftshift(Z);
imagesc(log(abs((Z/128^2))));
colormap('gray');
colorbar;
title('2D FT (magnitude) of hidden image');
xlabel('column frequency');
ylabel('row frequency');
figure(9);
imagesc(angle((Z/128^2)));
colormap('gray');
colorbar;
title('2D FT (phase) of hidden image');
xlabel('column frequency');
ylabel('row frequency');

%%
% Q11: Zoom in on the appropriate part of the amplitude spectrum to
% find the offending sinusoids.

figure(10);
Z=fft2(t);
Z=fftshift(Z);
imagesc(log(abs((Z/128^2))));
zoom(4);
colormap('gray');
colorbar;
title('zoomed 2D FT (magnitude) of hidden image');
xlabel('column frequency');
ylabel('row frequency');
figure(11);
imagesc(angle((Z/128^2)));
zoom(4);
colormap('gray');
colorbar;
title('zoomed 2D FT (phase) of hidden image');
xlabel('column frequency');
ylabel('row frequency');
% The offending frequencies are the five spectral lines.

%%
% Q12: Make changes to the FT of this image to eliminate the
% sinusoidal noise.  Plot the zoomed amplitude spectrum of the result.

for m=1:128
    for n=1:128
if (all([m,n]==[57,57])|all([m,n]==[73,57])|all([m,n]==[65,65])|all([m,n]==[57,73])|all([m,n]==[73,73]))
    no_noise_spectrum(m,n)=0;
else
    no_noise_spectrum(m,n)=Z(m,n);
end
    end
end
figure(12);
imagesc(log(abs(no_noise_spectrum)/128^2));
colormap('gray');
colorbar;
title('noise eliminated 2D FT (phase) of hidden image');
xlabel('column frequency');
ylabel('row frequency');
zoom(4);

%%
% Q13: Perform an inverse FT and examine the resulting image.
% Display the image that was hidden behind the noise.

figure(13);
W = ifft2(ifftshift(no_noise_spectrum));
imagesc(W);
colormap('gray');
colorbar;
title('noise eliminated of hidden image');

%%
% When you are done:
%	* Show the indicated result/figure to the TA during the lab period
%       to receive credit
%	* upload your script to Sakai
%   * upload a pdf containing your script and outputs.
%   * PRINT a copy of your pdf to turn in at the beginning of class on
%     Tuesday









                                                                                                                                                                                                                                                                                                                                                    