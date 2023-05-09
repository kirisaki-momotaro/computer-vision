function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%
%
assert(ndims(I)==2,'input image should be grayscale');


sobel_derivative_kernel_y=[1 2 1; 0 0 0;-1 -2 -1];
sobel_derivative_kernel_x=[1 0 -1;2 0 -2;1 0 -1];



dx = imfilter(I,sobel_derivative_kernel_x,'conv','replicate');
dy = imfilter(I,sobel_derivative_kernel_y,'conv','replicate');

[x,y]=size(I);

mag = zeros(x,y);
ori = zeros(x,y);

for i=1:x
    for j=1:y
    mag(i,j)=sqrt(dx(i,j)^2+dy(i,j)^2);
    ori(i,j)=atand(dy(i,j)/dx(i,j));
    end
end

assert(all(size(mag)==size(I)),'gradient magnitudes should be same size as input image');
assert(all(size(ori)==size(I)),'gradient orientations should be same size as input image');
