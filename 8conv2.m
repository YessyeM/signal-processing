% BME671L Lab #8: conv, conv2

% Your name: Jiaxu Meng

clear

%%
% Q1: Use 'imread' command to read file 'dragon.jpg' into array A and display
% A using 'image'. Set the axis so that the image is not distorted.
% Set colormap to 'gray(256)' and add colorbar and the title.

A=imread('dragon.jpg');
figure(1);
image(A);
axis image;colormap('gray(256)');colorbar;title('dragon');

% Q2: Define vector f5 that will hold impulse response of a 5-pt averager:
%	y[n] = (x[n] + x[n-1] + x[n-2] + x[n-3] + x[n-4])/5

f5=[1/5 1/5 1/5 1/5 1/5];

%%
% Q3: Use 'conv2' to apply 5-pt averager for ROWS and COLUMNS of image A.
% Display the result as an image.

figure(2);
B=conv2(f5,f5,A);
image(B);
axis image;colormap('gray(256)');colorbar;title('dragon applied with 5-pt averager');

%%
% Q4: State what the 5-pt averages does to the image. Does this filter
% accentuate low or high frequencies? Explain.

% YOUR ANSWER: This 5-pt averager accentuate low frequencies by filtering
% high frequencies out.

%%
% Q5: The 5-point averager adds a thin dark frame to the image.  Explain why
% this frame is added and why it is dark.  Hint: zoom in on this frame.

% YOUR ANSWER: This 5-pt averager smooths the image.

%%
% Q6: Define vector d1 that will hold impulse response of first-difference
% filter:
%	y[n] = x[n] - x[n-1];	

dl=[1 -1];

%%
% Q7: Use 'conv2' to apply first-difference filter to ROWS only of image A.
% Display the result using:
% * image
% * imagesc

figure(3);
C=conv2(1,dl,A);
image(C);
axis image;colormap('gray(256)');colorbar;title('dragon applied with dl on ROWS by image');
figure(4);
imagesc(C);
axis image;colormap('gray(256)');colorbar;title('dragon applied with dl on ROWS by imagesc');

%%
% Q8: Explain the reason why the result of the first-difference filter
% looks different when it is displayed with 'image' and 'imagesc'.
% Which command should be used and why?

% YOUR ANSWER: 'image' has the same colorbar as the original image in the range
% of (0~+250).
% 'imagesc' adjust the colorbar in the range of (-200~+200) so that it
% centers at 0.
% 'image' is preferred since it makes fully use of the colorbar to have a
% higher contrast.

%%
% Q9: Use 'conv2' to apply first-difference filter to COLUMNS only of image A.
% Display the result as an image.

figure(5);
D=conv2(dl,1,A);
image(D);
axis image;colormap('gray(256)');colorbar;title('dragon applied with dl on COLUMNS by image');
figure(6)
imagesc(D);
axis image;colormap('gray(256)');colorbar;title('dragon applied with dl on COLUMNS by imagesc');

%%
% Q10: State what the first-difference filter does to the image. Does this
% filter accentuate low or high frequencies? Explain.

% YOUR ANSWER: This first-difference filter accentuates high frequencies by filtering
% low frequencies (the backgraound) out.

%% 
% Q11: Load cells.png using 'imread'. This is an image of cells that
% need to be counted and their size quantified for a lab experiment.
% The problem is your program will only count and make measurements on
% binary images (1 or 0). Use your knowledge of filters to create a
% processed image that has all of the cells outlined in black on a
% white surface. (This will not be perfect, I'm looking for the
% general concept, not perfection).

figure(7);
x=imread('cells.png');
imagesc(x);
axis image;colormap('gray(256)');colorbar;title('cells');
figure(7);
F1=imgaussfilt(x);
F2=[1 -1];
Y=conv2(1,F2,F1);
Y=Y(:,1:end-1);
Y(abs(Y)>20)=250;
Y(abs(Y)<20)=0;
imagesc(Y);
axis image;colormap('gray(256)');colorbar;title('binary image');

figure(8);
Z=conv2(F2,1,F1);
Z(abs(Z)>20)=250;
Z(abs(Z)<20)=0;
Z=Z(1:end-1,:);
imagesc(Z);
axis image;colormap('gray(256)');colorbar;title('binary image');

figure(9);
cell_binary=Y+Z;
cell_binary(abs(Y+Z)>50)=0;
cell_binary(abs(Y+Z)<50)=1;
imagesc(cell_binary);
axis image;colormap('gray(256)');colorbar;title('binary image');

%%
% When you are done:
%	* Show the indicated result/figure to the TA during the lab period
%       to receive credit
%	* upload your script to Sakai
%   * upload a pdf containing your script and outputs.
%   * PRINT a copy of your pdf to turn in at the beginning of class on
%     Tuesday

