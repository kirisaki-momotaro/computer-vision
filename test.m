clear all;
close all; % closes all figures

image = im2double(rgb2gray(imread('C:\Users\chris\Desktop\COMPUTER VISION\LAB3\test1.jpg')));

[mag,ori]= mygradient(image);

figure(); imagesc(mag);
 colormap('jet') ,title('Magitude');
figure(); imagesc(ori),title('Orientation');
 colormap('hsv');
 H=hog(image);
 w=15;
 V = hogdraw( H, [w] );
 figure(); imagesc(V);
