% BME671L Lab #9: frequency response

% Your name: Jiaxu Meng

clear

% In this lab we will analyze a system with the following frequency
% response as a function of w in radians/sample:
% H(w) = jw/(1 + j*w)
% 
% The input to the system is x(t) = 4*cos(4*pi*t - pi/6), and the
% function is sampled at fs = 16 samples/second.


%% 
% Q1: Define the frequency response as a function with w as a parameter

% Define H(w)
H = @(w) 1j * w./(1 + 1j * w);

%% 
%Q2: Define the vectors wx and X that store the frequencies and 
% phasors of the input

wx=[-pi/4 pi/4]; 
X=[2*exp(1/6*1i*pi) 2*exp(-1/6*1i*pi)]; 
wc=-8*pi:0.1:8*pi;

%%
% Q3: Using H and vectors wx and X compute the phasors of the output
% and store them in vector Y

H_wc=1j*wc./(1+1j*wc); 
H_wx=1j*wx./(1+1j*wx); 
Y=X.*H_wx;

%%
% Q4: Plot the spectra of the systems frequency response of the input
% and of the output in one figure with 6 subplots
%   * In all plots use the range of frequencies from [-pi, pi]
%   * Row 1: amplitude and phase sepectra of the system's frequency
%   resoponse H(w).
%   * On the spectra of H(w) mark the values corresponding to
%   frequencies present in the input with a red 'o'
%   * Row 2: amplitude and phase spectrum of the input x[n]
%   * Row 3: amplitude and phase sepctrum of the output y[n]
%   * Make sure that the input and output have the same vertical
%   scale. Label axis and/or add titles where appropriate. Add grid
%   lines.

figure(1); 
subplot(3,2,1); 
mag_H=abs(H_wc); 
plot(wc,mag_H);hold on;plot(wx,abs(H(wx)),'ro'); 
xlabel('w');ylabel('mag H');title('amplitude spectrum of H');grid on;xlim([-pi pi]);ylim([0 3]); 

subplot(3,2,2); 
phase_H=angle(H_wc); 
plot(wc,phase_H);hold on;plot(wx,angle(H(wx)),'ro'); 
xlabel('w');ylabel('phase H');title('phase spectrum of H');grid on;xlim([-pi pi]);ylim([-pi/2 pi/2]); 

subplot(3,2,3); 
mag_X=abs(X); 
stem(wx,mag_X); 
xlabel('w');ylabel('mag X');title('amplitude spectrum of X');grid on;xlim([-pi pi]);ylim([0 3]); 

subplot(3,2,4);
phase_X=angle(X); 
stem(wx,angle(X)); 
xlabel('w');ylabel('mag X');title('phase spectrum of X');grid on;xlim([-pi pi]);ylim([-pi/2 pi/2]);

subplot(3,2,5); 
mag_Y=abs(Y); 
stem(wx,mag_Y); 
xlabel('w');ylabel('mag Y');title('amplitude spectrum of Y');grid on;xlim([-pi pi]);ylim([0 3]); 

subplot(3,2,6); 
phase_Y=angle(Y); 
stem(wx,angle(Y)); 
xlabel('w');ylabel('mag Y');title('phase spectrum of Y');grid on;xlim([-pi pi]);ylim([-pi/2 pi/2]);

% ********************************************************************
%   SHOW YOUR FIGURE TO THE TA TO RECEIVE CREDIT FOR THE LAB
% ********************************************************************

%% 
% Q5: How are the magnitude and phase of the input and frequency
% response function combined to determine the output?

% YOUR ANSWER: % YOUR ANSWER: The output is determined by y[n]=H(w_hat)*x[n] when x[n] is % in terms of X*e^(j*w_hat*n).  Thus, % y[n]=mag(H(w_hat))*X*e^(j*w_hat*n+phase(H(w_hat))).
% In this case, the input phasors are 2*exp(1/6*1i*pi), 2*exp(-1/6*1i*pi) % and the sampling frequency is 16 samples/s -> w_hat=2*pi*2/16=pi/4. % So, the output phasors are H(pi/4)*2*exp(1/6*1i*pi),H(pi/4)*2*exp(-1/6*1i*pi)

%%
% Q6: Reconstruct the input and output as a function of time over 4
% periods (start at t = 0). Plot x(t) and t(t) on the same graph, add
% grid lines, legend, and axis labels.

figure(2); 
t=0:0.01:2; 
x_t=4*cos(4*pi*t-pi/6); 
plot(t,x_t); 
hold on; 
y_t=@(t)abs(Y').*cos((wx')*16*t+angle(Y')); 
plot(t,sum(y_t(t))); 
xlabel('t(s)');ylabel('amplitude');title('reconstruct of x and y');grid on;legend('x','y');

%% 
% Q7: Is this a high-pass or low-pass filter?

% YOUR ANSWER: This is a high-pass filter, meaning that the filter % accentuates high frequency signals, which can be seen from the magnitude % plot of H in Q4.

%%
% When you are done:
%	* Show the indicated result/figure to the TA during the lab period
%       to receive credit
%	* upload your script to Sakai
%   * upload a pdf containing your script and outputs.
%   * PRINT a copy of your pdf to turn in at the beginning of class on
%     Tuesday


