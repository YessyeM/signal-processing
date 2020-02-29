% BME671L Lab #10: ECG filtering 

% Your name: Jiaxu Meng

clear

% In this lab we will look at an electrocardiogram and the effects of
% filtering.

%% 
% Q1: electrocardiogram.txt has column headers, and two columns
% separated by a tab. Open the file using a text editor and take a
% look. The first column contains a time vector and the second
% contains the electrical signal in mV. Use 'dlmread' to import the
% raw data using the appropriate options. Store the time series data
% as 'tt' and the electrical signal as 'ecg'. What is the maximum
% frequency we could measure without aliasing?

% reading in the raw data

M = dlmread('electrocardiogram.txt','',2,0);
tt = M(:,1);
ecg = M(:,2);

% YOUR ANSWER: Fs=1/0.002=500Hz
% The maximum frequency without aliasing is Fmax=Fs/2=250Hz

%%
% Q2: Plot the signal. This graph should be 'publishing quality' with
% all axis labeled, units, ect... What types of noise are in this
% signal? Describe how the noise contributes to the general shape of
% the signal.

figure(1);
plot(tt,ecg);
title('raw ECG');xlabel('time(s)');ylabel('voltage(mV)');

% YOUR ANSWER: High-frequency noise at 50-60Hz is due to powerline
% interference.  Low-frequency noise at 0.2Hz is due to respiration.

