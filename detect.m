
function [x,y,score] = detect(I,template,ndet)
%
% return top ndet detections found by applying template to the given image.
%   x,y should contain the coordinates of the detections in the image
%   score should contain the scores of the detections
%


% compute the feature map for the image
f = hog(I);


size(f,1)
size(f,2)
nori = size(f,3)




% cross-correlate template with feature map to get a total response
R = zeros(size(f,1),size(f,2));
for i = 1:nori
  R = R + imfilter(f(:,:,i),template(:,:,i),'corr','replicate');
end

% now return locations of the top ndet detections

% sort responses from high to low
[val,ind] = sort(R(:),'descend');
val(1:10)
ind(1:10)
% work down the list of responses, removing overlapping detections as we go
i = 1;
detcount = 0;
x = zeros(ndet,1);
y = zeros(ndet,1);
score = zeros(ndet,1);
while ((detcount < ndet) & (i <= length(ind)))
  % convert ind(i) back to (i,j) values to get coordinates of the block
  
  xblock=ceil(ind(i)/size(R,1));
  if(rem(ind(i),size(R,1))==0)
      yblock=size(R,1);
  else
      yblock=rem(ind(i),size(R,1));
  end
  ind(i)
  size(R,1)
  size(R,2)
  %[yblock,xblock]=find(R==val(i))
     
  assert(val(i)==R(yblock,xblock)); %make sure we did the indexing correctly

  % now convert yblock,xblock to pixel coordinates 
  %ypixel = size(im2col([yblock,xblock],[8 8],'distinct'),2)
  %xpixel = size(im2col([yblock,xblock],[8 8],'distinct'),1)
    ypixel=yblock*8;
    xpixel=xblock*8;
  B=[ypixel,xpixel];
  % check if this detection overlaps any detections which we've already added to the list
  % you should do this by comparing the x,y coordinates of the new candidate detection to all 
  % the detections previously added to the list and check if the distance between the 
  % detections is less than 70% of the template width/height
  
  [h,w]=size(template);
  %not sure if i or detcount is needed
  %overlap = ([ypixel,xpixel]==R(detcount+1)) & (pdist2(R(detcount+1),R(detcount+1))>0.7*w);
  overlap=0;
  for j=1:length(x)
      if((norm([ypixel,xpixel]-[y(j),x(j)]))<0.7*w)
          overlap=1;
      end
  end
  
  % if not, then add this detection location and score to the list we return
  if (overlap==0)    
    detcount = detcount+1;
    x(detcount) = xpixel;
    y(detcount) = ypixel;
    
%    score(detcount) = ...
    
  end
  i = i + 1;
end

% the while loop may terminate before we find the desired number
% of detections... in that case you should shrink the vectors
% x,y,score down to the correct size

[h1,w1] = size(I); 
h2  = ceil(h1/8); 
w2  = ceil(w1/8);
%res = reshape(sum(B),[h2,w2]);   %not sure


assert(length(x)==detcount);
assert(length(y)==detcount);
%assert(length(score)==detcount);

end
