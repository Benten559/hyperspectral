function [BW,maskedImage] = segCircle(X)
%segmentImage Segment image using auto-generated code from imageSegmenter app
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the imageSegmenter app. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.
%----------------------------------------------------


% Adjust data to span data range.
X = imadjust(X);

% Find circles
[centers,radii,~] = imfindcircles(X,[25 75],'ObjectPolarity','bright','Sensitivity',1.00);
BW = false(size(X,1),size(X,2));
[Xgrid,Ygrid] = meshgrid(1:size(BW,2),1:size(BW,1));
BW = BW | (hypot(Xgrid-centers(1,1),Ygrid-centers(1,2)) <= radii(1));

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end