%% 
% Q3: In order to properly analyze our signal we need to know what
% frequencies we are interested in. First predict the expected
% frequency based on your knowledge of heart rates. The determine the
% fundamental frequency and period of this signal in Hz and s.
% Estimate the peak height (don't forget to subtract the baseline).

% HINT: I like the command 'findpeaks', however there is currently
% tons of high frequency noise. Before peak identification I would
% remove some the noise using a smoothing or averaging filter. We will
% return to the raw data after characterization. 

F1=gausswin(15);
F1_ecg=filter(F1,1,ecg);
figure(2);
[pks,locs]=findpeaks(F1_ecg,'MinPeakDistance',300,'MinPeakHeight',10);
plot(tt,F1_ecg,tt(locs),F1_ecg(locs),'o');
xlabel('time(s)');ylabel('amplitude(mV)');title('Gaussian Filtered ECG');

% after removal of high-frequency noise
% T=1.188-0.312=0.876s
% f=1/T=1/0.876=1.1415Hz

% YOUR ANSWER
% Predicted frequency: 1-1.67Hz
% Frequency: 1.139Hz
% Period: 0.878s
% Peak height: 3.065-1.3=1.765mV

%%
% Q4: Next we will characterize the high frequency noise in the time
% domain. Make a plot of a small portion of the signal that allows you
% to visualize the noise. Using a small portion of the signal
% approximate the frequency and period of the noise.

hfn_t = tt(1:39);
hfn_ecg = ecg(1:39);
figure(3);
plot(hfn_t,hfn_ecg);
xlabel('time(s)');ylabel('amplitude(mV)');title('high frequency noise characterization');

% YOUR ANSWER
% Frequency: f=1/T=1/0.02=50Hz
% Period: T=0.03-0.01=0.02s

%%
% Q5: One low pass filter we discussed during the semester is a moving
% average filter. Using conv, implement a moving average filter that
% covers a time period about 2x greater than the noise period. Plot
% the result.

F2=ones(1,20)/20;
%t=2*0.02=(1:Length)*1/500 -> Length=20
F2_ecg=conv(F2,ecg);
F2_ecg=F2_ecg(1:2048);
figure(4);
[pks,locs]=findpeaks(F2_ecg,'MinPeakDistance',200,'MinPeakHeight',1.5);
plot(tt,F2_ecg,tt(locs),F2_ecg(locs),'o');
xlabel('time(s)');ylabel('amplitude(mV)');title('moving average ECG');

%%
% Q6: Estimate the filtered peak height. Explain any possible down
% sides to filtering using a moving average filter.

% YOUR ANSWER
% peak height: 1.813-1.142=0.671mV
% The overall amplitude is reduced due to the moving average filter.

%% 
% Q7: Throughout the semester we have described signals in both the
% time and frequency domain. Take the Fourier transform of the first
% 2048 points in the signal and store it as f_ecg. Plot the magnitude
% of the Fourier transform of the ecg signal with the x-axis in Hz.
% Using this representation, estimate the frequency of the noise
% present in the signal.

Fs=500;
Ts=1/Fs;
L = 4.094*500;
t = (0:L-1)*Ts;
f = Fs*(-L/2:L/2)/L;
figure(5);
F_ECG=fftshift(fft(ecg)/L);
f_ecg=abs(F_ECG);
[pks,locs]=findpeaks(f_ecg,'MinPeakDistance',10,'MinPeakHeight',0.05);
plot(f,f_ecg,f(locs),f_ecg(locs),'o');
title('FT of raw ECG');xlabel('frequency(Hz)');

% YOUR ANSWER
% Frequency: 50Hz, 100Hz

%% 
% Q8: The simplest way to get rid of the noise is to use a rectangular
% (rect) low pass filter and set all values of the Fourier transform
% to 0 above the cut-off frequency. Design a rect filter, f20, in the
% frequency domain that has a value of 1 when abs(f) < 20 Hz, and 0
% otherwise. Implement the filter using multiplication in the
% frequency domain. Take the inverse Fourier transform of the filtered
% signal and plot the result in the time domain. Again, estimate the
% peak height.

f20=(abs(f)<20);
f20_ecg=f_ecg.*f20';
figure(6);
[pks,locs]=findpeaks(f20_ecg,'MinPeakDistance',10,'MinPeakHeight',0.05);
plot(f,f20_ecg,f(locs),f20_ecg(locs),'o');
xlabel('time(s)');ylabel('amplitude(mV)');title('rect filtered ECG with fc=20Hz');

F20_ECG=F_ECG.*f20';
ifft_f20_ecg=ifft(ifftshift(F20_ECG))*L;
ifft_f20_ecg=abs(ifft_f20_ecg);
figure(7);
plot(tt,ifft_f20_ecg);
xlabel('time(s)');ylabel('amplitude(mV)');title('rect filtered ECG with fc=20Hz');

% YOUR ANSWER
% Peak height: 2.067-1.106=0.961mV

%% 
% Q9: To examine the effect of the filter in the time domain, take the
% inverse Fourier transform of the filter and plot the results in the
% time domain. Use 'xlim' to examine the signal from 1.6 to 2.5s.
% What is multiplication in the frequency domain equivalent to in the
% time domain? 

F3=ifftshift(ifft(ifftshift(f20)));
figure(8);
plot(tt,F3)
xlim([1.6,2.5]);
title('rect filter fc=20Hz in time domain (sinc)');

% YOUR ANSWER: Multiplication in frequency domain is equivalent to
% convolution in time domain.  In the case, rect func in frequency domain
% is equivalent to sinc func in time domain.

%% 
% Q10: The Fourier transform of a sinc function is a rect function. By
% definition, the sinc function extends from -inf to inf, although it
% does decrease in magnitude. Therefore, applying a rect filter in the
% frequency domain can introduce *Gibbs ringing* in the time domain.
% In our signal this is best seen that the beginning of the filtered
% signal, or in between the peaks. Is it possible to implement a true
% rect filter? Why is a filter that extends infinitely not ideal?

% YOUR ANSWER: No. It's possible to implement a true rect filter since
% it requires an infinte sinc func in time domain, which is not possible in
% reality.  
% Although an infinitely extended sinc filter gives sharp rect
% that can remove all high freq components above fc completely, it can only
% approximate to an ideal one.  The infinitely extended sinc filter is
% non-causal filter with an infinite delay, so it's not ideal.

%% 
% Q11: One method to reduce the ringing is to use a wider cut-off
% filter. In the same figure, plot the time signal corresponding to
% the 20 Hz rect filter and a 60 Hz rect filter. Use the results in
% this figure to explain why the stricter filter has more ringing. 

figure(9);
subplot(2,1,1);
f20=double((abs(f)<20));
F3=ifftshift(ifft(ifftshift(f20)));
plot(tt,F3);
title('rect filter fc=20Hz in time domain');axis tight;ylim([-0.05 0.25]);

subplot(2,1,2);
f60=double((abs(f)<60));
F4=ifftshift(ifft(ifftshift(f60)));
plot(tt,F4);
title('rect filter fc=60Hz in time domain');axis tight;ylim([-0.05 0.25]);

figure(10);
subplot(2,1,1);
F20_ECG=F_ECG.*f20';
ifft_f20_ecg=ifft(ifftshift(F20_ECG))*L;
ifft_f20_ecg=abs(ifft_f20_ecg);
plot(tt,ifft_f20_ecg);
xlabel('time(s)');ylabel('amplitude(mV)');title('rect filtered ECG with fc=20Hz');

subplot(2,1,2);
F60_ECG=F_ECG.*f60';
ifft_f60_ecg=ifft(ifftshift(F60_ECG))*L;
ifft_f60_ecg=abs(ifft_f60_ecg);
plot(tt,ifft_f60_ecg);
xlabel('time(s)');ylabel('amplitude(mV)');title('rect filtered ECG with fc=60Hz');

% YOUR ANSWER: A stricter filter in frequency domain(fc=20Hz) indicates a wider filter in time domain.

%% 
% Q12: Play around with different cut off for the rect filter and
% choose one that you think does a decent job of reducing the noise
% while maintaining the original peak magnitudes. Make a plot of the
% filtered signal and report the cut-off frequency and peak height.

figure(11);
f40=double((abs(f)<40));
F40_ECG=F_ECG.*f40';
F5=ifftshift(ifft(ifftshift(f40)));
ifft_f40_ecg=ifft(ifftshift(F40_ECG))*L;
ifft_f40_ecg=abs(ifft_f40_ecg);
plot(tt,ifft_f40_ecg);
xlabel('time(s)');ylabel('amplitude(mV)');title('rect filtered ECG with fc=40Hz');

% YOUR ANSWER:
% cut-off frequency: 40Hz
% peak height: 3.126-1.874=1.252mV

%% 
% Q13: Many people have tried to solve this problem and Matlab is a
% great tool for filter design. Run the 'filterDesigner' command and
% use this to build a filter for the ECG signal. Try and remove both
% the high and low frequency (baseline) noise. Include a plot of your
% final filtered signal. 

Fs = 500;  % Sampling Frequency
Fstop1 = 0.01;        % First Stopband Frequency
Fpass1 = 0.02;         % First Passband Frequency
Fpass2 = 40;          % Second Passband Frequency
Fstop2 = 60;          % Second Stopband Frequency
Astop1 = 80;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 80;          % Second Stopband Attenuation (dB)
match  = 'passband';  % Band to match exactly

% Construct an FDESIGN object and call its CHEBY1 method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
Hd = design(h, 'cheby1', 'MatchExactly', match);

y=filter(Hd,ecg);
figure(12);
plot(tt,y);
title('Filtered ECG');xlabel('time(s)');ylabel('amplitude(mV)');

%%
% When you are done:
%	* Show the indicated result/figure to the TA during the lab period
%       to receive credit
%	* upload your script to Sakai
%   * upload a pdf containing your script and outputs.
%   * PRINT a copy of your pdf to turn in at the beginning of class on
%     Tuesday


