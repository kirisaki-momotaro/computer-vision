%
% This is a simple test script to exercise the detection code.
%
% It assumes that the template is exactly 16x16 blocks = 128x128 pixels.  
% You will want to modify it so that the template size in blocks is a
% variable you can specify in order to run on your own test examples
% where you will likely want to use a different sized template
%


%CHOOSE BLOCK SIZE
block_size_x=16;
block_size_y=16;

% load a training example image
Itrain = im2double(rgb2gray(imread('C:\Users\chris\Desktop\COMPUTER VISION\LAB3\faces2.jpg')));

%have the user click on some training examples.  
% If there is more than 1 example in the training image (e.g. faces), you could set nclicks higher here and average together
nclick = 4;
figure(1); clf;
imshow(Itrain);
title(['select what you want: ' num2str(nclick)  ' clicks']);
[x,y] = ginput(nclick); %get nclicks from the user

%compute 8x8 block in which the user clicked
blockx = round(x/8);
blocky = round(y/8); 

%visualize image patch that the user clicked on
% the patch shown will be the size of our template
% since the template will be 16x16 blocks and each
% block is 8 pixels, visualize a 128pixel square 
% around the click location.
figure(2); clf;
for i = 1:nclick
  patch = Itrain(8*blocky(i)+(-(((8*block_size_y)/2)-1):(8*block_size_y)/2),8*blockx(i)+(-(((8*block_size_x)/2)-1):(8*block_size_x)/2));
  figure(2); subplot(3,2,i); imshow(patch);
end

% compute the hog features
f = hog(Itrain);

% compute the average template for the user clicks
postemplate = zeros(block_size_x,block_size_y,9);
for i = 1:nclick
  postemplate = postemplate + f(blocky(i)+(-(((block_size_x)/2)-1):(block_size_x)/2),blockx(i)+(-(((block_size_y)/2)-1):(block_size_y)/2),:); 
end
postemplate = postemplate/nclick;






%NEGATIVE TEMPLATE

% TODO: also have the user click on some negative training
% examples.  (or alternately you can grab random locations
% from an image that doesn't contain any instances of the
% object you are trying to detect).
Itrain = im2double(rgb2gray(imread('C:\Users\chris\Desktop\COMPUTER VISION\LAB3\faces1.jpg')));

nclickn = 6;
figure(3); clf;
imshow(Itrain);
title(['select what you dont want: ' num2str(nclickn)  ' clicks']);
[xn,yn] = ginput(nclickn); %get nclicks from the user

%compute 8x8 block in which the user clicked
blockxn = round(xn/8);
blockyn = round(yn/8); 

%visualize image patch that the user clicked on
% the patch shown will be the size of our template
% since the template will be 16x16 blocks and each
% block is 8 pixels, visualize a 128pixel square 
% around the click location.
figure(4); clf;
for i = 1:nclickn
  patch = Itrain(8*blockyn(i)+(-(((8*block_size_y)/2)-1):(8*block_size_y)/2),8*blockxn(i)+(-(((8*block_size_x)/2)-1):(8*block_size_x)/2));
  figure(4); subplot(3,2,i); imshow(patch);
end

% compute the hog features
f = hog(Itrain);

% compute the average template for the user clicks
negtemplate = zeros(block_size_x,block_size_y,9);
for i = 1:nclickn
  negtemplate = negtemplate + f(blockyn(i)+(-(((block_size_x)/2)-1):(block_size_x)/2),blockxn(i)+(-(((block_size_y)/2)-1):(block_size_y)/2),:); 
end
negtemplate = negtemplate/nclickn;


% now compute the average template for the negative examples


% our final classifier is the difference between the positive
% and negative averages
template = postemplate - negtemplate;
%template = postemplate;


%
% load a test image
%
Itest= im2double(rgb2gray(imread('C:\Users\chris\Desktop\COMPUTER VISION\LAB3\faces1.jpg')));


% find top 8 detections in Itest
ndet = 8;
[x,y,score] = detect(Itest,template,ndet);
ndet = length(x)


%display top ndet detections
figure(3); clf; imshow(Itest);
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  hold on; 
  h = rectangle('Position',[x(i)-(8*block_size_x)/2 y(i)-(8*block_size_y)/2 8*block_size_x 8*block_size_y],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
  hold off;
end
