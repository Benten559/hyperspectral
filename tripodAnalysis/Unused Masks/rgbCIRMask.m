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
I = RGB;

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.213;
channel1Max = 0.936;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.038;
channel2Max = 0.725;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 0.585;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

% Create mask based on selected regions of interest on point cloud projection
I = double(I);
[m,n,~] = size(I);
polyBW = false([m,n]);
I = reshape(I,[m*n 3]);

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
shiftVec = [0.421217 0.310912 0.334667];
I = I - shiftVec;
I = [I ones(size(I,1),1)]';

% Apply transformation matrix
tMat = [-0.471935 0.607754 0.000000 -0.145648;
    0.567942 0.311129 0.465643 -0.852918;
    -0.448342 -0.245610 0.589859 8.696541;
    0.000000 0.000000 0.000000 1.000000];

J = (tMat*I)';
end

function polyBW = applyPolygons(J,polyBW)

% Define each manually generated ROI
hPoints(1).data = [-0.055322 -0.271930;
    -0.528141 -0.382308;
    -0.566056 -0.896066;
    -0.169066 -1.233220;
    -0.221477 -0.892052];

% Iteratively apply each ROI
for ii = 1:length(hPoints)
    if size(hPoints(ii).data,1) > 2
        in = inpolygon(J(:,1),J(:,2),hPoints(ii).data(:,1),hPoints(ii).data(:,2));
        in = reshape(in,size(polyBW));
        polyBW = polyBW | in;
    end
end

end
