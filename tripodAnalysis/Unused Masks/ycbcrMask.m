function [BW,maskedRGBImage] = createMask(RGB)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder app. The colorspace and
%  range for each channel of the colorspace were set within the app. The
%  segmentation mask is returned in BW, and a composite of the mask and
%  original RGB images is returned in maskedRGBImage.

% Auto-generated by colorThresholder app on 17-Jul-2021
%------------------------------------------------------


% Convert RGB image to chosen color space
I = rgb2ycbcr(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 0.492;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.428;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.605;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

% Create mask based on selected regions of interest on point cloud projection
I = double(I);
[m,n,~] = size(I);
polyBW = false([m,n]);
I = reshape(I,[m*n 3]);
temp = I(:,1);
I(:,1) = I(:,2);
I(:,2) = I(:,3);
I(:,3) = temp;
clear temp

% Project 3D data into 2D projected view from current camera view point within app
J = rotateColorSpace(I);

% Apply polygons drawn on point cloud in app
polyBW = applyPolygons(J,polyBW);

% Combine both masks
BW = sliderBW & polyBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end

function J = rotateColorSpace(I)

% Translate the data to the mean of the current image within app
shiftVec = [0.537670 0.755671 0.379805];
I = I - shiftVec;
I = [I ones(size(I,1),1)]';

% Apply transformation matrix
tMat = [1.523909 0.115032 -0.000000 -0.553920;
    -0.017699 0.100736 1.002347 -0.541776;
    -0.174601 0.993781 -0.101604 8.273405;
    0.000000 0.000000 0.000000 1.000000];

J = (tMat*I)';
end

function polyBW = applyPolygons(J,polyBW)

% Define each manually generated ROI
hPoints(1).data = [-0.691395 -0.315894;
    -0.691395 -0.491652;
    -0.583379 -0.500765;
    -0.655688 -0.574974;
    -0.664615 -0.821036;
    -0.518212 -0.836659;
    -0.175415 -0.655693;
    -0.123639 -0.526804;
    -0.146849 -0.239081];

% Iteratively apply each ROI
for ii = 1:length(hPoints)
    if size(hPoints(ii).data,1) > 2
        in = inpolygon(J(:,1),J(:,2),hPoints(ii).data(:,1),hPoints(ii).data(:,2));
        in = reshape(in,size(polyBW));
        polyBW = polyBW | in;
    end
end

end
