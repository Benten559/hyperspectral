%Batch
files = dir;    % Assumes '.dat' folders within working directory
leafId = {files([files.isdir]).name};
leafId = string(leafId(~ismember(leafId,{'.','..'})));
row = 200:802; % dimensions 
col = 100:780;
rec = [290 279 100 100]; % labeling bounding coordinates         
exposures = string(["leaf_2020_1000ms_80" ,"leaf_2020_200ms_80wl"]);
imgsFolder = string(["leaf_2020_1000ms_80_000000","leaf_2020_200ms_80wl_000000"]);
dat = ["leaf_2020_1000ms_80_000000.dat","leaf_2020_200ms_80wl_000000.dat"];
gain1000ms = [0.000000,0.000000,0.000027,0.000027,0.000027,0.000028,0.000027,0.000027,0.000026,0.000026,0.000026,0.000026,0.000026,0.000026,0.000026,0.000026,0.000026,0.000026,0.000027,0.000028,0.000028,0.000022,0.000022,0.000023,0.000024,0.000026,0.000030,0.000035,0.000035,0.000031,0.000025,0.000022,0.000020,0.000020,0.000020,0.000021,0.000021,0.000021,0.000021,0.000021,0.000021,0.000021,0.000021,0.000022,0.000023,0.000023,0.000022,0.000022,0.000022,0.000022,0.000023,0.000023,0.000024,0.000025,0.000025,0.000025,0.000025,0.000025,0.000025,0.000026,0.000028,0.000029,0.000030,0.000022,0.000022,0.000022,0.000022,0.000023,0.000024,0.000026,0.000027,0.000028,0.000029,0.000030,0.000031,0.000032,0.000033,0.000033,0.000034,0.000035];
dataGain = [0.000000,0.000000,0.000135,0.000134,0.000137,0.000139,0.000137,0.000133,0.000131,0.000132,0.000132,0.000131,0.000130,0.000130,0.000132,0.000132,0.000131,0.000132,0.000135,0.000139,0.000139,0.000110,0.000111,0.000114,0.000119,0.000129,0.000151,0.000177,0.000175,0.000155,0.000125,0.000108,0.000102,0.000101,0.000101,0.000104,0.000106,0.000107,0.000107,0.000105,0.000104,0.000104,0.000107,0.000111,0.000114,0.000114,0.000111,0.000109,0.000108,0.000110,0.000114,0.000117,0.000121,0.000123,0.000123,0.000123,0.000123,0.000124,0.000126,0.000131,0.000138,0.000145,0.000149,0.000108,0.000109,0.000110,0.000112,0.000116,0.000121,0.000128,0.000135,0.000141,0.000147,0.000152,0.000155,0.000158,0.000163,0.000166,0.000171,0.000177];
dataGain(46:80) = gain1000ms(46:80);
wv = [500.0,505.1,510.1,515.2,520.3,525.3,530.4,535.4,540.5,545.6,550.6,555.7,560.8,565.8,570.9,575.9,581.0,586.1,591.1,596.2,601.3,606.3,611.4,616.5,621.5,626.6,631.6,636.7,641.8,646.8,651.9,657.0,662.0,667.1,672.2,677.2,682.3,687.3,692.4,697.5,702.5,707.6,712.7,717.7,722.8,727.8,732.9,738.0,743.0,748.1,753.2,758.2,763.3,768.4,773.4,778.5,783.5,788.6,793.7,798.7,803.8,808.9,813.9,819.0,824.1,829.1,834.2,839.2,844.3,849.4,854.4,859.5,864.6,869.6,874.7,879.7,884.8,889.9,894.9,900.0];
avgxband = zeros(1,80);
idNames = char(leafId);
% averages belonging to the calibration standard at .99 reflectance
sRad = readtable('standardRadAvg.csv','ReadRowNames',true); %indexing: sRad{'row',[1:80]}


% GET .DAT OF BOTH EXPOSURES
for i = 1:length(leafId)
    reflCube = zeros(603,681,80);%data cube to consist of reflectance values WHERE EVERYTHING WILL BE WRITTEN
    id = idNames(:,19:37,i)
    h5create("..\leafh5\" +id + ".h5", '/img',size(reflCube)); % create h5 in parent dir
    datpath1000ms = fullfile(leafId(i),exposures(1),imgsFolder(1),dat(1));
    datpath200ms = fullfile(leafId(i),exposures(2),imgsFolder(2),dat(2));
    % acquire data cubes
    Cube = multibandread(datpath1000ms,[1024,1024,80],'uint16',0','bsq','ieee-be'); % 1000ms initially, to save memory
    ms200Cube = multibandread(datpath200ms,[1024,1024,80],'uint16',0','bsq','ieee-be');
    % interleave by exposure
    Cube(:,:,1:46) = ms200Cube(:,:,1:46);
    Cube = hypercube(Cube,wv);    
    % some preprocess for segmentation input
    Cube = cropData(Cube,row,col);
    rgb = colorize(Cube);
    segX = rgb2lab(rgb);
    % cluster and label
    segmentation = imsegkmeans(single(segX),2,'NumAttempts',8);
    leafSeg = imcrop(segmentation, rec); % focus point is center rectangle
    leafCluster = mode(leafSeg(:));
    % Create logical mask
    % HANDLING THE 4 PROBLEMATIC CASES:
    if id == "200919_113711_ID392" | id == "200919_103106_ID971" | id =="200920_102018_ID491" | id == "200919_094938_ID972"
        segmentation = segmentation ~= leafCluster; % background was already labeled as such
    else
        segmentation = segmentation == leafCluster; % every other image conforms to labeling method
    end
    
    % Overlay circle mask
    [fullCircle,outline] = segCircle(cast(segmentation,'double')); % logical circle outline
    mask = outline >0; %WHEN SEG ~=LEAFCLUSTER, mask is inner circle
    leaf = segmentation ~= mask;
    %store image
    %img = Cube.DataCube(:,:,40);
    %img = imagesc(img.*leaf);
    %img = imshow(img);
    %saveas(img,fullfile('G:\Shared drives\Leaf_cabinet_data\imgFolder',id + string('.jpg'))) ;
    %imwrite(img,fullfile('G:\Shared drives\Leaf_cabinet_data\imgFolder',id + string('.jpg'))) ;
    

    %to do: re-insert 500 & 505 wv's to make length == 80
    for j = 1:length(wv)
        radOffset = sRad{id,j};    %Grab the matching ID's standard for calibration
        reflCube(:,:,j) = Cube.DataCube(:,:,j).*leaf.*dataGain(j).*(.99/radOffset);
    
        % FOR AVERAGING:
        %sumRadiance = sum(img([img~=0]));
        %leafPixels = length(img([img~=0]));
        %avgxband(j) = sumRadiance/leafPixels;
    end
    % store as a h5 binary rep
    h5write("..\leafh5\" +id + ".h5", '/img',reflCube);
    % LOG IMAGE
    %img = imagesc(img.*mask);
    %saveas(img,fullfile('G:\Shared drives\Leaf_cabinet_data\standardImgFolder',id + string('.jpg'))) ;

    % LOG AVERAGES
    %writematrix([id string(avgxband)],'radAvg.csv','WriteMode','append');
    %**Write id's (full name) to column**%
    %writematrix([id],'dateTimeId.csv','WriteMode','append');
    %**Write circular standard radiance averages**%
    %writematrix([id string(avgxband)],'standardRadAvg.csv','WriteMode','append');
    
end
